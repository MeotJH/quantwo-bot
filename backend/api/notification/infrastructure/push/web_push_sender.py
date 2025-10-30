from pywebpush import webpush, WebPushException
import json
import os
from api.notification.infrastructure.push.push_sender import PushSender
from api.notification.models import Notification
from util.logging_util import logger


class WebPushSender(PushSender):
    """웹 푸시 알림 전송 구현체 (pywebpush 사용)"""

    def send(self, subscription_info: dict, notification: Notification):
        """
        웹 푸시 알림 전송

        Args:
            subscription_info: 웹 푸시 구독 정보 (notification_keys)
            notification: 전송할 알림 데이터
        """
        try:
            webpush(
                subscription_info=subscription_info,
                data=json.dumps(notification.to_dict()),
                vapid_private_key=os.getenv('WEB_ALARM_KEY'),
                vapid_claims={
                    "sub": f"mailto:{notification.user_mail}"
                }
            )
            logger.info(f"✅ 웹 푸시 전송 성공: {notification.user_mail}")

        except WebPushException as e:
            logger.error(f"❌ 웹 푸시 전송 실패: {e}")
            if e.response:
                logger.error(f"🔴 응답 상태 코드: {e.response.status_code}")
                logger.error(f"🔴 응답 본문: {e.response.text}")
            raise

    def validate_subscription(self, subscription_info: dict) -> bool:
        """
        웹 푸시 구독 정보 유효성 검증

        Args:
            subscription_info: notification_keys 딕셔너리

        Returns:
            유효 여부
        """
        if not subscription_info:
            return False

        # Web Push 구독 정보는 endpoint, keys 필드가 필수
        required_fields = ['endpoint', 'keys']
        return all(field in subscription_info for field in required_fields)
