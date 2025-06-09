from unittest.mock import Mock

import pytest
from api.quant.domain.model import TrendFollowRequestDTO
from api.quant.domain.quant_type import AssetType, DataSource
from api.quant.domain.trend_follow import TrendFollow
from exceptions import BadRequestException, EntityNotFoundException


def test__get_stock_success(mocker):

    mock_result= "mocked_result"
    mock_handler = Mock(return_value=mock_result)
    dto = TrendFollowRequestDTO(
         asset_type='us',
         ticker='aapl',
    )
    key = (DataSource.YAHOO, AssetType("us"))

    mocker.patch('api.quant.domain.trend_follow.TrendFollow._dispatch_table', {key:mock_handler})

    result = TrendFollow._get_stock(dto)
    assert result == mock_result

def test__get_stock_invalid_key(mocker):
    dto = TrendFollowRequestDTO(
        asset_type='invalid',  # 존재하지 않는 enum value
        ticker='aapl',
    )

    # 빈 dispatch_table을 주입하거나, 유효하지 않은 key는 포함하지 않음
    mocker.patch('api.quant.domain.trend_follow.TrendFollow._dispatch_table', {})

    with pytest.raises(BadRequestException) as excinfo:
        TrendFollow._get_stock(dto)

    assert "Invalid asset_type: " in str(excinfo.value)


def test__get_stock_invalid_combination_key(mocker):
    dto = TrendFollowRequestDTO(
        asset_type='us',
        ticker='aapl',
    )

    # 빈 dispatch_table을 주입하거나, 유효하지 않은 key는 포함하지 않음
    mocker.patch('api.quant.domain.trend_follow.TrendFollow._dispatch_table', {})

    with pytest.raises(EntityNotFoundException) as excinfo:
        TrendFollow._get_stock(dto)

    assert "Unsupported source/asset combination" in str(excinfo.value)
