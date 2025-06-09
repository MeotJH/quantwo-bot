import pytest
from unittest.mock import patch, MagicMock
from apscheduler.triggers.cron import CronTrigger
from pytz import timezone

from api.scheduler.quant_scheduler import QuantScheduler

@patch('api.scheduler.quant_scheduler.BackgroundScheduler')
def test_start_scheduler(MockBackgroundScheduler):
    # Mock된 BackgroundScheduler 인스턴스 생성
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    # QuantScheduler 인스턴스 생성
    scheduler = QuantScheduler()

    # 스케줄러 실행 여부 초기화
    mock_scheduler_instance.running = False

    # start() 실행
    scheduler.start()

    # 🔹 호출 횟수 검증
    assert mock_scheduler_instance.add_job.call_count == 2

    # 🔹 첫 번째 호출 인자 검증 (trend_follow)
    first_call = mock_scheduler_instance.add_job.call_args_list[0]
    args, kwargs = first_call

    assert args[0] == scheduler._run_check_and_notify_trend_follow
    assert isinstance(kwargs['trigger'], CronTrigger)
    assert "hour='22'" in str(kwargs['trigger'])
    assert "minute='30'" in str(kwargs['trigger'])
    assert kwargs['timezone'] == timezone('Asia/Seoul')

    # 🔹 두 번째 호출 인자 검증 (dualmomentum_international)
    second_call = mock_scheduler_instance.add_job.call_args_list[1]
    args2, kwargs2 = second_call

    assert args2[0] == scheduler._run_check_and_notify_dualmomentum_international
    assert isinstance(kwargs2['trigger'], CronTrigger)
    assert "day='1'" in str(kwargs2['trigger'])
    assert "hour='9'" in str(kwargs2['trigger'])
    assert "minute='0'" in str(kwargs2['trigger'])
    assert kwargs2['timezone'] == timezone('Asia/Seoul')

    # 🔹 스케줄러 실행 검증
    mock_scheduler_instance.start.assert_called_once()
