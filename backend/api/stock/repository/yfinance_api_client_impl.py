from datetime import datetime, timedelta, timezone
import json
import subprocess
from typing import List
import requests
import pandas as pd
from api import db
from api.stock.domain.entities import Stocks as StockEntity
from api.stock.models import Stock
from api.stock.repository.external_api_client import ExternalApiClient
from util.transactional_util import transaction_scope
from api.stock.domain.stock_type import StockType
from util.logging_util import logger
from yahooquery import Ticker
import time

class YFinanceApiClientImpl(ExternalApiClient):
    # NASDAQ CSV 다운로드 URL
    NASDAQ_URL = "https://www.nasdaqtrader.com/dynamic/symdir/nasdaqlisted.txt"

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
                stock = Stock.from_nasdaq(stock_dict)
                stocks.append(stock)
        except KeyError as e:
            print(f"Error parsing stock data: {e}")
            return []
        
        logger.info(f'this is logger ::::: {len(stocks)} 개 검색완료 ')
        sorted_objects = sorted(stocks, key=lambda x: float(x.market_cap) if x.market_cap else 0.0, reverse=True)
        return sorted_objects

    def save_stocks(self) -> List[Stock]:
        stock = StockEntity.query.filter_by(stock_type=StockType.US).first()

        if self._should_refresh_data(stock):
            new_data = self._fetch_us_data()
            now = datetime.now(timezone.utc)

            with transaction_scope():
                if stock is None:
                    stock = StockEntity(
                        stock_type=StockType.US,
                        stock_infos=new_data,
                        insert_date=now
                    )
                    db.session.add(stock)
                else:
                    stock.stock_infos = new_data
                    stock.insert_date = now
            return new_data
        else:
            # 갱신이 필요 없으면 기존 데이터 반환
            return stock.stock_infos if stock else []

    def _fetch_us_data(self):
        """나스닥 전체 티커에서 기본 정보 + 요약 데이터 병합"""
        try:
            df = pd.read_csv(self.NASDAQ_URL, sep='|')
            df = df[df['Test Issue'] == 'N']
            df = df.dropna(subset=['Symbol'])
            # Strip whitespace from Symbol and Security Name
            df['Symbol'] = df['Symbol'].str.strip()
            df['Security Name'] = df['Security Name'].str.strip()
        except Exception as e:
            logger.error(f"❌ CSV 다운로드 실패: {e}")
            return []

        tickers = df['Symbol'].tolist()
        logger.info(f"✅ {len(tickers)}개 티커 로드 완료 (Yahoo 데이터 병합 시작)")

        stocks = []
        batch_size = 200  # yahooquery는 batch로 병렬 처리 가능 (100~250개 권장)

        for i in range(0, len(tickers), batch_size):
            batch = tickers[i:i + batch_size]
            t = Ticker(batch)
            quotes = t.price
            summary = t.summary_profile

            for sym in batch:
                info = quotes.get(sym, {})
                profile = summary.get(sym, {})

                # 방어 코드 추가
                if isinstance(profile, str):
                    profile = {}
                stocks.append({
                    "id": sym.lower(),
                    "symbol": sym,
                    "name": info.get("shortName") or df.loc[df['Symbol'] == sym, 'Security Name'].values[0],
                    "lastsale": info.get("regularMarketPrice"),
                    "netchange": info.get("regularMarketChange"),
                    "pctchange": info.get("regularMarketChangePercent"),
                    "volume": info.get("regularMarketVolume"),
                    "market_cap": info.get("marketCap"),
                    "country": profile.get("country"),
                    "ipo_year": profile.get("ipoYear"),
                    "industry": profile.get("industry"),
                    "sector": profile.get("sector"),
                    "url": f"https://finance.yahoo.com/quote/{sym}",
                })

            logger.info(f"📦 {i + len(batch)} / {len(tickers)} processed")
            time.sleep(2)  # Yahoo rate limit 완화용 (필요 시 2~3초 딜레이)

        logger.info(f"✅ 총 {len(stocks)}개 종목 정보 수집 완료")
        return stocks

    
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
            Stock.from_coingecko(info)
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