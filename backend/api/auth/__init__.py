from flask_restx import Namespace

auth_api = Namespace(name='auth', path='/auth', description='auth와 관련된 API 모음')