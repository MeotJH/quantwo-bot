from dataclasses import dataclass
from api.quant.domain.entities import Quant
from api.quant.domain.value_objects.quant_type import QuantType
from api.quant.dual_momentum_services import get_todays_dual_momentum

@dataclass
class ProfitResult:
    profit: float
    profit_percent: float

#듀얼모멘텀 수익률 계산
def calculate_dualmomentum_intl_profit(quant: Quant, stock: dict):
    # Implement your profit calculation logic here
    momentum = get_todays_dual_momentum('cash', ['SPY', 'FEZ', 'EWJ', 'EWY'], 3.0)
    #profit =  momentum.best_return - quant.initial_price
    return ProfitResult(profit=momentum.best_return, profit_percent=momentum.best_return)

#추세추종 수익률 계산
def calculate_trend_follow_profit(quant: Quant, stock: dict):
    recent_stock = stock["stock_info"]

    # 모델에서 가져온 값을 가정
    previous_close = float(recent_stock['currentPrice'])  # 모델에서 previousClose 값을 가져옴
    last_cross_trend_follow = float(recent_stock['lastCrossTrendFollow'])  # 모델에서 lastCrossTrendFollow 값을 가져옴

    profit = previous_close - last_cross_trend_follow
    profit_percent = (profit / previous_close) * 100
    return ProfitResult(profit=profit, profit_percent=profit_percent)

profit_calculators = {
    QuantType.TREND_FOLLOW.value: calculate_trend_follow_profit,
    QuantType.DUAL_MOMENTUM_INTERNATIONAL.value: calculate_dualmomentum_intl_profit,
}

def calculate_profit(quant: Quant,stock: dict):
    try:
        print(f'this is QuantType.TREND_FOLLOW.value :::: {QuantType.TREND_FOLLOW.value}')
        return profit_calculators[quant.quant_type](quant,stock)
    except KeyError:
        raise ValueError("Unsupported profit type")
