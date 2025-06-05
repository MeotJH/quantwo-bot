from api.user.entities import User
from api import db
from uuid import uuid4
from werkzeug.security import generate_password_hash, check_password_hash
from api.user.repository import UserRepository
from exceptions import  UnauthorizedException, UserAlreadyExistException
from flask_jwt_extended import create_access_token, get_jwt_identity
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import joinedload

def save_user_v2(user_repo:UserRepository,user:dict):
    if not user.get("email"):
        raise ValueError("이메일이 빈값입니다.")
    
    if not user.get("userName"):
        raise ValueError("유저명이 빈값입니다.")

    password_hash = generate_password_hash(user['password']) \
                        if user.get('password') and user.get('provider') in [None, 'self'] else None
    user_data = {
        "uuid": uuid4(),
        "username": user['userName'],
        "email": user["email"],
        "password": password_hash,
        "app_token": user.get("appToken"),
        "provider": user.get("provider", "self"),
    }
    return user_repo.save_user(user_data)

def save_user(user):
    """
    유저 저장 함수
    """
    try:
        id = uuid4()
        password_hash = generate_password_hash(user['password']) \
                        if user.get('password') and user.get('provider') in [None, 'self'] else None

        new_user = User(uuid=id,
                        username=user['userName'],
                        email=user['email'],
                        password=password_hash,
                        app_token=user.get('appToken', None),
                        provider= user.get('provider','self')
                        )
        db.session.add(new_user)
        db.session.commit()
    #IntegrityError DB중복 예외처리
    except IntegrityError as e:
        db.session.rollback()
        raise UserAlreadyExistException(f'중복된 메일 입니다 😞😞', 409)
    return new_user.to_dict()

def find_user(user):
    db_user = User.query.filter_by(email=user['email']).first()


    if not db_user:
        raise UnauthorizedException('Invalid email', 'INVALID_EMAIL')  # 이메일이 없을 때 예외 발생
    
    if not check_password_hash(db_user.password, user['password']):
        raise UnauthorizedException('Invalid password', 'INVALID_PASSWORD')  # 비밀번호가 틀렸을 때 예외 발생
    response_user = db_user.to_dict()
    response_user['authorization'] = create_access_token(identity=db_user.email)
    return response_user

def find_user_by_email(email):
        db_user = User.query.options(joinedload(User.notification)).filter_by(email=email).first()
        return db_user.to_dict()

def update_user_fcm_token(newToken):
    email = get_jwt_identity()
    db_user = User.query.filter_by(email=email).first()
    db_user.app_token = newToken
    db.session.commit()
    return True