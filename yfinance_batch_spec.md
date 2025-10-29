# 📘 yfinance Batch Collector Spec

> **Purpose:** 매일 00:10에 NASDAQ 상장 5,106개 종목의
> PER(`trailingPE`)과 부채비율(`debtToEquity`)을 yfinance를 이용해
> 수집하는 Python 배치 스크립트를 작성하고 운영한다.

------------------------------------------------------------------------

## 🧩 1️⃣ 배경

-   데이터 소스: `nasdap_json.json`\
    (파일에는 약 5106개의 NASDAQ 상장 종목이 포함되어 있으며, 각 항목은
    `symbol`, `name`, `marketCap`, `sector` 등으로 구성되어 있음)
-   목표:\
    Yahoo Finance의 `yfinance` 라이브러리를 이용해\
    **PER(trailingPE)** 과 **Debt-to-Equity(debtToEquity)** 두 항목을
    수집한다.
-   실행 주기: 매일 **00:10 KST**
-   출력: `daily_financials_YYYYMMDD.csv`

------------------------------------------------------------------------

## ⚙️ 2️⃣ 기능 요구사항

### ✅ 입력

-   JSON 파일 (`nasdap_json.json`)의 구조 예:

    ``` json
    {
      "rows": [
        {"symbol": "AAPL", "name": "Apple Inc.", "sector": "Technology"},
        {"symbol": "MSFT", "name": "Microsoft Corp.", "sector": "Technology"}
      ]
    }
    ```

### ✅ 처리 로직

1.  `rows` 배열에서 모든 `symbol` 추출 (약 5106개)

2.  티커를 **100개 단위로 나눠서(chunk)** 순차적으로
    `yfinance.Tickers()` 호출

3.  각 심볼에 대해 다음 데이터를 추출:

    -   `trailingPE`
    -   `debtToEquity`

4.  요청 간 `sleep(3초)`를 넣어 **Rate Limit 회피**

5.  `None` 값이나 실패한 종목은 로그에 남기고 skip

6.  결과를 CSV 파일로 저장:

    ``` csv
    symbol,per,debt_to_equity
    AAPL,31.2,178.4
    MSFT,34.8,52.9
    ```

7.  배치 실행 완료 시 로그 파일 생성\
    (`/logs/yfinance_batch_YYYYMMDD.log`)

------------------------------------------------------------------------

## 🧮 3️⃣ 호출 효율 및 제한

  항목                      수치
  ------------------------- ---------------------------------
  총 종목 수                5,106
  Chunk 크기                100
  코드 실행 횟수            약 52회
  Yahoo 내부 HTTP 요청 수   약 260\~400회
  수행 시간                 약 3\~5분
  차단 위험                 낮음 (sleep 3초 유지 시 안정적)

------------------------------------------------------------------------

## 🕛 4️⃣ 실행 스케줄 예시

### 🐧 Linux (crontab)

``` bash
10 0 * * * /usr/bin/python3 /opt/yf_batch/fetch_yf_financials.py >> /opt/yf_batch/logs/batch.log 2>&1
```

### 🪟 Windows (Task Scheduler)

-   Trigger: Daily at 00:10
-   Action:\
    `"C:\Python312\python.exe" "C:\scripts\fetch_yf_financials.py"`

------------------------------------------------------------------------

## 💻 5️⃣ 코드 요구사항

``` python
import yfinance as yf
import pandas as pd
import time, json, datetime

with open("nasdap_json.json", "r") as f:
    symbols = [r["symbol"] for r in json.load(f)["rows"]]

chunk_size = 100
results = []

for i in range(0, len(symbols), chunk_size):
    chunk = symbols[i:i + chunk_size]
    tickers = yf.Tickers(" ".join(chunk))

    for sym in chunk:
        try:
            info = tickers.tickers[sym].info
            results.append({
                "symbol": sym,
                "per": info.get("trailingPE"),
                "debt_to_equity": info.get("debtToEquity"),
            })
        except Exception as e:
            print(f"[ERROR] {sym}: {e}")
            continue

    print(f"Processed {i + len(chunk)} / {len(symbols)}")
    time.sleep(3)

df = pd.DataFrame(results)
out_path = f"daily_financials_{datetime.date.today()}.csv"
df.to_csv(out_path, index=False)
print(f"✅ Saved to {out_path}")
```

------------------------------------------------------------------------

## 🔐 6️⃣ 고급 개선사항 (선택)

1.  `requests-cache`로 24시간 캐싱

    ``` python
    import requests_cache
    requests_cache.install_cache('yf_cache', expire_after=86400)
    ```

2.  실패 시 재시도

    ``` python
    import tenacity
    @tenacity.retry(stop=tenacity.stop_after_attempt(3), wait=tenacity.wait_fixed(5))
    def fetch_info(sym): ...
    ```

3.  Slack / Teams Webhook으로 결과 보고\
    → 성공/실패 종목 수 전송

------------------------------------------------------------------------

## 🧾 7️⃣ 산출물 구조

  폴더                                      설명
  ----------------------------------------- --------------------
  `/data/nasdap_json.json`                  티커 원본
  `/output/daily_financials_YYYYMMDD.csv`   수집된 재무 데이터
  `/logs/yfinance_batch_YYYYMMDD.log`       실행 로그

------------------------------------------------------------------------

## 🧠 8️⃣ 요약 명령 (AI가 이해해야 하는 핵심)

> "5106 NASDAQ symbols에 대해 yfinance의 `trailingPE`와
> `debtToEquity`를\
> 100개 단위로 `Tickers()` 호출하여 3초 간격으로 순차 수집하고,\
> 매일 00:10에 배치로 실행해 CSV로 저장하라.\
> 전체 요청은 약 52회 chunk 실행, 내부 HTTP 약 300\~400회로 제한하라."
