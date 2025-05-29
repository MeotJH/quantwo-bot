from dataclasses import dataclass
from typing import Dict, Optional

@dataclass
class QuantData:
    stock: str
    quant_type: str
    initial_price: float
    initial_trend_follow: float
    initial_status: str

@dataclass
class RebalancingRecommendation:
    date: str
    recommendation: str
    returns: Dict[str, float]
    best_return: float
    cash_return: float
    should_rebalance: bool
    error: Optional[str] = None

@dataclass
class TrendFollowRequestDTO:
    asset_type: str
    ticker: str

@dataclass
class StockInfoModel:
    shortName: str
    currentPrice: float
    previousClose: float
    open: float
    volume: float
    dayHigh: float
    dayLow: float
    trailingPE: float
    fiftyTwoWeekHigh: float
    fiftyTwoWeekLow: float
    trailingEps: float
    enterpriseValue: float
    ebitda: float
    lastCrossTrendFollow: float = 0.0 