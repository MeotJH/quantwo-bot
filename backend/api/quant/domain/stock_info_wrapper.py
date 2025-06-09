from enum import Enum

from api.quant.domain.data_source_parser import from_yahoo_crypto, from_yahoo_us
from api.quant.domain.model import StockInfoModel
from api.quant.domain.quant_type import AssetType, DataSource


class StockInfoWrapper:
    _dispatch_table = {
        (DataSource.YAHOO, AssetType.US): from_yahoo_us,
        (DataSource.YAHOO, AssetType.CRYPTO): from_yahoo_crypto,
        # 추후 확장 가능
        # ("coinmarketcap", "coin"): ...
    }

    @classmethod
    def from_source(cls, source: str, category: str, raw_data: dict) -> StockInfoModel:
        request = StockInfoWrapper.parse_request(source,category)
        """
        wrapping해서 datasource(apireturn값)와 assetType(us,crypto...)에 따라 동적으로 반환값을 바꿔주는 함수
        """
        key = (request[0], request[1])
        parser = cls._dispatch_table.get(key)
        if not parser:
            raise ValueError(f"Unsupported source/category: {key}")
        return parser(raw_data)
    
    @classmethod
    def parse_request(cls, source_str: str, category_str: str) -> tuple[DataSource, AssetType]:
        try:
            return DataSource(source_str.lower()), AssetType(category_str.lower())
        except ValueError:
            raise ValueError("Invalid source/category value.")
