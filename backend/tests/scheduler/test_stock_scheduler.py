import pytest
from unittest.mock import patch, MagicMock
from apscheduler.triggers.cron import CronTrigger
from pytz import timezone

from api.scheduler.stock_scheduler import StockScheduler

@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_start_scheduler(MockBackgroundScheduler):
    #Given: 싱글톤 초기화
    StockScheduler._instance = None

    #Given: Mock된 BackgroundScheduler 인스턴스 생성
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    #Given: QuantScheduler 인스턴스 생성
    scheduler = StockScheduler()

    #Given: 스케줄러가 실행되지 않은 상태로 설정
    mock_scheduler_instance.running = False

    #When: start() 메서드 실행
    scheduler.start()

    #Then: add_job이 호출되었는지 확인
    assert mock_scheduler_instance.add_job.called
    assert mock_scheduler_instance.add_job.call_count == 1

    #Then: get first arg
    first_call = mock_scheduler_instance.add_job.call_args_list[0]
    args, kwargs = first_call

    #then: check correct function called
    assert args[0] == scheduler._run_save_us_stock_json

    #then: find out correct Crontrigger
    assert isinstance(kwargs['trigger'], CronTrigger)
    assert "hour='1'" in str(kwargs['trigger']) or "hour='01'" in str(kwargs['trigger'])
    assert "minute='30'" in str(kwargs['trigger'])

    #then : check out time-zone is correct
    assert kwargs['timezone'] == timezone('Asia/Seoul')

def test_singleton_pattern():
    #Given : clear instance
    StockScheduler._instance = None

    #When: create two instance
    scheduler1 = StockScheduler()
    scheduler2 = StockScheduler()

    #Then: find out two instance is Equals
    assert scheduler1 is scheduler2

@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_shutdown_when_running(MockBackgroundScheduler):
    #Given: 싱글톤 초기화
    StockScheduler._instance = None

    # Given: running schduler
    mock_schduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_schduler_instance
    scheduler = StockScheduler()
    mock_schduler_instance.running = True

    # When: shutdown method call
    scheduler.shutdown()

    #Then: check shutdown is called
    mock_schduler_instance.shutdown.assert_called_with(wait=False)

@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
@patch('api.scheduler.stock_scheduler.YFinanceApiClientImpl')
@patch('api.scheduler.stock_scheduler.save_stocks')
def test_run_save_stock_json(MockSaveStocks, MockYFinanceApiClient, MockBackgroundScheduler):
    #Given: 싱글톤 초기화
    StockScheduler._instance = None

    #Given: Flask Mocking
    mock_app = MagicMock()
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    #Given: StockSchduler create
    scheduler = StockScheduler(app=mock_app)

    #Given: Yfinance mocking
    mock_api_client = MagicMock()
    MockYFinanceApiClient.return_value = mock_api_client

    #when: _run_save_us_stock_json run
    scheduler._run_save_us_stock_json()

    #then: app_context is used check
    mock_app.app_context.assert_called_once()

    #then YTFinanceApiClientImpl is create check
    MockYFinanceApiClient.assert_called_once()

    #Then: save_stocks is called?
    MockSaveStocks.assert_called_once_with(mock_api_client)





