import logging
import os
from dotenv import load_dotenv
from constants import SingletonInstance


# JWT
class JWTConfig(SingletonInstance):
    def __init__(self):
        self.SECRET_KEY = os.getenv("JWT_SECRET_KEY")

# Flask Base Configuration
class BaseConfig(object):
    load_dotenv()
    # Flask
    ENV = os.getenv('ENVIROMENT', 'LOCAL')
    DEBUG = False
    BUNDLE_ERRORS = True
    PROPAGATE_EXCEPTIONS = True
    SECRET_KEY = JWTConfig.instance().SECRET_KEY
    # Restx
    RESTX_VALIDATE = True
    RESTX_MASK_SWAGGER = False
    # JWT
    JWT_ACCESS_TOKEN_EXPIRES = False
    LOG_LEVEL = logging.DEBUG
    # SQLAlchemy
    SQLALCHEMY_ECHO = False
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    print(f'os.getenv("SQLALCHEMY_DATABASE_URI"):{os.getenv("SQLALCHEMY_DATABASE_URI")}')
    SQLALCHEMY_DATABASE_URI = os.getenv("SQLALCHEMY_DATABASE_URI")

    # 환경값 가져오기
    env = os.getenv('ENVIRONMENT', 'LOCAL').upper()
    # 환경에 따른 URL 매핑
    BACKEND_URI = {
        'LOCAL': 'http://localhost:8080/api/v1',
        'PROD': 'https://quantwo-bot.com/api/v1',
    }.get(env, 'http://localhost:8080/api/v1')


# Flask Local Configuration
class LocalConfig(BaseConfig):
    DEBUG = True



# Flask Dev Configuration
class DevConfig(BaseConfig):
    BASE_URL = "https://localhost"


# Flask Prod Configuration
class ProdConfig(BaseConfig):
    BASE_URL = "https://localhost"


config_by_name = dict(LOCAL="config.LocalConfig", PROD="config.DevConfig")
