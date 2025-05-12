from enum import Enum

class QuantType(str, Enum):
    TREND_FOLLOW = "TF"
    DUAL_MOMENTUM_INTERNATIONAL = "DM-INTL"
    ETC = "ETC"