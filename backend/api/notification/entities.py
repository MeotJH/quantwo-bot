import uuid
from api import db
from sqlalchemy.dialects.postgresql import UUID

from util.db_util import with_to_dict

# 모델 정의
@with_to_dict
class NotificationEntity(db.Model):
    __tablename__ = 'notification'
    
    uuid = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    notification_keys = db.Column(db.JSON)
    # user의 uuid를 외래 키로 가져옴
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('user.uuid'), nullable=False)
    enabled = db.Column(db.Boolean, default=False)  # 새로운 컬럼 추가

    #user entity와의 관계
    user = db.relationship("User", back_populates="notification")
