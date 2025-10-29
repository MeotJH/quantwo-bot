from api.notification.entities import NotificationEntity
from api import db
from sqlalchemy.exc import SQLAlchemyError
from exceptions import BadRequestException


class NotificationRepository:
    """알림 설정 데이터베이스 접근 계층"""

    def find_by_user_id(self, user_id: str):
        """유저 ID로 알림 설정 조회"""
        return NotificationEntity.query.filter_by(user_id=user_id).first()

    def save(self, notification_entity: NotificationEntity):
        """알림 설정 저장"""
        try:
            db.session.add(notification_entity)
            db.session.commit()
            return notification_entity
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)

    def update_keys(self, user_id: str, subscription_json: dict):
        """알림 구독 키 업데이트 (upsert 패턴)"""
        try:
            notification = self.find_by_user_id(user_id)

            if notification:
                notification.notification_keys = subscription_json
                notification.enabled = True
            else:
                notification = NotificationEntity(
                    notification_keys=subscription_json,
                    user_id=user_id,
                    enabled=True
                )
                db.session.add(notification)

            db.session.commit()
            return notification
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)

    def update_fcm_token(self, user_id: str, fcm_token: str):
        """FCM 토큰 업데이트 (앱 푸시용)"""
        try:
            notification = self.find_by_user_id(user_id)

            if notification:
                notification.fcm_token = fcm_token
                notification.enabled = True
            else:
                notification = NotificationEntity(
                    fcm_token=fcm_token,
                    user_id=user_id,
                    enabled=True
                )
                db.session.add(notification)

            db.session.commit()
            return notification
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)

    def toggle_enabled(self, user_id: str, enabled: bool):
        """알림 on/off 토글"""
        try:
            notification = self.find_by_user_id(user_id)

            if not notification:
                raise BadRequestException('알림 설정을 찾을 수 없습니다.', 404)

            notification.enabled = enabled
            db.session.commit()
            return notification
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)
