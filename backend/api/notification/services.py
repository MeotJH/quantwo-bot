from flask_jwt_extended import get_jwt_identity
from api.notification.models import Notification
from api.user.entities import User
from api.notification.entities import NotificationEntity
from exceptions import BadRequestException
from firebase_admin import messaging
from api import db
from sqlalchemy.exc import SQLAlchemyError
from pywebpush import webpush, WebPushException
from api.user.services import find_user_by_email
import json
import os


class NotificationService:

    def send_notification(self, notification: Notification):
        try:

            user = find_user_by_email(notification.user_mail)
            notification_keys = NotificationEntity.query.filter_by(user_id=user['uuid']).first().notification_keys

            webpush(
                subscription_info=notification_keys,
                data=json.dumps(notification.to_dict()),
                vapid_private_key=os.getenv('WEB_ALARM_KEY'),
                # 관리자 이메일
                vapid_claims={
                    "sub": "mailto:mallangyi@naver.com"
                },
            )

        except WebPushException as e:
            print(f"❌ 푸시 전송 실패: {e}")
            if e.response:
                print("🔴 응답 상태 코드:", e.response.status_code)
                print("🔴 응답 본문:", e.response.text)

    def send_notification_to_me(self, notification: Notification):
        try:
            # 고정된 테스트 유저 이메일
            test_email = "mallangyi@naver.com"

            # 1. 유저 조회
            user = find_user_by_email(test_email)
            if not user:
                print(f"❌ 유저를 찾을 수 없습니다: {test_email}")
                return

            # 2. NotificationEntity에서 알림 키 조회
            notification_entity = NotificationEntity.query.filter_by(user_id=user['uuid']).first()
            if not notification_entity or not notification_entity.notification_keys:
                print(f"❌ 알림 키가 없습니다: {test_email}")
                return

            # 3. 푸시 알림 전송
            webpush(
                subscription_info=notification_entity.notification_keys,
                data=json.dumps(notification.to_dict()),
                vapid_private_key=os.getenv('WEB_ALARM_KEY'),
                vapid_claims={
                    "sub": f"mailto:{test_email}"
                },
            )
            print(f"✅ 테스트 푸시 성공적으로 전송됨: {test_email}")

        except WebPushException as e:
            print(f"❌ 푸시 전송 실패: {e}")
            if e.response:
                print("🔴 응답 상태 코드:", e.response.status_code)
                print("🔴 응답 본문:", e.response.text)

    @staticmethod
    def save_notification_info(subscription_json: any):
        jwt_user = get_jwt_identity()
        user = User.query.filter_by(email=jwt_user).first()
        if not user:
            raise BadRequestException("User not found", 404)

        notification = NotificationEntity.query.filter_by(user_id=user.uuid).first()

        if notification:
            notification.notification_keys = subscription_json
            notification.enabled = True
        else:
            notification = NotificationEntity(
                notification_keys=subscription_json,
                channel="WEB",
                user_id=user.uuid,
                enabled=True
            )
            db.session.add(notification)

        try:
            db.session.commit()
            return notification.to_dict()
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)

    @staticmethod
    def save_notification_info_v2(subscription_json: any):
        jwt_user = get_jwt_identity()
        user = User.query.filter_by(email=jwt_user).first()
        if not user:
            raise BadRequestException("User not found", 404)

        notification = NotificationEntity.query.filter_by(user_id=user.uuid).first()

        if subscription_json.get('keys') is not None:
            keys = subscription_json.get('keys')
            keys['endpoint'] = subscription_json['token']
        else :
            keys = {
                'endpoint' : subscription_json['token']
            }

        if notification:
            notification.notification_keys = keys
            notification.enabled = True
        else:
            notification = NotificationEntity(
                notification_keys= keys,
                channel=subscription_json.channel,
                user_id=user.uuid,
                enabled=subscription_json.enabled
            )
            db.session.add(notification)

        try:
            db.session.commit()
            return notification.to_dict()
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)

    @staticmethod
    def toggle_notification(notification_toggle_model: any):
        jwt_user = get_jwt_identity()
        user = User.query.filter_by(email=jwt_user).first()
        if not user:
            raise BadRequestException("User not found", 404)

        notification = NotificationEntity.query.filter_by(user_id=user.uuid).first()
        notification.enabled = notification_toggle_model.get('enabled', False)

        try:
            db.session.commit()
            return notification.to_dict()
        except SQLAlchemyError as e:
            db.session.rollback()
            raise BadRequestException(f'{e}', 400)

    def _get_user_key(self, email: str) -> str:
        user = User.query.filter_by(email=email).first()
        if user:
            print(f'this is user Token: {user.uuid}')
            return user.uuid
        raise ValueError("User not found or token missing")
