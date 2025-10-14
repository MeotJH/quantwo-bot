# StockScheduler 테스트 코드 클론코딩 가이드

## 목표
`api/scheduler/stock_scheduler.py`의 StockScheduler 클래스가 제대로 동작하는지 확인하는 pytest 테스트 코드를 단계별로 작성합니다.

---

## 사전 지식

### StockScheduler 클래스의 주요 기능
1. **싱글톤 패턴**: 인스턴스가 하나만 생성됨
2. **스케줄링**: 매일 새벽 1시 30분(한국 시간)에 US 주식 데이터 저장
3. **Flask 컨텍스트**: Flask 앱 컨텍스트 안에서 실행됨
4. **주요 메서드**:
   - `start()`: 스케줄러 시작 및 작업 등록
   - `_run_save_us_stock_json()`: 실제 주식 데이터 저장 작업
   - `shutdown()`: 스케줄러 종료

### 테스트에서 사용할 주요 라이브러리
- `pytest`: 테스트 프레임워크
- `unittest.mock`: Mock 객체 생성 (patch, MagicMock)
- `apscheduler`: 스케줄러 라이브러리

---

## 단계별 클론코딩

### Step 0: 테스트 파일 생성
먼저 `tests/scheduler/test_stock_scheduler.py` 파일을 생성합니다.

---

### Step 1: 기본 import 작성하기

```python
import pytest
from unittest.mock import patch, MagicMock
from apscheduler.triggers.cron import CronTrigger
from pytz import timezone

from api.scheduler.stock_scheduler import StockScheduler
```

**설명**:
- `pytest`: 테스트 프레임워크
- `patch`: 실제 객체를 Mock 객체로 대체
- `MagicMock`: 유연한 Mock 객체 생성
- `CronTrigger`, `timezone`: 스케줄 트리거 검증용

**실행**: 아직 실행하지 않고 다음 단계로 진행합니다.

---

### Step 2: 첫 번째 테스트 - 스케줄러 시작 테스트 (기본 구조)

```python
@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_start_scheduler(MockBackgroundScheduler):
    # Given: Mock된 BackgroundScheduler 인스턴스 생성
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    # Given: QuantScheduler 인스턴스 생성
    scheduler = StockScheduler()

    # Given: 스케줄러가 실행되지 않은 상태로 설정
    mock_scheduler_instance.running = False

    # When: start() 메서드 실행
    scheduler.start()

    # Then: add_job이 호출되었는지 확인
    assert mock_scheduler_instance.add_job.called
```

**설명**:
- `@patch`: BackgroundScheduler를 Mock으로 대체하여 실제 스케줄러가 실행되지 않도록 함
- `MockBackgroundScheduler.return_value`: StockScheduler가 생성할 때 Mock 인스턴스를 반환하도록 설정
- `mock_scheduler_instance.running = False`: 스케줄러가 아직 실행되지 않은 상태를 시뮬레이션

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_start_scheduler -v
```

---

### Step 3: 스케줄 설정 검증하기 (호출 횟수 확인)

이전 테스트를 확장하여 `add_job`이 정확히 1번 호출되었는지 확인합니다.

```python
@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_start_scheduler(MockBackgroundScheduler):
    # Given
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance
    scheduler = StockScheduler()
    mock_scheduler_instance.running = False

    # When
    scheduler.start()

    # Then: 호출 횟수 검증
    assert mock_scheduler_instance.add_job.call_count == 1
```

**설명**:
- `call_count`: 메서드가 몇 번 호출되었는지 확인
- StockScheduler는 1개의 작업만 등록하므로 `call_count == 1`

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_start_scheduler -v
```

---

### Step 4: 스케줄 트리거 세부 사항 검증하기

이제 `add_job`에 전달된 인자(트리거, 시간대 등)가 올바른지 확인합니다.

```python
@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_start_scheduler(MockBackgroundScheduler):
    # Given
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance
    scheduler = StockScheduler()
    mock_scheduler_instance.running = False

    # When
    scheduler.start()

    # Then: 호출 횟수 검증
    assert mock_scheduler_instance.add_job.call_count == 1

    # Then: 첫 번째 호출 인자 추출
    first_call = mock_scheduler_instance.add_job.call_args_list[0]
    args, kwargs = first_call

    # Then: 함수가 올바르게 전달되었는지 확인
    assert args[0] == scheduler._run_save_us_stock_json

    # Then: CronTrigger가 올바른지 확인
    assert isinstance(kwargs['trigger'], CronTrigger)
    assert "hour='1'" in str(kwargs['trigger']) or "hour='01'" in str(kwargs['trigger'])
    assert "minute='30'" in str(kwargs['trigger'])

    # Then: 타임존이 올바른지 확인
    assert kwargs['timezone'] == timezone('Asia/Seoul')
```

**설명**:
- `call_args_list[0]`: 첫 번째 호출의 인자를 가져옴
- `args`: 위치 인자 (함수)
- `kwargs`: 키워드 인자 (trigger, timezone 등)
- `str(kwargs['trigger'])`: CronTrigger를 문자열로 변환하여 시간 확인

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_start_scheduler -v
```

---

### Step 5: 싱글톤 패턴 테스트 작성하기

StockScheduler가 싱글톤으로 동작하는지 확인합니다.

```python
def test_singleton_pattern():
    # Given & When: 두 개의 인스턴스 생성
    scheduler1 = StockScheduler()
    scheduler2 = StockScheduler()

    # Then: 두 인스턴스가 동일한 객체인지 확인
    assert scheduler1 is scheduler2
```

**설명**:
- `is`: 두 객체가 메모리에서 같은 객체인지 확인 (== 와 다름)
- 싱글톤 패턴은 여러 번 생성해도 항상 같은 인스턴스를 반환

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_singleton_pattern -v
```

**주의**: 이 테스트를 실행하기 전에 싱글톤 인스턴스를 초기화해야 할 수 있습니다.
```python
def test_singleton_pattern():
    # Given: 싱글톤 초기화
    StockScheduler._instance = None

    # When
    scheduler1 = StockScheduler()
    scheduler2 = StockScheduler()

    # Then
    assert scheduler1 is scheduler2
```

---

### Step 6: shutdown 메서드 테스트 작성하기

스케줄러가 정상적으로 종료되는지 테스트합니다.

```python
@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_shutdown_when_running(MockBackgroundScheduler):
    # Given: 실행 중인 스케줄러
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance
    scheduler = StockScheduler()
    mock_scheduler_instance.running = True

    # When: shutdown 메서드 호출
    scheduler.shutdown()

    # Then: shutdown이 호출되었는지 확인
    mock_scheduler_instance.shutdown.assert_called_once_with(wait=False)
```

**설명**:
- `running = True`: 스케줄러가 실행 중인 상태 시뮬레이션
- `assert_called_once_with(wait=False)`: 특정 인자로 정확히 1번 호출되었는지 확인

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_shutdown_when_running -v
```

---

### Step 7: shutdown 시 실행 중이지 않을 때 테스트

```python
@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_shutdown_when_not_running(MockBackgroundScheduler):
    # Given: 실행 중이 아닌 스케줄러
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance
    scheduler = StockScheduler()
    mock_scheduler_instance.running = False

    # When: shutdown 메서드 호출
    scheduler.shutdown()

    # Then: shutdown이 호출되지 않았는지 확인
    mock_scheduler_instance.shutdown.assert_not_called()
```

**설명**:
- `running = False`: 스케줄러가 실행 중이 아닌 상태
- `assert_not_called()`: 메서드가 호출되지 않았는지 확인

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_shutdown_when_not_running -v
```

---

### Step 8: _run_save_us_stock_json 메서드 테스트

Flask 앱 컨텍스트 내에서 save_stocks가 호출되는지 테스트합니다.

```python
@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
@patch('api.scheduler.stock_scheduler.YFinanceApiClientImpl')
@patch('api.scheduler.stock_scheduler.save_stocks')
def test_run_save_us_stock_json(MockSaveStocks, MockYFinanceApiClient, MockBackgroundScheduler):
    # Given: Flask 앱 모킹
    mock_app = MagicMock()
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    # Given: StockScheduler 생성
    scheduler = StockScheduler(app=mock_app)

    # Given: YFinanceApiClient 모킹
    mock_api_client = MagicMock()
    MockYFinanceApiClient.return_value = mock_api_client

    # When: _run_save_us_stock_json 실행
    scheduler._run_save_us_stock_json()

    # Then: app_context가 사용되었는지 확인
    mock_app.app_context.assert_called_once()

    # Then: YFinanceApiClientImpl이 생성되었는지 확인
    MockYFinanceApiClient.assert_called_once()

    # Then: save_stocks가 호출되었는지 확인
    MockSaveStocks.assert_called_once_with(mock_api_client)
```

**설명**:
- 여러 개의 `@patch` 데코레이터를 사용하여 의존성을 모두 Mock으로 대체
- `app_context()`가 호출되어 Flask 컨텍스트가 사용되는지 확인
- `save_stocks`가 올바른 인자로 호출되는지 확인

**실행**:
```bash
pytest tests/scheduler/test_stock_scheduler.py::test_run_save_us_stock_json -v
```

---

### Step 9: 전체 테스트 실행하기

모든 테스트를 한 번에 실행합니다.

```bash
pytest tests/scheduler/test_stock_scheduler.py -v
```

**예상 결과**:
```
tests/scheduler/test_stock_scheduler.py::test_start_scheduler PASSED
tests/scheduler/test_stock_scheduler.py::test_singleton_pattern PASSED
tests/scheduler/test_stock_scheduler.py::test_shutdown_when_running PASSED
tests/scheduler/test_stock_scheduler.py::test_shutdown_when_not_running PASSED
tests/scheduler/test_stock_scheduler.py::test_run_save_us_stock_json PASSED
```

---

## 최종 완성 코드

```python
import pytest
from unittest.mock import patch, MagicMock
from apscheduler.triggers.cron import CronTrigger
from pytz import timezone

from api.scheduler.stock_scheduler import StockScheduler


@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_start_scheduler(MockBackgroundScheduler):
    """스케줄러 시작 시 작업이 올바르게 등록되는지 테스트"""
    # Given: Mock된 BackgroundScheduler 인스턴스 생성
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    # Given: StockScheduler 인스턴스 생성
    scheduler = StockScheduler()

    # Given: 스케줄러가 실행되지 않은 상태로 설정
    mock_scheduler_instance.running = False

    # When: start() 메서드 실행
    scheduler.start()

    # Then: 호출 횟수 검증
    assert mock_scheduler_instance.add_job.call_count == 1

    # Then: 첫 번째 호출 인자 검증
    first_call = mock_scheduler_instance.add_job.call_args_list[0]
    args, kwargs = first_call

    assert args[0] == scheduler._run_save_us_stock_json
    assert isinstance(kwargs['trigger'], CronTrigger)
    assert "hour='1'" in str(kwargs['trigger']) or "hour='01'" in str(kwargs['trigger'])
    assert "minute='30'" in str(kwargs['trigger'])
    assert kwargs['timezone'] == timezone('Asia/Seoul')


def test_singleton_pattern():
    """StockScheduler가 싱글톤 패턴으로 동작하는지 테스트"""
    # Given: 싱글톤 초기화
    StockScheduler._instance = None

    # When: 두 개의 인스턴스 생성
    scheduler1 = StockScheduler()
    scheduler2 = StockScheduler()

    # Then: 두 인스턴스가 동일한 객체인지 확인
    assert scheduler1 is scheduler2


@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_shutdown_when_running(MockBackgroundScheduler):
    """스케줄러가 실행 중일 때 정상적으로 종료되는지 테스트"""
    # Given: 실행 중인 스케줄러
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance
    scheduler = StockScheduler()
    mock_scheduler_instance.running = True

    # When: shutdown 메서드 호출
    scheduler.shutdown()

    # Then: shutdown이 호출되었는지 확인
    mock_scheduler_instance.shutdown.assert_called_once_with(wait=False)


@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
def test_shutdown_when_not_running(MockBackgroundScheduler):
    """스케줄러가 실행 중이 아닐 때 shutdown 동작 테스트"""
    # Given: 실행 중이 아닌 스케줄러
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance
    scheduler = StockScheduler()
    mock_scheduler_instance.running = False

    # When: shutdown 메서드 호출
    scheduler.shutdown()

    # Then: shutdown이 호출되지 않았는지 확인
    mock_scheduler_instance.shutdown.assert_not_called()


@patch('api.scheduler.stock_scheduler.BackgroundScheduler')
@patch('api.scheduler.stock_scheduler.YFinanceApiClientImpl')
@patch('api.scheduler.stock_scheduler.save_stocks')
def test_run_save_us_stock_json(MockSaveStocks, MockYFinanceApiClient, MockBackgroundScheduler):
    """_run_save_us_stock_json이 Flask 컨텍스트 내에서 올바르게 실행되는지 테스트"""
    # Given: Flask 앱 모킹
    mock_app = MagicMock()
    mock_scheduler_instance = MagicMock()
    MockBackgroundScheduler.return_value = mock_scheduler_instance

    # Given: StockScheduler 생성
    scheduler = StockScheduler(app=mock_app)

    # Given: YFinanceApiClient 모킹
    mock_api_client = MagicMock()
    MockYFinanceApiClient.return_value = mock_api_client

    # When: _run_save_us_stock_json 실행
    scheduler._run_save_us_stock_json()

    # Then: app_context가 사용되었는지 확인
    mock_app.app_context.assert_called_once()

    # Then: YFinanceApiClientImpl이 생성되었는지 확인
    MockYFinanceApiClient.assert_called_once()

    # Then: save_stocks가 호출되었는지 확인
    MockSaveStocks.assert_called_once_with(mock_api_client)
```

---

## 학습 포인트

### 1. Mock이란?
- 실제 객체를 대신하는 가짜 객체
- 외부 의존성(DB, API, 스케줄러 등)을 제거하여 테스트를 빠르고 안정적으로 만듦

### 2. @patch 데코레이터
- 특정 모듈이나 클래스를 Mock으로 대체
- `@patch('전체.경로.클래스명')`

### 3. MagicMock
- 유연한 Mock 객체로, 어떤 속성이나 메서드 호출도 가능
- `mock_object.method.assert_called_once()` 같은 검증 메서드 제공

### 4. call_args_list
- Mock 객체가 호출될 때 전달된 인자들을 기록
- `call_args_list[0]`로 첫 번째 호출의 인자 확인

### 5. 싱글톤 패턴 테스트
- `_instance = None`으로 초기화 후 테스트
- `is` 연산자로 동일 객체 확인

---

## 추가 학습 자료

### 다음 단계로 학습하면 좋을 것들
1. **pytest-mock 플러그인**: `mocker` fixture를 사용한 더 간결한 테스트
2. **fixture**: 반복되는 설정 코드를 재사용
3. **parametrize**: 여러 입력값으로 동일한 테스트 반복
4. **coverage**: 테스트 커버리지 측정

### 참고 명령어
```bash
# 특정 테스트만 실행
pytest tests/scheduler/test_stock_scheduler.py::test_start_scheduler

# 상세 출력
pytest tests/scheduler/test_stock_scheduler.py -v

# 커버리지 측정
pytest tests/scheduler/test_stock_scheduler.py --cov=api.scheduler.stock_scheduler

# 모든 테스트 실행
pytest
```

---

## 마무리

이 가이드를 따라하면서:
1. 각 단계를 직접 타이핑하면서 익히세요
2. 각 assert문이 왜 필요한지 이해하세요
3. Mock이 어떻게 동작하는지 관찰하세요
4. 테스트가 실패하면 왜 실패했는지 분석하세요

축하합니다! 이제 pytest와 Mock을 사용한 스케줄러 테스트 코드를 작성할 수 있습니다.
