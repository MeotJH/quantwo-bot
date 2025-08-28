import unittest
import subprocess
from unittest.mock import patch, MagicMock
import json
from flask import Flask

from api import cache
from api.stock.repository.yfinance_api_client_impl import YFinanceApiClientImpl
from api.stock.services import find_stocks
from api.stock.models import Stock

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