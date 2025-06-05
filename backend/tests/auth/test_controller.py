import base64
import json
from urllib.parse import urlparse, parse_qs

def test_naver_login_success(client):
    fe_redirect_uri = "https://frontend.example.com/login"
    response = client.get("api/v1/auth/oauth/naver", query_string={"redirect_uri": fe_redirect_uri})


    assert response.status_code == 302

    redirect_url = response.headers["Location"]
    assert redirect_url.startswith("https://nid.naver.com/oauth2.0/authorize")

    parsed = urlparse(redirect_url)
    query = parse_qs(parsed.query)

    assert "state" in query

    state_encoded = query["state"][0]
    decoded = json.loads(base64.urlsafe_b64decode(state_encoded.encode()).decode())
    assert decoded["fe_redirect_uri"] == fe_redirect_uri