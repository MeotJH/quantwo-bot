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

                jwt_user = get_jwt_identity()
                user = find_user_by_email(jwt_user)
                notification_keys = NotificationEntity.query.filter_by(user_id=user['uuid']).first().notification_keys

                webpush(
                        subscription_info=notification_keys,
                        data=json.dumps(notification.to_dict()),
                        vapid_private_key= os.getenv('WEB_ALARM_KEY'),
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
    
    @staticmethod
    def save_notification_info(subscription_json: any):
        jwt_user = get_jwt_identity()
        user = User.query.filter_by(email=jwt_user).first()
        if not user:
            raise BadRequestException("User not found", 404)

        notification = NotificationEntity.query.filter_by(user_id=user.uuid).first()

        if notification:
            notification.notification_keys = subscription_json
        else:
            notification = NotificationEntity(
                notification_keys=subscription_json,
                user_id=user.uuid
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
