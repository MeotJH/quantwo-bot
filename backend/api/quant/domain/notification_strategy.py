from dataclasses import dataclass
from datetime import datetime
from api.notification.models import Notification
from api.notification.services import NotificationService
from api.quant.domain.entities import Quant
from api.quant.domain.quant_type import QuantType
from api.quant.dual_momentum_services import get_todays_dual_momentum

class NotificationStrategy:

    @classmethod
    def _calculate_trend_follow_strategy(cls,quant: Quant, stock: dict):
        # Implement your profit calculation logic here
        return None

    @classmethod
    def _calculate_dualmomentum_intl_strategy(cls,quant: Quant, stock: dict):
        
        momentum = get_todays_dual_momentum(saved_symbol=quant.stock
                                 ,etf_symbols=['SPY', 'FEZ', 'EWJ', 'EWY']
                                 ,savings_rate=3.0)
        
        if momentum.should_rebalance:
            notification_content = f'이달의 듀얼모멘텀 결과: {momentum.recommendation}가 상대적으로 강세입니다.'
        else:
            notification_content = f'{datetime.now().month}월에는 포트폴리오 변경 없이 기존 구성을 유지하는 것이 권장됩니다.'
        
        notification = Notification(
            title=f"퀀투봇 [{QuantType(quant.quant_type).kor}]",
            body=notification_content,
            user_mail=quant.user.email
        )
        print(f'notification content :::::: {notification_content}')
        #NotificationService().send_notification(notification)
    
    @classmethod
    def calculate_profit(cls, quant: Quant, stock: dict):
        try:
            strategy_func = cls.strategy_calculators[quant.quant_type]
            return strategy_func(quant, stock)
        except KeyError:
            raise ValueError(f"Unsupported quant type: {quant.quant_type}")

NotificationStrategy.strategy_calculators = {
    QuantType.TREND_FOLLOW.value: NotificationStrategy._calculate_trend_follow_strategy,
    QuantType.DUAL_MOMENTUM_INTERNATIONAL.value: NotificationStrategy._calculate_dualmomentum_intl_strategy,
}

