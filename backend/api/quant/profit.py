from dataclasses import dataclass
from api.quant.entities import Quant

@dataclass
class ProfitResult:
    profit: float
    profit_percent: float

def calculate_dualmomentum_intl_profit(quant: Quant, stock: dict):
    # Implement your profit calculation logic here
    return ProfitResult(profit=quant.initial_price, profit_percent=quant.initial_price)


def calculate_trend_follow_profit(quant: Quant, stock: dict):
    recent_stock = stock["stock_info"]

    # 모델에서 가져온 값을 가정
    previous_close = float(recent_stock['previousClose'])  # 모델에서 previousClose 값을 가져옴
    last_cross_trend_follow = float(recent_stock['lastCrossTrendFollow'])  # 모델에서 lastCrossTrendFollow 값을 가져옴

    profit = previous_close - last_cross_trend_follow
    profit_percent = (profit / previous_close) * 100
    return ProfitResult(profit=profit, profit_percent=profit_percent)

profit_calculators = {
    "TF": calculate_trend_follow_profit,
    "DM-INTL": calculate_dualmomentum_intl_profit,
}

def calculate_profit(quant: Quant,stock: dict):
    try:
        return profit_calculators[quant.quant_type](quant,stock)
    except KeyError:
        raise ValueError("Unsupported profit type")
