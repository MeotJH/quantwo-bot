from unittest.mock import Mock

import pandas as pd
import pytest
from api.quant.domain.value_objects.model import TrendFollowRequestDTO
from api.quant.domain.services.trend_follow import TrendFollow
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
    
    mock_market_data_client = Mock()
    mock_market_data_client.get_stocks.return_value = mock_result
    
    mocker.patch('api.quant.domain.services.trend_follow.TrendFollow._find_last_cross_trend_follow', return_value=0.0)

    dto = TrendFollowRequestDTO(
         asset_type='us',
         ticker='aapl',
    )

    trend_follow = TrendFollow(mock_market_data_client)
    result = trend_follow.find_stock_by_id(dto)

    assert 'stock_history' in result
    assert 'stock_info' in result
    assert len(result['stock_history']) == 2
    assert result['stock_history'][0]['Date'] == "2024-01-02"
    assert result['stock_info']['lastCrossTrendFollow'] == 0.0


def test__get_stock_success(mocker):

    mock_result= "mocked_result"
    mock_market_data_client = Mock()
    mock_market_data_client.get_stocks.return_value = mock_result
    
    dto = TrendFollowRequestDTO(
         asset_type='us',
         ticker='aapl',
    )

    trend_follow = TrendFollow(mock_market_data_client)
    result = trend_follow._get_stock(dto)
    assert result == mock_result

def test__get_stock_invalid_key(mocker):
    dto = TrendFollowRequestDTO(
        asset_type='invalid',  # 존재하지 않는 enum value
        ticker='aapl',
    )

    mock_market_data_client = Mock()
    mock_market_data_client.get_stocks.side_effect = BadRequestException("Invalid asset_type: invalid", "INVALID_ASSET_TYPE")
    
    trend_follow = TrendFollow(mock_market_data_client)

    with pytest.raises(BadRequestException) as excinfo:
        trend_follow._get_stock(dto)

    assert "Invalid asset_type: " in str(excinfo.value)


def test__get_stock_invalid_combination_key(mocker):
    dto = TrendFollowRequestDTO(
        asset_type='us',
        ticker='aapl',
    )

    mock_market_data_client = Mock()
    mock_market_data_client.get_stocks.side_effect = EntityNotFoundException("Unsupported source/asset combination", "INVALID_ASSET_TYPE")

    trend_follow = TrendFollow(mock_market_data_client)

    with pytest.raises(EntityNotFoundException) as excinfo:
        trend_follow._get_stock(dto)

    assert "Unsupported source/asset combination" in str(excinfo.value)


def test_find_trend_follows(mocker):
    """find_trend_follows 메서드 테스트"""
    # Mock 데이터: 다양한 시나리오를 포함한 주식 데이터
    mock_stocks = [
        {
            "symbol": "AAPL",
            "name": "Apple Inc.",
            "lastsale": "150.00",
            "pctchange": "2.5",
            "volume": "50000000",
            "marketCap": "2500000000000",  # 2.5T (대형주)
            "sector": "Technology",
            "ipoyear": "1980"
        },
        {
            "symbol": "XYZ",
            "name": "XYZ Corp",
            "lastsale": "10.00",
            "pctchange": "15.0",  # 고변동성
            "volume": "100000",
            "marketCap": "50000000",  # 5천만 (마이크로캡)
            "sector": "Technology",
            "ipoyear": "2023"  # 최근 IPO
        },
        {
            "symbol": "BAC",
            "name": "Bank of America",
            "lastsale": "30.00",
            "pctchange": "1.0",
            "volume": "40000000",
            "marketCap": "250000000000",  # 250B
            "sector": "Financials",
            "ipoyear": "1980"
        }
    ]

    # find_stocks를 mock 처리
    mocker.patch('api.quant.domain.services.trend_follow.find_stocks', return_value=mock_stocks)

    # TrendFollow 인스턴스 생성
    mock_market_data_client = Mock()
    trend_follow = TrendFollow(mock_market_data_client)

    # find_trend_follows 실행
    result = trend_follow.find_trend_follows()

    # 검증
    assert result is not None
    assert len(result) == 3

    # AAPL 검증 (대형 기술주 - 높은 점수 기대)
    aapl = next(r for r in result if r["symbol"] == "AAPL")
    assert aapl["bucket"] in ["A. Strong Trend Candidates", "B. Possible Trenders"]
    assert aapl["sector"] == "Technology"

    # XYZ 검증 (마이크로캡 + 고변동성 + 최근 IPO - 낮은 점수 기대)
    xyz = next(r for r in result if r["symbol"] == "XYZ")
    assert xyz["bucket"] in ["C. Likely Range/Choppy", "D. Exclude for Trend-Following"]

    # BAC 검증 (금융주 - 중간 점수 기대)
    bac = next(r for r in result if r["symbol"] == "BAC")
    assert bac["sector"] == "Financials"

    # 모든 결과에 필수 필드가 있는지 확인
    for stock in result:
        assert "symbol" in stock
        assert "name" in stock
        assert "score" in stock
        assert "bucket" in stock
        assert "reasons" in stock


def test_trend_following_bucket(mocker):
    """trend_following_bucket 메서드를 직접 테스트"""
    mock_stocks = [
        {
            "symbol": "TSLA",
            "name": "Tesla Inc.",
            "lastsale": "200.00",
            "pctchange": "5.0",
            "volume": "100000000",
            "marketCap": "600000000000",
            "sector": "Technology",
            "ipoyear": "2010"
        }
    ]

    mock_market_data_client = Mock()
    trend_follow = TrendFollow(mock_market_data_client)

    # trend_following_bucket 직접 호출
    result = trend_follow.trend_following_bucket(stocks=mock_stocks, asof_year=2025)

    assert len(result) == 1
    assert result[0]["symbol"] == "TSLA"
    assert result[0]["score"] is not None
    assert result[0]["bucket"] is not None
    assert len(result[0]["reasons"]) > 0
