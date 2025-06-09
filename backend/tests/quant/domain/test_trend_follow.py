from unittest.mock import Mock

import pandas as pd
import pytest
from api.quant.domain.model import TrendFollowRequestDTO
from api.quant.domain.quant_type import AssetType, DataSource
from api.quant.domain.trend_follow import TrendFollow
from exceptions import BadRequestException, EntityNotFoundException

def test_find_stock_by_id(mocker):
    mock_result = {
        'stock_data' :  pd.DataFrame(
            {
                "Close":[100,101,102]
             ,  "Trend_Follow": [1.0, 0.0, None]
             ,  "Date": pd.to_datetime(["2024-01-01", "2024-01-02", "2024-01-03"])
             }
        ),
        'stock_info' : {},
    }
    mocker.patch('api.quant.domain.trend_follow.TrendFollow._get_stock', return_value=mock_result)

    mocker.patch('api.quant.domain.trend_follow.TrendFollow._find_last_cross_trend_follow', return_value=0.0)

    dto = TrendFollowRequestDTO(
         asset_type='us',
         ticker='aapl',
    )

    result = TrendFollow.find_stock_by_id(dto)

    assert 'stock_history' in result
    assert 'stock_info' in result
    assert len(result['stock_history']) == 2
    assert result['stock_history'][0]['Date'] == "2024-01-02"
    assert result['stock_info']['lastCrossTrendFollow'] == 0.0


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
