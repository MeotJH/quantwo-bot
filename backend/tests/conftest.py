# tests/conftest.py

import pytest
from api import create_app

@pytest.fixture
def app():
    app = create_app(testing=True)
    return app

@pytest.fixture
def client(app):
    with app.test_client() as client:
        yield client
