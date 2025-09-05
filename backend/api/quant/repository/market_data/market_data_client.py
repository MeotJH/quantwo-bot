from abc import ABC, abstractmethod

from api.quant.domain.value_objects.model import TrendFollowRequestDTO


class MarketDataClient(ABC):

    @abstractmethod
    def get_stocks(self, dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75) -> dict:
        """현재 주식 list 조회"""
        pass

    @abstractmethod
    def get_close_prices(self,etf_symbols: list, start_date_str: str, end_date_str: str) -> dict:
        """현재 주식 list 조회"""
        pass