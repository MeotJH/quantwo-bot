import os
from flask import redirect, request
from flask_restx import Resource
import jwt
import requests
from api.auth import auth_api as api
from api.auth.service import login_or_register_with_naver

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
        jwt_token = login_or_register_with_naver(code=code,state=state)
        #웹 리다이렉트
        return redirect(f"http://localhost:8080?token={jwt_token}")