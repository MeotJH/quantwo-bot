from dataclasses import dataclass


@dataclass
class StockInfoModel:
    longName:str
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