from datetime import datetime, timedelta, timezone
import requests
import subprocess
import json

from api import db
from api.stock.models import Stock
from api.stock.domain.entities import Stocks as StockEntity
from util.transactional_util import transaction_scope
from api.stock.domain.stock_type import StockType
from api import cache
from util.logging_util import logger

def daily_cache_key():
    """
    매일 23:10 기준으로 캐시를 업데이트 하는 함수
    """
    now = datetime.now()
    reset_hour = 23
    reset_minute = 10
    
    logger.info(f'this is time now :::: {now}')
    # 현재 시간이 reset 시각 이전이면 오늘 날짜 사용
    if now.hour < reset_hour or (now.hour == reset_hour and now.minute < reset_minute):
        date_key = now.strftime('%Y-%m-%d')
    else:
        date_key = (now.replace(hour=0, minute=0, second=0) + timedelta(days=1)).strftime('%Y-%m-%d')
    return f"my_function_cache::{date_key}"

@cache.cached(key_prefix=daily_cache_key)
def find_stocks():
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

    print(f'stock selected example array[0] :::::::: {stocks[0]}')
    sorted_objects = sorted(stocks, key=lambda x: float(x.market_cap) if x.market_cap else 0.0, reverse=True)
    return sorted_objects

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

def _fetch_crypto_data():
    try:
        response = requests.get(COINGECKO_URL, headers=HEADERS, params=COINGECKO_PARAMS)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise RuntimeError(f"Crypto API request failed: {e}")


def _should_refresh_data(stock):
    if stock is None:
        return True
    now = datetime.now()
    return (now - stock.insert_date) > timedelta(hours=24)

def find_crypto_currency():
    stock = StockEntity.query.filter_by(stock_type=StockType.CRYPTO).first()

    if _should_refresh_data(stock):
        new_data = _fetch_crypto_data()
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




