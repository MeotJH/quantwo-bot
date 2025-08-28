from datetime import datetime, timedelta, timezone
import json
import subprocess
from typing import List
import requests

from api import db
from api.stock.domain.entities import Stocks as StockEntity
from api.stock.models import Stock
from api.stock.repository.external_api_client import ExternalApiClient
from util.transactional_util import transaction_scope
from api.stock.domain.stock_type import StockType
from api import cache
from util.logging_util import logger


class YFinanceApiClientImpl(ExternalApiClient):

    def get_stocks(self) -> List[Stock]:
        external_api_url = "https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=25&offset=0&download=true"
        curl_command = [
            "curl",
            "-X", "GET",
            external_api_url,
            "-H", "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36",
            "-H", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "-H", "Accept-Encoding: gzip, deflate, br",
            "-H", "Accept-Language: en-US,en;q=0.9",
            "-H", "Connection: keep-alive",
            "-H", "Upgrade-Insecure-Requests: 1",
            "--compressed"
        ]

        try:
            result = subprocess.run(curl_command, capture_output=True, text=True, check=True)
            response_json = json.loads(result.stdout)
        except subprocess.CalledProcessError as e:
            print(f"Error occurred during curl execution: {e}")
            return []
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")
            return []

        stocks = []
        try:
            stocks_json = response_json['data']['rows']
            for stock_dict in stocks_json:
                stock = Stock(stock_dict)
                stocks.append(stock)
        except KeyError as e:
            print(f"Error parsing stock data: {e}")
            return []
        
        logger.info(f'this is logger ::::: {stocks} ')
        sorted_objects = sorted(stocks, key=lambda x: float(x.market_cap) if x.market_cap else 0.0, reverse=True)
        return sorted_objects
    
    def get_cryptos(self) -> List[Stock]:
        stock = StockEntity.query.filter_by(stock_type=StockType.CRYPTO).first()

        if self._should_refresh_data(stock):
            new_data = self._fetch_crypto_data()
            now = datetime.now(timezone.utc)

            with transaction_scope():
                if stock is None:
                    stock = StockEntity(
                        stock_type=StockType.CRYPTO,
                        stock_infos=new_data,
                        insert_date=now
                    )
                    db.session.add(stock)
                else:
                    stock.stock_infos = new_data
                    stock.insert_date = now

        return [
            {
                'symbol': info.get('symbol', ''),
                'name': info.get('name', ''),
                'lastsale': info.get('current_price', ''),
                'netchange': 0,
                'pctchange': info.get('price_change_percentage_24h', ''),
                'market_cap': info.get('market_cap', 0),
                'volume': info.get('total_volume', 0),
                'country': '',
                'ipo_year': '',
                'industry': '',
                'sector': '',
                'url': info.get('image', ''),
            }
            for info in (stock.stock_infos if stock else [])
        ]   


    COINGECKO_URL = "https://api.coingecko.com/api/v3/coins/markets"
    HEADERS = {"accept": "application/json"}
    COINGECKO_PARAMS = {
        "vs_currency": "usd",
        "order": "market_cap_desc",
        "per_page": 250,
        "page": 1,
        "sparkline": "false",
        "locale": "ko"
    }

    def _fetch_crypto_data(self):
        try:
            response = requests.get(self.COINGECKO_URL, headers=self.HEADERS, params=self.COINGECKO_PARAMS)
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            raise RuntimeError(f"Crypto API request failed: {e}")


    def _should_refresh_data(self, stock):
        if stock is None:
            return True
        now = datetime.now()
        return (now - stock.insert_date) > timedelta(hours=24)