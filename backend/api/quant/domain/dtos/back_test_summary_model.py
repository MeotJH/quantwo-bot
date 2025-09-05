from dataclasses import dataclass, asdict
from typing import Union


@dataclass
class BackTestSummaryModel:
    initial_capital: float
    final_capital: float
    total_return: float
    cash_hold_return: float
    ewy_hold_return: float
    final_best_etf: str = 'EMPTY'

    def to_dict(self):
        return asdict(self)

    @classmethod
    def of_empty(cls, config):
        return cls(
            initial_capital=config.initial_capital,
            final_capital=config.initial_capital,
            total_return=0,
            cash_hold_return=0,
            ewy_hold_return=0
        )

    @classmethod
    def of_calculation(cls, config, final_capital: float, final_cash: float,
                         final_ewy: float, final_best_etf: str, today_best_profit: float):
        return cls(
            initial_capital=config.initial_capital,
            final_capital=final_capital,
            total_return=float((final_capital / config.initial_capital - 1) * 100),
            cash_hold_return=float((final_cash / config.initial_capital - 1) * 100),
            ewy_hold_return=float((final_ewy / config.initial_capital - 1) * 100),
            final_best_etf=final_best_etf,
            today_best_profit=today_best_profit
        )