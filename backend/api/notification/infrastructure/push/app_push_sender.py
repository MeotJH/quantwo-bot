from api.notification.infrastructure.push.push_sender import PushSender
from api.notification.models import Notification
from util.logging_util import logger


class AppPushSender(PushSender):
    """앱 푸시 알림 전송 구현체 (Firebase Cloud Messaging 사용)"""

    def __init__(self):
        """
        Firebase Admin SDK 초기화

        사용 전 설치 필요: pip install firebase-admin
        """
        try:
            import firebase_admin
            from firebase_admin import credentials, messaging

            self.messaging = messaging

            # Firebase Admin SDK가 이미 초기화되어 있는지 확인
            if not firebase_admin._apps:
                # 환경변수 또는 파일에서 서비스 계정 키 로드
                # cred = credentials.Certificate("path/to/serviceAccountKey.json")
                # firebase_admin.initialize_app(cred)

                # TODO: 실제 사용 시 Firebase 서비스 계정 키 설정 필요
                logger.warning("⚠️ Firebase Admin SDK 초기화 필요 - AppPushSender.__init__() 참고")
        except ImportError:
            logger.error("❌ firebase-admin 패키지 설치 필요: pip install firebase-admin")
            raise

    def send(self, subscription_info: dict, notification: Notification):
        """
        Firebase Cloud Messaging으로 앱 푸시 전송

        Args:
            subscription_info: FCM 토큰 정보 ({"fcm_token": "..."})
            notification: 전송할 알림 데이터
        """
        try:
            fcm_token = subscription_info.get('fcm_token')

            if not fcm_token:
                raise ValueError("FCM 토큰이 없습니다.")

            message = self.messaging.Message(
                notification=self.messaging.Notification(
                    title=notification.title,
                    body=notification.body
                ),
                data={
                    'url': notification.url or '',
                    'user_mail': notification.user_mail
                },
                token=fcm_token
            )

            response = self.messaging.send(message)
            logger.info(f"✅ 앱 푸시 전송 성공: {notification.user_mail}, Response: {response}")

        except Exception as e:
            logger.error(f"❌ 앱 푸시 전송 실패: {e}")
            raise

    def validate_subscription(self, subscription_info: dict) -> bool:
        """
        FCM 토큰 유효성 검증

        Args:
            subscription_info: FCM 토큰 정보

        Returns:
            유효 여부
        """
        if not subscription_info:
            return False

        fcm_token = subscription_info.get('fcm_token')
        return fcm_token is not None and len(fcm_token) > 0
