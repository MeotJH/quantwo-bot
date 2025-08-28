from abc import ABC, abstractmethod
from typing import Any, Dict, List

from api.stock.models import Stock


class ExternalApiClient(ABC):

    @abstractmethod
    def get_stocks(self) -> List[Stock]:
        """현재 주식 list 조회"""
        pass


    @abstractmethod
    def get_cryptos(self) -> List:
        """현재 암호화폐 list 조회"""
        pass