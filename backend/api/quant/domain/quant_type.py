from enum import Enum

from exceptions import BadRequestException

class QuantType(str, Enum):
    TREND_FOLLOW = "TF"
    DUAL_MOMENTUM_INTERNATIONAL = "DM-INTL"
    ETC = "ETC"

    @property
    def kor(self):
        return {
            QuantType.TREND_FOLLOW: "추세추종전략",
            QuantType.DUAL_MOMENTUM_INTERNATIONAL: "듀얼모멘텀 국제전략",
            QuantType.ETC: "기타",
        }[self]

class DataSource(Enum):
    YAHOO = 'yahoo'
    COINMARKETCAP = 'coinmarketcap'


class AssetType(Enum):
    US = 'us'
    CRYPTO = 'crypto'

    @classmethod
    def from_str(cls, raw: str):
        try:
            return cls(raw.lower())
        except ValueError:
            raise BadRequestException(f"Invalid asset_type: '{raw}' is not supported.", 404)