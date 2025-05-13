# myapp/entityies.py
import uuid
from api import db
from sqlalchemy.dialects.postgresql import UUID

# 모델 정의
class User(db.Model):
    uuid = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    username = db.Column(db.String(40), unique=True, nullable=False)
    email = db.Column(db.String(60), unique=True, nullable=False)
    mobile = db.Column(db.String(11), unique=False, nullable=True)
    password = db.Column(db.String(512), nullable=True)
    app_token = db.Column(db.String(512), nullable=True) # 인증 제공자
    provider = db.Column(db.String(10), nullable=True) # 인증 제공자
    # Quant와의 1:N 관계 설정 (backref로 양방향 액세스 가능)
    quants = db.relationship('Quant', backref='user', lazy=True)

    # Notification과의 1:1 관계 설정
    notification = db.relationship("NotificationEntity", uselist=False, back_populates="user")

    def __repr__(self):
        return f'<User {self.username}>'

    def to_dict(self):
        return {
            'uuid': self.uuid,
            'userName': self.username,  # username을 userName으로 변경하여 반환
            'email': self.email,
            'mobile': self.mobile,
            'provider' : self.provider,
            'notification' : getattr(self.notification, 'enabled', False),
        }