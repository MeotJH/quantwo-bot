from dataclasses import dataclass, asdict
from datetime import datetime

@dataclass
class TradingPeriod():
    date: datetime
    best_etf: str
    six_month_return: float  # 6m_return -> 변수명으로 사용 가능하게 변경
    capital: float
    cash_hold: float
    ewy_hold: float

    def to_dict(self):
        return asdict(self);

    @classmethod
    def from_cash_hold(cls, date: datetime, capital: float = 0.0,
                      cash_capital: float = 0.0, buy_and_hold_capital: float = 0.0):
        return cls(
            date=date,
            best_etf='cash',
            six_month_return=0.0,
            capital=capital,
            cash_hold=cash_capital,
            ewy_hold=buy_and_hold_capital
        )

    @classmethod
    def from_calculation(cls, date: datetime, monthly_returns, returns,
                         capital: float, cash_capital: float, buy_and_hold_capital: float):
        """계산을 통해 레코드 생성"""
        best_etf = monthly_returns.idxmax()

        return cls(
            date=date,
            best_etf=best_etf.lower(),
            six_month_return=float(returns[best_etf]),
            capital=capital,
            cash_hold=cash_capital,
            ewy_hold=buy_and_hold_capital
        )