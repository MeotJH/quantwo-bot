import pytest
from unittest.mock import Mock, patch
from api.quant.domain.value_objects.quant_type import QuantType
from api.quant.services import QuantService
from api.quant.domain.entities import Quant
from api.user.entities import User


@pytest.fixture
def mock_db_session():
    with patch('api.db.session') as mock_session:
        yield mock_session

@pytest.fixture
def quant_service():
    return QuantService()

# 알림 확인 테스트
def test_check_and_notify(quant_service, mock_db_session):
    # GIVEN
    # 테스트용 Quant 객체 생성
    mock_user = Mock(spec=User)
    mock_user.email = 'test@example.com'
    mock_quant = Mock(spec=Quant)
    mock_quant.stock = 'AAPL'
    mock_quant.notification = True
    mock_quant.current_status = 'SELL'
    mock_quant.last_send_status = 'BUY'  # 변경 필요
    mock_quant.user = mock_user
    
    with patch('api.quant.domain.entities.Quant.query') as mock_query:
        with patch.object(QuantService, 'check_and_notify', wraps=quant_service.check_and_notify) as mock_check_and_notify:

    # WHEN
            mock_query.filter_by.return_value.all.return_value = [mock_quant]
            quant_service.check_and_notify(notify_quant_type=QuantType.TREND_FOLLOW)
            
    
    # THEN
            mock_check_and_notify.assert_called_once()
            assert mock_quant.last_send_status == 'BUY'
