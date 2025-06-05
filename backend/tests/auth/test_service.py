
def test_login_or_register_with_naver(mocker):
    #access-token request mocking
    mock_token_response = mocker.Mock()
    mock_token_response.json.return_value = {"access_token": "mocked-access-token"}

    #oauth login user info mocking
    mock_profile_response = mocker.Mock()
    mock_profile_response.json.return_value = {"response":{"email": "mocked@mail.dot","user":'mocked-user'}}

    #request result mocking
    mocker.patch(
        "api.auth.service.requests.get",
        side_effect=[mock_token_response,mock_profile_response]
    )

    #user select mocking
    class DummyUser:
        def __init__(self, email):
            self.email = email
    fake_repo = mocker.Mock()
    fake_repo.get_by_email.return_value = DummyUser(email="test@naver.com")


    #create jwt moking
    mocker.patch('api.auth.service.create_access_token', return_value="fake-jwt-token")

    #do
    from api.auth.service import login_or_register_with_naver
    jwt = login_or_register_with_naver('code','state',fake_repo)
    assert jwt == "fake-jwt-token"

def test_firt_time_login_or_register_with_naver(mocker):
    #access-token request mocking
    mock_token_response = mocker.Mock()
    mock_token_response.json.return_value = {"access_token": "mocked-access-token"}

    #oauth login user info mocking
    mock_profile_response = mocker.Mock()
    mock_profile_response.json.return_value = {"response":{"email": "mocked@mail.dot","user":'mocked-user'}}

    #request result mocking
    mocker.patch(
        "api.auth.service.requests.get",
        side_effect=[mock_token_response,mock_profile_response]
    )

    #repo_response nothing
    fake_repo = mocker.Mock()
    fake_repo.get_by_email.return_value = None

    #create jwt moking
    fake_jwt_token = "fake-jwt-token"
    mocker.patch('api.auth.service.create_access_token', return_value=fake_jwt_token)

    #do test
    from api.auth.service import login_or_register_with_naver
    jwt = login_or_register_with_naver('code','state',fake_repo)
    assert fake_repo.save.called
    assert jwt == fake_jwt_token

