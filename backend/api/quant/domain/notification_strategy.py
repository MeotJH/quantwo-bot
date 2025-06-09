from dataclasses import dataclass
from datetime import datetime
from api.notification.models import Notification
from api.notification.services import NotificationService
from api.quant.domain.entities import Quant
from api.quant.domain.model import TrendFollowRequestDTO
from api.quant.domain.quant_type import QuantType
from api.quant.domain.trend_follow import TrendFollow
from api.quant.dual_momentum_services import get_todays_dual_momentum
from util.logging_util import logger
from util.transactional_util import transaction_scope

class NotificationStrategy:

    @classmethod
    def _calculate_trend_follow_strategy(cls,quant: Quant):
        """
        추세추종 전략 알림로직
        """
        dto = TrendFollowRequestDTO(
             asset_type="US".upper()
            ,ticker=quant.stock.upper()
            )
        stock_data = TrendFollow._get_stock(
                        dto, period='1y', trend_follow_days=75
                    )['stock_data']
        today_stock = stock_data.iloc[-1]

        logger.info(f"today_stock: {today_stock}")
        if cls._should_notify(quant, today_stock):
            with transaction_scope():
                quant.current_status = 'BUY' if today_stock['Close'] > today_stock["Trend_Follow"] else 'SELL'
                logger.info(f'this is quant.user.email: {quant.user.email}')
                notification = Notification(
                    title=f"퀀투봇 [{QuantType(quant.quant_type).kor}]",
                    body=f"저장하신 {quant.stock}의 상태변경이 감지되었습니다. 확인해주세요.",
                    user_mail=quant.user.email
                )

                NotificationService().send_notification(notification)
    
    @classmethod
    def _should_notify(cls, quant: Quant, today_stock: dict) -> bool:
        logger.info("Quant Scheduler started")

        if not quant.notification:
            logger.info("User Doesn't want Notification")
            return False

        try:
            close = today_stock['Close']
            trend = today_stock['Trend_Follow']
        except KeyError:
            logger.warning("today_stock 데이터에 필드가 부족합니다.")
            return False

        diff_ratio = abs(close - trend) / trend
        if diff_ratio < 0.01:
            logger.info("변동폭이 작아 알림 생략")
            return False

        current_status = 'BUY' if close >= trend else 'SELL'

        if current_status != quant.current_status:
            logger.info(f"상태 변경 감지: {quant.current_status} → {current_status} ::::: 알림상태 True 알림 실행")
            return True

        logger.info(f"상태 동일: {quant.current_status} , {current_status}::::: 알림상태 False 생략")
        return False


    @classmethod
    def _calculate_dualmomentum_intl_strategy(cls,quant: Quant):
        """
            국제 듀얼모멘텀 전략 알림로직
        """
        momentum = get_todays_dual_momentum(
                                saved_symbol=quant.stock
                                 ,etf_symbols=['SPY', 'FEZ', 'EWJ', 'EWY']
                                 ,savings_rate=3.0
                                 )
        
        if momentum.should_rebalance:
            notification_content = f'이달의 듀얼모멘텀 결과: {momentum.recommendation}가 상대적으로 강세입니다.'
        else:
            notification_content = f'{datetime.now().month}월에는 포트폴리오 변경 없이 기존 구성을 유지하는 것이 권장됩니다.'
        
        notification = Notification(
            title=f"퀀투봇 [{QuantType(quant.quant_type).kor}]",
            body=notification_content,
            user_mail=quant.user.email,
            url='/profile'
        )

        logger.info(f'notification content :::::: {notification_content}')
        NotificationService().send_notification(notification)
    
    @classmethod
    def calculate_strategy(cls, quant: Quant):
        """
            전략별 분기하는 함수
        """
        try:
            strategy_func = cls.strategy_calculators[quant.quant_type]
            return strategy_func(quant)
        except KeyError:
            raise ValueError(f"Unsupported quant type: {quant.quant_type}")

NotificationStrategy.strategy_calculators = {
    QuantType.TREND_FOLLOW.value: NotificationStrategy._calculate_trend_follow_strategy,
    QuantType.DUAL_MOMENTUM_INTERNATIONAL.value: NotificationStrategy._calculate_dualmomentum_intl_strategy,
}

