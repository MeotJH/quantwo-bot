from datetime import datetime, timedelta, timezone
import requests
import subprocess
import json

from api import db
from api.stock.models import Stock
from api.stock.domain.entities import Stocks as StockEntity
from util.transactional_util import transaction_scope
from api.stock.domain.stock_type import StockType

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

def find_crypto_currency():

    # 1. 기존 데이터 조회
    stock = StockEntity.query.filter_by(stock_type=StockType.CRYPTO).first()
    should_insert = False

    # 2. 데이터가 없으면 무조건 insert
    if stock is None:
        should_insert = True
    else:
        # 3. insert_date가 24시간 이상 지났는지 확인
        now = datetime.now()
        if now - stock.insert_date > timedelta(hours=24):
            should_insert = True
    # 조건 확인후 True면 insert
    if should_insert:
        url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=marker_cap_desc&per_page=250&page=1&sparkline=false&locale=ko"
        headers = {"accept": "application/json"}
        response = requests.get(url, headers=headers)
        stock = StockEntity(
            stock_type=StockType.CRYPTO,
            stock_infos= response.json(),
        )
        with transaction_scope():
            db.session.add(stock)
    
    #반환값 만들어주기
    stock_infos = stock.stock_infos
    return [   
        {
            'symbol': info.get('symbol',''),
            'name': info.get('name',''),
            'lastsale':info.get('current_price',''),
            'netchange' :0,
            'pctchange': info.get('price_change_percentage_24h',''),
            'market_cap':info.get('market_cap',0),
            'volume':info.get('total_volume',0),
            'country':'',
            'ipo_year':'',
            'industry':'',
            'sector':'',
            'url': info.get('image',''),
        }
        for info in stock_infos
    ]




