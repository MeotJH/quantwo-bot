from dataclasses import dataclass, asdict
from typing import List, Optional

@dataclass
class TrendFollowListResponse:
    ticker: str
    name: str
    lastsale: Optional[str] = None
    netchange: Optional[str] = None
    pctchange: Optional[str] = None
    volume: Optional[str] = None
    market_cap: Optional[str] = None
    country: Optional[str] = None
    ipo_year: Optional[str] = None
    industry: Optional[str] = None
    sector: Optional[str] = None
    url: Optional[str] = None
    # 추가 필드
    score: Optional[float] = None
    bucket: Optional[str] = None
    reasons: Optional[List[str]] = None

    def to_dict(self):
        """Flask-RESTX marshal_with 호환용"""
        return asdict(self)
