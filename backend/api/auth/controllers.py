import os
from flask import redirect, request
from flask_jwt_extended import create_access_token
from flask_restx import Resource
import jwt
import requests
from api.auth import auth_api as api
from util.logging_util import logger

NAVER_CLIENT_ID = 'NAVER_CLIENT_ID'
NAVER_CLIENT_SECRET = 'NAVER_CLIENT_SECRET'


@api.route('/oauth/naver', strict_slashes=False)
class OauthNaver(Resource):

    def get(self):
        url = (
            f"https://nid.naver.com/oauth2.0/authorize"
            f"?response_type=code"
            f"&client_id={os.getenv(NAVER_CLIENT_ID)}"
            f"&redirect_uri=http://localhost:8080/api/v1/auth/oauth/callback/naver"
            f"&state=random_state_string"
        )
        return redirect(url)

@api.route('/oauth/callback/naver', strict_slashes=False)
class OauthCallbackNaver(Resource):

    def get(self):
        code = request.args.get('code')
        state = request.args.get('state')

        # Access token 요청
        token_res = requests.get("https://nid.naver.com/oauth2.0/token", params={
            "grant_type": "authorization_code",
            "client_id": os.getenv(NAVER_CLIENT_ID),
            "client_secret": os.getenv(NAVER_CLIENT_SECRET),
            "code": code,
            "state": state
        }).json()

        access_token = token_res.get("access_token")
        if not access_token:
            return {"error": "Failed to get token"}, 400
        

        # 사용자 정보 요청
        headers = {"Authorization": f"Bearer {access_token}"}
        profile_res = requests.get("https://openapi.naver.com/v1/nid/me", headers=headers).json()
        user_info = profile_res.get("response", {})

        logger.info(f'this is user_info :::: {user_info}')
        email = user_info.get("email")
        if not email:
            return {"error": "No email from Naver"}, 400

        # JWT 발급
        jwt_token = create_access_token(identity=email)

        # 앱 or 웹 리다이렉트
        return redirect(f"http://localhost:8080?token={jwt_token}")