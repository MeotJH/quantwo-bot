import uuid
from api import db
from sqlalchemy.dialects.postgresql import UUID

from util.db_util import with_to_dict

# 모델 정의
@with_to_dict
class Stocks(db.Model):
    __tablename__ = 'stock'
    
    uuid = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    stock_infos = db.Column(db.JSON)
    # user의 uuid를 외래 키로 가져옴
    insert_date = db.Column(UUID(as_uuid=True), db.ForeignKey('user.uuid'), nullable=False)
