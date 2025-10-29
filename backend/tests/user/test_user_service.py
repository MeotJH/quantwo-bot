import uuid

import pytest
from unittest.mock import patch, Mock, create_autospec
from api.user.services import update_user_fcm_token
from api.user.entities import User
from api.quant.domain.entities import Quant
from api import db

@pytest.fixture
def mock_db_session():
    with patch('api.db.session') as mock_session:
        yield mock_session

@pytest.fixture
def mock_user():
    u = Mock()
    u.email = 'test@example.com'
    u.uuid = uuid.uuid4()
    return u

@patch('api.user.services.get_jwt_identity')
def test_update_user_fcm_token(mock_get_jwt_identity, mock_db_session, mock_user):
    # Given
    test_email = 'test@example.com'
    new_token = 'new_fcm_token'
    saved = []

    # gieven
    # get_jwt_identity 패치
    with patch('api.user.services.get_jwt_identity', return_value=test_email) as mock_identity, \
            patch('api.user.services.UserRepository') as MockUserRepo, \
            patch('api.user.services.NotificationRepository') as MockNotiRepo:
        MockUserRepo.return_value.get_by_email.return_value = mock_user

        def save_side_effect(entity):
            saved.append(entity)

        MockNotiRepo.return_value.save.side_effect = save_side_effect

        #when
        result = update_user_fcm_token(new_token)

        #then
        assert result is True
        mock_identity.assert_called_once()

        MockUserRepo.return_value.get_by_email.assert_called_once_with(test_email)
        MockNotiRepo.return_value.save.assert_called_once()

        assert len(saved) == 1

        entity = saved[0]
        assert getattr(entity, 'enabled') is True
        assert getattr(entity, 'channel') == 'ANDROID'  # ← 주의: 'ANDRIOD' 오타 아님
        keys = getattr(entity, 'notification_keys')
        assert isinstance(keys, dict)
        assert keys.get('token') == new_token
        assert getattr(entity, 'user_id') == mock_user.uuid
        
