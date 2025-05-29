import uuid
from api import db
from sqlalchemy.dialects.postgresql import UUID
from datetime import datetime, timezone

from util.db_util import with_to_dict

# 모델 정의
@with_to_dict
class Stocks(db.Model):
    __tablename__ = 'stock'
    uuid = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, comment='기본 키 UUID')
    stock_type = db.Column(db.String(512), nullable=False, comment='주식 구분 (예: 미국주식(US), 코인 등(CRYPTO))') 
    stock_infos = db.Column(db.JSON,comment='개별 주식의 시세/메타데이터 등 JSON 구조')
    insert_date = db.Column(db.DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=False,comment='레코드 생성 시각 (UTC 기준)')
