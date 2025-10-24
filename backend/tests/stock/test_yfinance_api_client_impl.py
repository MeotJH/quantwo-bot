import unittest
import subprocess
from unittest.mock import patch, MagicMock, Mock
import json
import pytest
import pandas as pd
from flask import Flask
from datetime import datetime, timedelta, timezone

from api import cache
from api.stock.repository.yfinance_api_client_impl import YFinanceApiClientImpl
from api.stock.services import find_stocks
from api.stock.models import Stock
from api.stock.domain.entities import Stocks as StockEntity
from api.stock.domain.stock_type import StockType

class TestFindStocks(unittest.TestCase):
    subprocess = 'api.stock.repository.yfinance_api_client_impl.subprocess.run'
    def setUp(self):
        """Set up a Flask app context for each test."""
        self.app = Flask(__name__)
        self.app.config['TESTING'] = True
        # Use a simple in-memory cache for tests
        self.app.config['CACHE_TYPE'] = 'SimpleCache'
        cache.init_app(self.app)
        self.app_context = self.app.app_context()
        self.app_context.push()
        # Clear cache before each test
        with self.app.app_context():
            cache.clear()

    def tearDown(self):
        """Tear down the app context."""
        self.app_context.pop()

    @patch(subprocess)
    def test_find_stocks_success(self, mock_subprocess_run):
        # Mock a successful API response
        mock_response_data = {
            "data": {
                "rows": [
                    {
                        "symbol": "AAPL", "name": "Apple Inc.", "lastsale": "150.00",
                        "netchange": "1.00", "pctchange": "0.67%", "marketCap": "2500000000000",
                        "volume": "100000000", "country": "United States", "ipoyear": "1980",
                        "industry": "Computer Manufacturing", "sector": "Technology", "url": "/market-activity/stocks/aapl"
                    },
                    {
                        "symbol": "GOOGL", "name": "Alphabet Inc.", "lastsale": "2800.00",
                        "netchange": "-10.00", "pctchange": "-0.36%", "marketCap": "19000000000000",
                        "volume": "2000000", "country": "United States", "ipoyear": "2004",
                        "industry": "Computer Software: Prepackaged Software", "sector": "Technology", "url": "/market-activity/stocks/googl"
                    }
                ]
            }
        }
        mock_stdout = json.dumps(mock_response_data)
        mock_subprocess_run.return_value = MagicMock(stdout=mock_stdout, stderr="", returncode=0)

        # Call the function
        api = YFinanceApiClientImpl()
        stocks = api.get_stocks()

        # Assertions
        self.assertEqual(len(stocks), 2)
        self.assertIsInstance(stocks[0], Stock)
        self.assertEqual(stocks[0].symbol, 'GOOGL') # Sorted by market cap
        self.assertEqual(stocks[1].symbol, 'AAPL')

    @patch(subprocess)
    def test_find_stocks_api_error(self, mock_subprocess_run):
        # Mock a failed API call
        mock_subprocess_run.side_effect = subprocess.CalledProcessError(1, 'curl')

        # Call the function
        api = YFinanceApiClientImpl()
        stocks = api.get_stocks()


        # Assertions
        self.assertEqual(stocks, [])

    @patch(subprocess)
    def test_find_stocks_json_decode_error(self, mock_subprocess_run):
        # Mock an invalid JSON response
        mock_subprocess_run.return_value = MagicMock(stdout="invalid json", stderr="", returncode=0)

        # Call the function
        api = YFinanceApiClientImpl()
        stocks = api.get_stocks()

        # Assertions
        self.assertEqual(stocks, [])

    @patch(subprocess)
    def test_find_stocks_missing_data_key(self, mock_subprocess_run):
        # Mock a response with missing 'data' key
        mock_response_data = {"invalid_key": {}}
        mock_stdout = json.dumps(mock_response_data)
        mock_subprocess_run.return_value = MagicMock(stdout=mock_stdout, stderr="", returncode=0)

        # Call the function
        api = YFinanceApiClientImpl()
        stocks = api.get_stocks()

        # Assertions
        self.assertEqual(stocks, [])

    @patch(subprocess)
    def test_find_stocks_missing_rows_key(self, mock_subprocess_run):
        # Mock a response with missing 'rows' key
        mock_response_data = {"data": {"invalid_rows_key": []}}
        mock_stdout = json.dumps(mock_response_data)
        mock_subprocess_run.return_value = MagicMock(stdout=mock_stdout, stderr="", returncode=0)

        # Call the function
        api = YFinanceApiClientImpl()
        stocks = api.get_stocks()

        # Assertions
        self.assertEqual(stocks, [])


class TestSaveStocks:
    """save_stocks 함수에 대한 테스트 (pytest 스타일)"""

    @pytest.fixture(autouse=True)
    def setup(self):
        """각 테스트 전에 실행"""
        self.api = YFinanceApiClientImpl()
        self.mock_stock_data = [
            {"id": "aapl", "symbol": "AAPL", "name": "Apple Inc."},
            {"id": "googl", "symbol": "GOOGL", "name": "Alphabet Inc."}
        ]

    def test_save_stocks_when_stock_does_not_exist(self, mocker):
        """DB에 stock이 없을 때 새로 생성하는 테스트"""
        # Given
        mock_stock_entity = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.StockEntity'
        )
        mock_stock_entity.query.filter_by.return_value.first.return_value = None

        mock_fetch = mocker.patch.object(
            YFinanceApiClientImpl, '_fetch_us_data',
            return_value=self.mock_stock_data
        )

        now = datetime.now(timezone.utc)
        mock_datetime = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.datetime'
        )
        mock_datetime.now.return_value = now

        mocker.patch('api.stock.repository.yfinance_api_client_impl.transaction_scope')
        mock_session = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.db.session'
        )

        # When
        result = self.api.save_stocks()

        # Then
        mock_stock_entity.query.filter_by.assert_called_once_with(stock_type=StockType.US)
        mock_fetch.assert_called_once()

        # StockEntity 생성자가 올바른 인자로 호출되었는지 확인
        mock_stock_entity.assert_called_once_with(
            stock_type=StockType.US,
            stock_infos=self.mock_stock_data,
            insert_date=now
        )

        # db.session.add가 호출되었는지 확인
        mock_session.add.assert_called_once()
        assert result == self.mock_stock_data

    def test_save_stocks_when_stock_exists_and_needs_refresh(self, mocker):
        """DB에 stock이 있고 24시간이 지나서 갱신이 필요한 경우"""
        # Given
        old_date = datetime.now(timezone.utc) - timedelta(hours=25)
        mock_stock = Mock()
        mock_stock.stock_type = StockType.US
        mock_stock.insert_date = old_date
        mock_stock.stock_infos = [{"id": "old", "symbol": "OLD", "name": "Old Stock"}]

        mock_stock_entity = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.StockEntity'
        )
        mock_stock_entity.query.filter_by.return_value.first.return_value = mock_stock

        mock_fetch = mocker.patch.object(
            YFinanceApiClientImpl, '_fetch_us_data',
            return_value=self.mock_stock_data
        )

        now = datetime.now(timezone.utc)
        mock_datetime = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.datetime'
        )
        mock_datetime.now.return_value = now

        mocker.patch('api.stock.repository.yfinance_api_client_impl.transaction_scope')
        mock_session = mocker.patch('api.stock.repository.yfinance_api_client_impl.db.session')

        # When
        result = self.api.save_stocks()

        # Then
        mock_fetch.assert_called_once()
        assert mock_stock.stock_infos == self.mock_stock_data
        assert mock_stock.insert_date == now
        mock_session.add.assert_not_called()  # 업데이트만 함
        assert result == self.mock_stock_data

    def test_save_stocks_when_stock_exists_and_no_refresh_needed(self, mocker):
        """DB에 stock이 있고 24시간이 지나지 않아서 갱신이 불필요한 경우"""
        # Given
        recent_date = datetime.now() - timedelta(hours=12)
        existing_stock_infos = [{"id": "existing", "symbol": "EXIST", "name": "Existing Stock"}]
        mock_stock = Mock()
        mock_stock.stock_type = StockType.US
        mock_stock.insert_date = recent_date
        mock_stock.stock_infos = existing_stock_infos

        mock_stock_entity = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.StockEntity'
        )
        mock_stock_entity.query.filter_by.return_value.first.return_value = mock_stock

        mock_fetch = mocker.patch.object(YFinanceApiClientImpl, '_fetch_us_data')

        now = datetime.now()
        mock_datetime = mocker.patch(
            'api.stock.repository.yfinance_api_client_impl.datetime'
        )
        mock_datetime.now.return_value = now

        # When
        result = self.api.save_stocks()

        # Then
        # 1. _fetch_us_data가 호출되지 않았는지 확인 (갱신 불필요)
        mock_fetch.assert_not_called()

        # 2. 기존 stock_infos를 반환하는지 확인
        assert result == existing_stock_infos


class TestFetchUsData:
    """_fetch_us_data 함수의 실제 동작을 테스트"""

    @pytest.fixture(autouse=True)
    def setup(self):
        """각 테스트 전에 실행"""
        self.api = YFinanceApiClientImpl()
        # NASDAQ_URL 속성이 없을 수 있으므로 추가
        self.api.NASDAQ_URL = "https://fake-nasdaq-url.com/data.csv"

    def test_fetch_us_data_success(self, mocker):
        """정상적으로 CSV를 읽고 데이터를 변환하는 경우"""
        # Given: 실제 NASDAQ CSV 형식의 데이터
        mock_df = pd.DataFrame({
            'Symbol': ['AAPL', 'GOOGL', 'MSFT'],
            'Security Name': ['Apple Inc.', 'Alphabet Inc.', 'Microsoft Corp.'],
            'Market Category': ['Q', 'Q', 'Q'],
            'Test Issue': ['N', 'N', 'N'],
            'Financial Status': ['N', 'N', 'N'],
            'Round Lot Size': [100, 100, 100],
            'ETF': ['N', 'N', 'N'],
            'NextShares': ['N', 'N', 'N']
        })

        mock_read_csv = mocker.patch('pandas.read_csv', return_value=mock_df)

        # Mock Ticker to prevent actual API calls
        mock_ticker_instance = mocker.Mock()
        mock_ticker_instance.price = {
            'AAPL': {},
            'GOOGL': {},
            'MSFT': {}
        }
        mock_ticker_instance.summary_profile = {
            'AAPL': {},
            'GOOGL': {},
            'MSFT': {}
        }
        mocker.patch('api.stock.repository.yfinance_api_client_impl.Ticker', return_value=mock_ticker_instance)

        # When
        result = self.api._fetch_us_data()

        # Then
        mock_read_csv.assert_called_once_with(self.api.NASDAQ_URL, sep='|')
        assert len(result) == 3
        assert result[0] == {"id": "aapl", "symbol": "AAPL", "name": "Apple Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/AAPL"}
        assert result[1] == {"id": "googl", "symbol": "GOOGL", "name": "Alphabet Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/GOOGL"}
        assert result[2] == {"id": "msft", "symbol": "MSFT", "name": "Microsoft Corp.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/MSFT"}

    def test_fetch_us_data_filters_test_issues(self, mocker):
        """Test Issue가 'Y'인 항목을 필터링하는 경우"""
        # Given: Test Issue가 섞여있는 데이터
        mock_df = pd.DataFrame({
            'Symbol': ['AAPL', 'TEST1', 'GOOGL', 'TEST2'],
            'Security Name': ['Apple Inc.', 'Test Stock 1', 'Alphabet Inc.', 'Test Stock 2'],
            'Market Category': ['Q', 'Q', 'Q', 'Q'],
            'Test Issue': ['N', 'Y', 'N', 'Y'],
            'Financial Status': ['N', 'N', 'N', 'N'],
            'Round Lot Size': [100, 100, 100, 100],
            'ETF': ['N', 'N', 'N', 'N'],
            'NextShares': ['N', 'N', 'N', 'N']
        })

        mocker.patch('pandas.read_csv', return_value=mock_df)

        # Mock Ticker to prevent actual API calls
        mock_ticker_instance = mocker.Mock()
        mock_ticker_instance.price = {
            'AAPL': {},
            'GOOGL': {}
        }
        mock_ticker_instance.summary_profile = {
            'AAPL': {},
            'GOOGL': {}
        }
        mocker.patch('api.stock.repository.yfinance_api_client_impl.Ticker', return_value=mock_ticker_instance)

        # When
        result = self.api._fetch_us_data()

        # Then: Test Issue가 'N'인 것만 반환
        assert len(result) == 2
        assert result[0] == {"id": "aapl", "symbol": "AAPL", "name": "Apple Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/AAPL"}
        assert result[1] == {"id": "googl", "symbol": "GOOGL", "name": "Alphabet Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/GOOGL"}

    def test_fetch_us_data_filters_nan_symbols(self, mocker):
        """NASDAQ Symbol이 NaN인 항목을 필터링하는 경우"""
        # Given: NaN이 포함된 데이터
        mock_df = pd.DataFrame({
            'Symbol': ['AAPL', None, 'GOOGL'],
            'Security Name': ['Apple Inc.', 'No Symbol Stock', 'Alphabet Inc.'],
            'Market Category': ['Q', 'Q', 'Q'],
            'Test Issue': ['N', 'N', 'N'],
            'Financial Status': ['N', 'N', 'N'],
            'Round Lot Size': [100, 100, 100],
            'ETF': ['N', 'N', 'N'],
            'NextShares': ['N', 'N', 'N']
        })

        mocker.patch('pandas.read_csv', return_value=mock_df)

        # Mock Ticker to prevent actual API calls
        mock_ticker_instance = mocker.Mock()
        mock_ticker_instance.price = {
            'AAPL': {},
            'GOOGL': {}
        }
        mock_ticker_instance.summary_profile = {
            'AAPL': {},
            'GOOGL': {}
        }
        mocker.patch('api.stock.repository.yfinance_api_client_impl.Ticker', return_value=mock_ticker_instance)

        # When
        result = self.api._fetch_us_data()

        # Then: NaN이 아닌 것만 반환
        assert len(result) == 2
        assert result[0] == {"id": "aapl", "symbol": "AAPL", "name": "Apple Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/AAPL"}
        assert result[1] == {"id": "googl", "symbol": "GOOGL", "name": "Alphabet Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/GOOGL"}

    def test_fetch_us_data_handles_csv_download_failure(self, mocker):
        """CSV 다운로드 실패 시 빈 리스트를 반환하는 경우"""
        # Given: read_csv가 예외를 발생시킴
        mocker.patch('pandas.read_csv', side_effect=Exception("Network error"))

        # When
        result = self.api._fetch_us_data()

        # Then: 빈 리스트 반환
        assert result == []

    def test_fetch_us_data_strips_whitespace(self, mocker):
        """Symbol과 Name의 공백을 제거하는 경우"""
        # Given: 공백이 포함된 데이터
        mock_df = pd.DataFrame({
            'Symbol': ['  AAPL  ', ' GOOGL '],
            'Security Name': [' Apple Inc. ', '  Alphabet Inc.  '],
            'Market Category': ['Q', 'Q'],
            'Test Issue': ['N', 'N'],
            'Financial Status': ['N', 'N'],
            'Round Lot Size': [100, 100],
            'ETF': ['N', 'N'],
            'NextShares': ['N', 'N']
        })

        mocker.patch('pandas.read_csv', return_value=mock_df)

        # Mock Ticker to prevent actual API calls
        # Note: After stripping, the keys should match the stripped symbols
        mock_ticker_instance = mocker.Mock()
        mock_ticker_instance.price = {
            'AAPL': {},
            'GOOGL': {}
        }
        mock_ticker_instance.summary_profile = {
            'AAPL': {},
            'GOOGL': {}
        }
        mocker.patch('api.stock.repository.yfinance_api_client_impl.Ticker', return_value=mock_ticker_instance)

        # When
        result = self.api._fetch_us_data()

        # Then: 공백이 제거된 결과
        assert result[0] == {"id": "aapl", "symbol": "AAPL", "name": "Apple Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/AAPL"}
        assert result[1] == {"id": "googl", "symbol": "GOOGL", "name": "Alphabet Inc.", "lastsale": None, "netchange": None, "pctchange": None, "volume": None, "market_cap": None, "country": None, "ipo_year": None, "industry": None, "sector": None, "url": "https://finance.yahoo.com/quote/GOOGL"}

    def test_fetch_us_data_converts_symbol_to_lowercase_id(self, mocker):
        """Symbol을 소문자로 변환해서 id로 사용하는 경우"""
        # Given
        mock_df = pd.DataFrame({
            'Symbol': ['AAPL', 'GOOGL'],
            'Security Name': ['Apple Inc.', 'Alphabet Inc.'],
            'Market Category': ['Q', 'Q'],
            'Test Issue': ['N', 'N'],
            'Financial Status': ['N', 'N'],
            'Round Lot Size': [100, 100],
            'ETF': ['N', 'N'],
            'NextShares': ['N', 'N']
        })

        mocker.patch('pandas.read_csv', return_value=mock_df)

        # When
        result = self.api._fetch_us_data()

        # Then: id는 소문자, symbol은 대문자 유지
        assert result[0]["id"] == "aapl"
        assert result[0]["symbol"] == "AAPL"
        assert result[1]["id"] == "googl"
        assert result[1]["symbol"] == "GOOGL"