from enum import Enum

class StockType(str, Enum):
    US = "US"
    CRYPTO = "CRYPTO"
    ETC = "ETC"

    @property
    def kor(self):
        return {
            StockType.US: "해외주식",
            StockType.DUAL_MOMENTUM_INTERNATIONAL: "암호화폐",
            StockType.ETC: "기타",
        }[self]