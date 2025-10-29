from flask_jwt_extended import jwt_required
from flask_restx import Resource, fields
from flask import request, jsonify
import json
from api import notification_api as api
from api.notification.services import NotificationService
from pywebpush import webpush, WebPushException
import base64
import os
import api.notification.models as models



subscriptions = []


notification_toggle_model = api.model("NotificationToggle", {
    "enabled": fields.Boolean(required=True, description="알림 활성화 여부 (true: ON, false: OFF)")
})
@api.route('/', strict_slashes=False)
class Notification(Resource):

    @jwt_required()
    def post(self):
        """ 🔹 로그인 토큰 바탕 웹 푸시 알림 """

        NotificationService().send_notification(notification=models.Notification(
            title='퀀투봇 [추세추종투자]',
            body='저장했던 추세 반전이 감지되었습니다.',
            user_mail='name@mail.com'
        ))

        NotificationService().send_notification(notification=models.Notification(
            title='퀀투봇 [추세추종투자]',
            body='저장했던 추세 반전이 감지되었습니다.',
            user_mail='name@mail.com'
        ))
        return { 'success': True }, 200
    
    @jwt_required()
    @api.expect(notification_toggle_model)
    def patch(self):
        """ 🔹 로그인 토큰 바탕 웹 푸시 알림 """
        result =  NotificationService().toggle_notification(request.get_json())
        return { 'success': True, 'data': {
            'notification_keys' : len(str(result['notification_keys']))
            , 'enabled': result['enabled']
            } 
        }, 201


subscription_model = api.model("Subscription", {
    "endpoint": fields.String(required=True, description="푸시 서버 엔드포인트"),
    "keys": fields.Nested(api.model("Keys", {
        "p256dh": fields.String(required=True, description="Public Key"),
        "auth": fields.String(required=True, description="Auth Key")
    }))
})


@api.route('/subscribe', strict_slashes=False)
class NotificationSub(Resource):

    @jwt_required()
    @api.expect(subscription_model)
    def post(self):
        """ 🔹 웹 푸시 구독 저장 """
        

        """
        알림처리 로그인 되어있어야 알림받을 수 있다.
        알림 처리 할때 유저스토리
        하나도 값 없다 첫 퀀트받기 클릭 -> 푸시 구독 저장
        알림off -> 푸시 정보 삭제
        알림on -> 푸시 구독 저장

        db구조 유저 id 기준으로 -> uuid str / 유저 str / 구독 데이터 json
        1유저당 1알림
        """
        subscription_json = request.get_json()
        # 구독 정보 저장
        NotificationService.save_notification_info(subscription_json)
        return {"success": True, "message": "구독 성공"}, 201