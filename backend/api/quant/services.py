from dataclasses import asdict
import traceback
from api.quant.domain.value_objects.model import QuantData, TrendFollowRequestDTO
from flask_jwt_extended import get_jwt_identity

from api import db
from api.quant.domain.entities import Quant
from api.quant.domain.value_objects.quant_type import QuantType
from api.quant.dual_momentum_services import get_todays_dual_momentum
from api.quant.repository.market_data.mappers.stock_info_wrapper import AssetType
from api.quant.domain.services.trend_follow import TrendFollow
from api.quant.repository.database.quant_repository_impl import QuantRepositoryImpl
from api.quant.repository.market_data.yahoo_finance_client import YahooFinanceClient
from api.stock.repository.yfinance_api_client_impl import YFinanceApiClientImpl
from api.user.entities import User
from api.notification.entities import NotificationEntity
from api.quant.domain.services.notification_strategy import NotificationStrategy
from exceptions import AlreadyExistsException, BadRequestException
from util.logging_util import logger
from util.transactional_util import transaction_scope
import uuid

from api.quant.domain.services.profit import calculate_profit
from sqlalchemy.orm import joinedload

#admin_notify_test용
from api.notification.models import Notification
from api.notification.services import NotificationService

from datetime import datetime
from typing import List, Dict, Any
from api.quant.domain.services.dual_momentum import DualMomentumBacktest
from api import cache
from api.quant.domain.value_objects.model import RebalancingRecommendation


class QuantService:

    internationals = ['SPY', 'FEZ', 'EWJ', 'EWY']

    @staticmethod
    def find_stock_by_id(dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        if dto.asset_type == 'CRYPTO':
            dto.ticker = f'{dto.ticker}-USD'

        trend_follow = TrendFollow(market_data_client=YahooFinanceClient())
        return trend_follow.find_stock_by_id(dto=dto, period=period, trend_follow_days=trend_follow_days)

    @staticmethod
    def register_quant_by_stock(stock: str, quant_data: QuantData):
        jwt_user = get_jwt_identity()
        user = User.query.filter_by(email=jwt_user).first()

        quant = Quant.query.filter_by(stock=stock, user_id=user.uuid, quant_type=quant_data.quant_type ).first()
        quant_cnt = Quant.query.filter_by(user_id=user.uuid).count()
        logger.info(f'저장된 퀀트는 {quant_cnt}개 입니다.')

        if quant is not None:
            raise AlreadyExistsException('이미 존재하는 퀀트입니다.', 409)
        
        # if quant_cnt >= 5 :
        #     raise BadRequestException('❗최대 5개까지 등록할 수 있어요', 409)

        if user is None:
            return {"error": "User not found"}

        new_quant = Quant(
            stock=stock,
            quant_type=quant_data.quant_type,
            initial_price=quant_data.initial_price,
            initial_trend_follow=quant_data.initial_trend_follow,
            initial_status=quant_data.initial_status,
            current_status=quant_data.initial_status,
            notification=True,
            user_id=user.uuid
        )
        
        with transaction_scope():
            db.session.add(new_quant)
            return new_quant.to_dict()

    @staticmethod
    def find_quants_by_user():
        jwt_user = get_jwt_identity()
        user = User.query.filter_by(email=jwt_user).first()
        quants = QuantRepositoryImpl().find_by_user_uuid(user_uuid=user.uuid)


        quants_dict = []
        for quant in quants:
            stock_id = quant.stock
            dto =  TrendFollowRequestDTO(
                asset_type=AssetType.US.name,
                ticker=stock_id.upper()
            )
            stock = QuantService.find_stock_by_id(dto)
            
            
            # 수익 및 수익률 계산
            profits = calculate_profit(quant,stock)

            # 결과 출력
            quant_one = {
                "id": quant.uuid,
                "ticker": quant.stock,
                "name": stock["stock_info"]["longName"],
                "profit": round(profits.profit, 2),
                "profit_percent":  round(profits.profit_percent, 2),
                "notification" : quant.notification,
                "quant_type" : quant.quant_type,
                "current_status" : quant.current_status,
                "initial_status" : quant.initial_status,
            }
            
            logger.info(f'this is quant_one: {quant_one}')
            quants_dict.append(quant_one)

        return quants_dict


    @staticmethod
    def patch_quant_by_id(quant_id):
        print(f'patching quant by id: {quant_id}')

        quant = Quant.query.filter_by(uuid=uuid.UUID(quant_id)).first()
        if quant is None:
            raise BadRequestException('퀀트를 찾을 수 없습니다.', 400)
        
        with transaction_scope():
            quant.notification = not quant.notification
        #db.session.commit()
            return quant.to_dict()

    @staticmethod
    def delete_quant_by_id(quant_id):
        quant = Quant.query.filter_by(uuid=uuid.UUID(quant_id)).first()
        if quant is None:
            raise BadRequestException('퀀트를 찾을 수 없습니다.', 400)
        
        with transaction_scope():
            db.session.delete(quant)
            #db.session.commit()
            return quant.to_dict()

    def check_and_notify(self, notify_quant_type : QuantType):
        try:
            logger.info("check_and_notify scheduling 시작중...")
            #notification 에서 알림 on한 객체들을 모은다.
            notification_enabled = NotificationEntity.query.filter_by(enabled=True).all()
            notification_enabled_set = {n.user_id for n in notification_enabled}

            #quant에서 알림 on 한 객체들을 quant_type별로 가져온다.
            quants = Quant.query.options(joinedload(Quant.user)).filter_by(notification=True,quant_type=notify_quant_type.value).all()

            #notification on한 quant들만 필터링한다.  
            filtered_quants = [quant for quant in quants if quant.user_id in notification_enabled_set]

            #총 몇건보내는지 누구에게 보내는지 로깅
            filtered_mail_from_quant_entity = {n.user.email for n in filtered_quants}
            logger.info(f"{len(filtered_quants)}개의 알림이 있는 항목을 찾았습니다")
            logger.info(f"mail 보낼 유저 타겟 ::{filtered_mail_from_quant_entity}")

            for quant in filtered_quants:
                #전략에 따라서 알림보낸다.
                NotificationStrategy.calculate_strategy(quant=quant)
                        
        except Exception as e:
            logger.error(f"Error in check_and_notify: {str(e)}")
            logger.error(traceback.format_exc())
        finally:
            logger.info(f"check_and_notify {notify_quant_type} scheduling 종료 ")
    
    @staticmethod
    def save_dual_momentum(type: str):
        momentum = get_todays_dual_momentum('cash', QuantService.internationals, 3.0)
        logger.info(f'this is momentum: {asdict(momentum)}')
        quant_data = QuantData(
            stock=momentum.recommendation,
            quant_type=type,
            initial_price= momentum.best_return,
            initial_status=momentum.recommendation,
            initial_trend_follow=0.0,
        )
        return QuantService.register_quant_by_stock(momentum.recommendation, quant_data)

    def find_trend_follows(self):
        trend_follow = TrendFollow(market_data_client=YFinanceApiClientImpl())
        fetched_trend_follow = trend_follow.fetch_lists()
        return fetched_trend_follow

