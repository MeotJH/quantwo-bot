from typing import List

import requests
from flask_restx._http import HTTPStatus

from api.quant.domain.dtos.trend_follow_list_response import TrendFollowListResponse
from api.quant.domain.value_objects.model import TrendFollowRequestDTO
from api.quant.repository.market_data.market_data_client import MarketDataClient
from api.stock.models import Stock
from api.stock.repository.yfinance_api_client_impl import YFinanceApiClientImpl
from api.stock.services import find_stocks
from exceptions import AccessDeniedException
from util.logging_util import logger

import math
from datetime import datetime

SECTOR_WEIGHTS = {
        "Technology": 1.0,  # 소프트웨어, 반도체 포함 시 +가중
        "Industrials": 0.6,
        "Consumer Discretionary": 0.8,
        "Health Care": 0.7,  # 바이오는 변동성 큼 -> 후속 페널티로 상쇄
        "Financials": 0.4,
        "Finance": 0.4,  # 파일에 'Finance'로 오는 경우 대비
        "Energy": 0.5,
        "Materials": 0.5,
        "Real Estate": 0.3,
        "Utilities": 0.2,
        "Telecommunications": 0.3,
        "Miscellaneous": 0.3
    }
MARKETCAP_SMALL = 5e8  # 5억 달러
MARKETCAP_MICRO = 1e8  # 1억 달러
DAILY_PCT_ABS_HIGH = 10.0  # |일등락| 10% 이상이면 과도 변동으로 간주
RECENT_IPO_YEARS = 2

class TrendFollow():

    def __init__(self, market_data_client:MarketDataClient):
        self.market_data_client = market_data_client
        self.external_api_client = YFinanceApiClientImpl()

    def fetch_lists(self):
        try:
            stocks = find_stocks(self.external_api_client)
            trend_follows = self.trend_following_bucket(stocks=stocks)
            return trend_follows
        except (requests.exceptions.RequestException, ConnectionError, TimeoutError) as e:
            logger.error(e)
            raise AccessDeniedException('네트워크 요청에 문제가 발생했습니다..', HTTPStatus.FORBIDDEN)


    def find_stock_by_id(self,dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        logger.info(f'item_id :::::: {dto.ticker}')

        finance_result = self._get_stock(dto, period, trend_follow_days)
        # 마지막 교차점의 이동평균 값 가져오기
        last_cross_trend_follow = self._find_last_cross_trend_follow(stock_data=finance_result['stock_data'])
        finance_result['stock_info']['lastCrossTrendFollow'] = last_cross_trend_follow

        stock_data = finance_result['stock_data'].sort_index(ascending=False)
        stock_data = stock_data.dropna(subset=['Trend_Follow'])
        # 결과를 딕셔너리 형태로 변환하여 반환
        stocks_dict = stock_data.reset_index().to_dict(orient='records')
        for stock in stocks_dict:
            stock['Date'] = stock['Date'].strftime('%Y-%m-%d')
        
        return {'stock_history' : stocks_dict, 'stock_info': finance_result['stock_info']}
    

    def _find_last_cross_trend_follow(self, stock_data: dict):
        # 교차점 찾기: Close 값과 Trend_Follow 값의 차이의 부호가 바뀌는 지점 찾기
        stock_data['Prev_Close'] = stock_data['Close'].shift(1)
        stock_data['Prev_Trend_Follow'] = stock_data['Trend_Follow'].shift(1)
        # 교차 지점 판별 (부호가 바뀌는 지점)
        stock_data['Cross'] = (stock_data['Close'] > stock_data['Trend_Follow']) != (stock_data['Prev_Close'] > stock_data['Prev_Trend_Follow'])
        # 교차가 발생한 행 필터링
        cross_data = stock_data[stock_data['Cross'] & stock_data['Trend_Follow'].notnull()]
        if not cross_data.empty:
            last_cross_trend_follow = cross_data.iloc[-1]['Trend_Follow']
        else:
            last_cross_trend_follow = None
        
        return last_cross_trend_follow

    def _get_stock(self, dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        stocks = self.market_data_client.get_stocks(dto, period, trend_follow_days)
        return stocks

    def safe_float(self,x):
        if x is None:
            return None
        if isinstance(x, (int, float)):
            return float(x)
        s = str(x).strip().replace(",", "")
        # '$123.45' 또는 '1.23%' 처리
        if s.startswith("$"): s = s[1:]
        if s.endswith("%"): s = s[:-1]
        try:
            return float(s)
        except:
            return None

    def year_from_ipoyear(self,ipoyear):
        y = str(ipoyear).strip() if ipoyear is not None else ""
        return int(y) if y.isdigit() else None

    def trend_following_bucket(self, stocks = List[Stock], asof_year=None):
        """
        rows: JSON의 rows(list[dict]) 그대로 입력
        returns: 각 종목별 {symbol, name, score, bucket, reasons} 리스트
        """
        if asof_year is None:
            asof_year = datetime.now().year

        results: List[TrendFollowListResponse] = []
        for stock in stocks:
            symbol = stock.symbol
            name = stock.name

            # 기본 수치 파싱
            last = self.safe_float(stock.lastsale)
            pct = self.safe_float(stock.pctchange)  # % 기호 제거됨
            vol = self.safe_float(stock.volume)
            mcap = self.safe_float(stock.market_cap)
            sector = stock.sector
            ipoy = self.year_from_ipoyear(stock.ipo_year)

            reasons = []

            # 1) 유동성 점수 (로그 스케일)
            liq_score = 0.0
            if mcap and mcap > 0:
                liq_score += math.log10(mcap)
            if last and vol and last > 0 and vol > 0:
                traded_val = last * vol
                liq_score += 0.5 * math.log10(traded_val)  # 거래대금은 절반 가중
            reasons.append(f"LiquidityScore={liq_score:.2f}")

            # 2) 섹터 가중
            sector_w = SECTOR_WEIGHTS.get(sector, 0.4)
            reasons.append(f"SectorWeight={sector_w:.2f}")

            # 3) 변동성 페널티
            vol_penalty = 0.0
            if pct is not None and abs(pct) >= DAILY_PCT_ABS_HIGH:
                # 소형/마이크로에 가중 페널티
                if mcap and mcap < MARKETCAP_MICRO:
                    vol_penalty += 1.0
                elif mcap and mcap < MARKETCAP_SMALL:
                    vol_penalty += 0.6
                else:
                    vol_penalty += 0.3
            reasons.append(f"VolPenalty={vol_penalty:.2f}")

            # 4) IPO 페널티(상장 2년 미만)
            ipo_penalty = 0.0
            if isinstance(ipoy, int) and (asof_year - ipoy) < RECENT_IPO_YEARS:
                ipo_penalty = 0.4
            reasons.append(f"IPOPenalty={ipo_penalty:.2f}")

            # 5) 총점 산출
            score = (0.6 * liq_score) + (2.0 * sector_w) - (1.5 * vol_penalty) - (1.0 * ipo_penalty)

            # 6) 버킷 분류: 점수 경계는 경험적으로 설정(향후 백테스트로 조정 권장)
            if score >= 9.0:
                bucket = "A. Strong Trend Candidates"
            elif score >= 7.0:
                bucket = "B. Possible Trenders"
            elif score >= 5.0:
                bucket = "C. Likely Range/Choppy"
            else:
                bucket = "D. Exclude for Trend-Following"

            dto = TrendFollowListResponse(
                ticker=stock.symbol,
                name=stock.name,
                lastsale=stock.lastsale,
                netchange=stock.netchange,
                pctchange=stock.pctchange,
                volume=stock.volume,
                market_cap=stock.market_cap,
                country=stock.country,
                ipo_year=stock.ipo_year,
                industry=stock.industry,
                sector=stock.sector,
                url=stock.url,
                score=round(score, 2),
                bucket=bucket,
                reasons=reasons
            )
            results.append(dto)
        # 점수가 높은 순서대로 리턴
        return sorted(results, key=lambda r: r.score, reverse=True)

