from datetime import datetime, timedelta
from api.stock.repository.external_api_client import ExternalApiClient
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
def find_stocks(external_api_client: ExternalApiClient = None):
    sorted_objects = external_api_client.get_stocks()
    return sorted_objects

def find_crypto_currency(external_api_client: ExternalApiClient = None):
    return external_api_client.get_cryptos()

def save_stocks(external_api_client: ExternalApiClient = None):
    logger.info(f'ready to save Stocks!!')
    external_api_client.save_stocks()
    logger.info(f'finish to save Stocks!!')





