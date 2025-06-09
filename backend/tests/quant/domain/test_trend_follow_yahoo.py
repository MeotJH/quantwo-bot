
from unittest.mock import Mock

from api.quant.domain.trend_follow_yahoo import TrendFollowYahoo



def test__get_stock_use_yfinance(mocker):
    import pandas as pd
    from api.quant.domain.model import TrendFollowRequestDTO
    mock_ticker = Mock()
    mock_ticker.history.return_value = pd.DataFrame({"Close":[100,101,102]})
    mocker.patch('yfinance.Ticker', return_value=mock_ticker)

    dto = TrendFollowRequestDTO(
        ticker='aapl',
        asset_type='us'
    )

    result = TrendFollowYahoo._get_stock_use_yfinance(dto)

    #검증
    mock_ticker.history.assert_called_once_with(period="1y")
    assert len(result['stock_data']) == 3
    assert isinstance(result['stock_info'],dict)
    assert result['stock_data']['Close'].iloc[-1] == 102
    pd.testing.assert_series_equal(
        result['stock_data']['Close']
        ,pd.Series([100,101,102])
        ,check_names=False
        )