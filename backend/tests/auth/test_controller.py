import base64
import json
from urllib.parse import urlparse, parse_qs

from flask_jwt_extended import create_access_token

from constants import API_PREFIX

def test_naver_login_success(client):
    fe_redirect_uri = "https://frontend.example.com/login"
    response = client.get(f"{API_PREFIX}/auth/oauth/naver", query_string={"redirect_uri": fe_redirect_uri})


    assert response.status_code == 302

    redirect_url = response.headers["Location"]
    assert redirect_url.startswith("https://nid.naver.com/oauth2.0/authorize")

    parsed = urlparse(redirect_url)
    query = parse_qs(parsed.query)

    assert "state" in query

    state_encoded = query["state"][0]
    decoded = json.loads(base64.urlsafe_b64decode(state_encoded.encode()).decode())
    assert decoded["fe_redirect_uri"] == fe_redirect_uri

def test_me_endpoint_returns_user_id(client, app):
    with app.app_context():
        test_user_id = 123
        access_token = create_access_token(identity=test_user_id)

    headers = {
        "Authorization": f"Bearer {access_token}"
    }
    response = client.get(f"{API_PREFIX}/auth/me", headers=headers)

    assert response.status_code == 200
    data = response.get_json()
    assert data["valid"] is True
    assert data["user_id"] == test_user_id