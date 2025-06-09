import base64
import os
from flask import json, redirect, request
from flask_jwt_extended import get_jwt_identity, jwt_required
from flask_restx import Resource
import jwt
from api.auth import auth_api as api
from api.auth.service import login_or_register_with_naver
from api.user.repository import UserRepository
from config import BaseConfig
from exceptions import UnauthorizedException
from util.logging_util import logger

NAVER_CLIENT_ID = 'NAVER_CLIENT_ID'
NAVER_CLIENT_SECRET = 'NAVER_CLIENT_SECRET'

@api.route('/me', strict_slashes=False)
class Me(Resource):
    
    @jwt_required()
    def get(self):
        user_id = get_jwt_identity()
        return {"valid": True, "user_id": user_id}

@api.route('/oauth/naver', strict_slashes=False)
class OauthNaver(Resource):

    def get(self):
        """
            네이버 간편로그인을 위한 end-point
        """

        #callback 에 반환받을 redirect_uri fe에서 받은 변수로 파싱
        fe_redirect_uri = request.args.get("redirect_uri")
        encoded_state = base64.urlsafe_b64encode(json.dumps({
            "fe_redirect_uri": fe_redirect_uri
        }).encode()).decode()

        #naver에 redirect 하기위해 변수생성
        url = (
            f"https://nid.naver.com/oauth2.0/authorize"
            f"?response_type=code"
            f"&client_id={os.getenv(NAVER_CLIENT_ID)}"
            f"&redirect_uri={BaseConfig.BACKEND_URI}/auth/oauth/callback/naver"
            f"&state={encoded_state}"
        )
        return redirect(url)

@api.route('/oauth/callback/naver', strict_slashes=False)
class OauthCallbackNaver(Resource):

    def get(self):
        """
            네이버 간편로그인 요청 리다이렉트 이후 콜백받는 함수
        """
                
        #callback받아서 보냈던 변수 파싱
        code = request.args.get('code')
        state = request.args.get('state')
        decoded_state = json.loads(base64.urlsafe_b64decode(state.encode()).decode())
        fe_redirect_uri  = decoded_state.get("fe_redirect_uri")

        #jwt_token 생성
        jwt_token = login_or_register_with_naver(code=code,state=state,user_repo=UserRepository())

        #프로토콜이 맞지 않으면 403
        if not fe_redirect_uri.startswith("http://localhost") and not fe_redirect_uri.startswith("https://quantwo-bot"):
            raise UnauthorizedException('Unauthorized redirect', 403) 
        
        return redirect(f"{fe_redirect_uri}?token={jwt_token}")