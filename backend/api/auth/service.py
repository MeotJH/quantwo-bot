import os
import string
import uuid
from flask_jwt_extended import create_access_token
import requests
from api.auth.repository import AuthRepository
from api.user.entities import User
from api.user.services import save_user
from util.logging_util import logger

NAVER_CLIENT_ID = 'NAVER_CLIENT_ID'
NAVER_CLIENT_SECRET = 'NAVER_CLIENT_SECRET'
def login_or_register_with_naver(code: string, state: string, user_repo: AuthRepository):
    """
    네이버 간편로그인으로 가입or로그인처리 후 fe와 통신위한 jwt리턴한다.
    """
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
    
    #처음 이용자라면 가입처리
    user = user_repo.get_by_email(email)
    if not user:
        save_user(
            {
                'userName' :f"{email.split('@')[0]}_{uuid.uuid4().hex[:4]}",
                'email' : email,
                'password' : None,
                'provider' : 'naver'
            }
        )


    # JWT 발급
    return create_access_token(identity=email)