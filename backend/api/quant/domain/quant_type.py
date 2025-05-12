from enum import Enum

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