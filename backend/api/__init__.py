import atexit
import os

from flask import Flask
from flask_caching import Cache
from flask_cors import CORS
from flask_restx import Api
from werkzeug.utils import import_string
from dotenv import load_dotenv
from api.common import jwt
from config import config_by_name
from util.logging_util import logger

from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

#1. controller __init__.py를 import해줘야한다.
from api.server_status import server_status_api
from api.stock import stock_api
from api.quant import quant_api
from api.user import user_api
from api.notification import notification_api
from api.auth import auth_api


authorizations = {
    "user_token": {
        "type": "apiKey",
        "in": "header",
        "name": "Authorization",
        "description": "JWT for user",
    },
}
#orm 전역변수
db = SQLAlchemy()
#flask migrate db 형상관리 전역변수
migrate = Migrate()
#flask-cache 전역변수
cache = Cache()


def create_app(testing=False):
    app = Flask(__name__)
    if testing:
        app.config["TESTING"] = True
        app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"

    load_dotenv()
    app.add_url_rule("/", endpoint="ping", view_func=lambda: "Pong!")

    _load_config(app)
    _setup_logger(app)
    api = _init_api(app)
    _register_namespaces(api)
    _init_extensions(app)
    _init_schedulers(app)
    _init_cache(app)
    _register_shutdown_hooks(app)

    return app


def _load_config(app):
    config_name = os.getenv("ENVIRONMENT", "LOCAL")
    print(f"config_env: {config_name}")
    config_object = import_string(config_by_name[config_name])()
    app.config.from_object(config_object)


def _setup_logger(app):
    logger.set_default_logger_level(app.name, app.config["LOG_LEVEL"])
    logger.set_level(logger_name="pynamodb", level=app.config["LOG_LEVEL"])


def _init_api(app):
    api = Api(
        app,
        authorizations=authorizations,
        security="user_token",
        doc="/swagger",
        title="quantwo-bot-flask",
        version="1.0",
        description="QuantwoBot API",
        prefix="/api/v1",
    )
    return api


def _register_namespaces(api):
    #2. controller __init__의 명세를 등록해 주어야 한다.
    api.add_namespace(server_status_api)
    api.add_namespace(stock_api)
    api.add_namespace(quant_api)
    api.add_namespace(user_api)
    api.add_namespace(notification_api)
    api.add_namespace(auth_api)
    # register controllers
    #3. controller controller를 import해줘야한다.
    from api.server_status import controllers
    from api.stock import controllers
    from api.quant.controller import controllers
    from api.user import controllers
    from api.notification import controllers
    from api.auth import controllers


def _init_extensions(app):
    jwt.init_app(app)
    db.init_app(app)
    migrate.init_app(app, db)
    CORS(app)


def _init_schedulers(app):
    from api.scheduler.quant_scheduler import QuantScheduler
    quant_scheduler = QuantScheduler(app)
    app.quant_scheduler = quant_scheduler
    with app.app_context():
        quant_scheduler.start()


def _init_cache(app):
    app.config["CACHE_TYPE"] = "SimpleCache"
    app.config["CACHE_DEFAULT_TIMEOUT"] = 300
    cache.init_app(app)


def _register_shutdown_hooks(app):
    atexit.register(lambda: app.quant_scheduler.shutdown())

