from flask import Flask
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from pytz import timezone

from api.stock.repository.yfinance_api_client_impl import YFinanceApiClientImpl
from api.stock.services import save_stocks
from util.logging_util import logger


class StockScheduler:
    _instance = None

    def __new__(cls, app: Flask = None):
        if cls._instance is None:
            cls._instance = super(StockScheduler, cls).__new__(cls)
            cls._instance.scheduler = BackgroundScheduler()
            cls._instance.save_stocks = save_stocks
            cls._instance.app = app
        return cls._instance

    def start(self):
        if not self.scheduler.running:
            # 한국 시간 밤 01:30에 실행
            self.scheduler.add_job(
                self._run_save_us_stock_json,
                trigger=CronTrigger(hour='01', minute=30),
                # trigger=IntervalTrigger(seconds=10),
                timezone=timezone('Asia/Seoul')
            )

    def _run_save_us_stock_json(self):
        with self.app.app_context():
            external_api_client = YFinanceApiClientImpl()
            self.save_stocks(external_api_client)

    def shutdown(self):
        if self.scheduler.running:
            logger.info("Shutting down Stock Scheduler")
            self.scheduler.shutdown(wait=False)
        else:
            logger.warning("Stock Scheduler is not running")