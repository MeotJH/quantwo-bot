from abc import ABC, abstractmethod
from api.notification.models import Notification


class PushSender(ABC):
    """푸시 알림 전송 인터페이스"""

    @abstractmethod
    def send(self, subscription_info: dict, notification: Notification):
        """
        푸시 알림 전송

        Args:
            subscription_info: 구독 정보 (웹푸시: notification_keys, 앱푸시: fcm_token)
            notification: 전송할 알림 데이터
        """
        pass

    @abstractmethod
    def validate_subscription(self, subscription_info: dict) -> bool:
        """
        구독 정보 유효성 검증

        Args:
            subscription_info: 검증할 구독 정보

        Returns:
            유효 여부
        """
        pass
