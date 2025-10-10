import pandas as pd
from datetime import datetime, timedelta
from typing import List, Dict, Any
from dataclasses import dataclass
from api.quant.domain.dtos.back_test_summary_model import BackTestSummaryModel
from api.quant.domain.dtos.trading_period import TradingPeriod
from api.quant.repository.market_data.market_data_client import MarketDataClient
from api.quant.repository.market_data.yahoo_finance_client import YahooFinanceClient
from util.logging_util import logger

@dataclass
class BacktestConfig:
    initial_capital: float = 10000
    lookback_months: int = 6


class DualMomentumBacktest:
    def __init__(self, etf_symbols: List[str], duration: str, savings_rate: str,
                 config: BacktestConfig = BacktestConfig(),
                 market_data_client: MarketDataClient = YahooFinanceClient()):
        self.market_data_client = market_data_client
        end_date = datetime.today()
        start_date = end_date - timedelta(days=int(duration) * 365)
        self.etf_symbols = etf_symbols
        if 'EWY' not in self.etf_symbols:
            self.etf_symbols.append('EWY')
        self.start_date = start_date
        self.end_date = end_date
        self.savings_rate = savings_rate
        self.config = config
        self.monthly_savings_rate = float(savings_rate) / 100 / 12
        self.df = self._fetch_data()

    def _fetch_data(self) -> pd.DataFrame:
        """ETF 데이터 가져오기

        각 ETF 심볼에 대해 yfinance에서 'Close' 데이터를 다운로드한 후,
        pd.concat()을 사용해 심볼을 컬럼으로 하는 DataFrame으로 결합합니다.
        """
        data = {}
        start_date_str = self.start_date.strftime('%Y-%m-%d')
        end_date_str = self.end_date.strftime('%Y-%m-%d')

        data = self.market_data_client.get_close_prices(etf_symbols=self.etf_symbols
                                                        , start_date_str=start_date_str
                                                        , end_date_str=end_date_str
                                                        )
        if data:
            combined_df = pd.concat(data, axis=1)
            # pd.concat()의 결과가 멀티인덱스 컬럼으로 생성될 경우, 첫 번째 레벨만 사용
            if isinstance(combined_df.columns, pd.MultiIndex):
                combined_df.columns = combined_df.columns.get_level_values(0)
            return combined_df
        else:
            return pd.DataFrame()

    def run_backtest(self) -> Dict[str, Any]:
        """백테스트 실행"""
        capital = self.config.initial_capital
        results = []
        for date in pd.date_range(start=self.start_date, end=self.end_date, freq='ME'):
            if date - pd.DateOffset(months=self.config.lookback_months) < self.df.index[0]:
                continue

            result = self._process_trading_period(date, capital)
            if result:
                result['date'] = result['date'].strftime('%Y-%m-%d')
                results.append(result)

                capital = result['capital']

        results_df = pd.DataFrame(results)

        return {
            "data": results_df.to_dict('records'),
            "summary": self._generate_summary(results_df).to_dict()
        }

    def _process_trading_period(self, date: datetime, capital: float) -> Dict[str, Any]:
        """각 거래 기간 처리"""
        try:
            returns, monthly_returns = self._calculate_returns(date)
            months_passed = (date.year - self.start_date.year) * 12 + (date.month - self.start_date.month)
            cash_capital = self.config.initial_capital * (1 + self.monthly_savings_rate) ** months_passed
            buy_and_hold_capital = self._calculate_buy_and_hold(date, self.config.initial_capital)

            if all(monthly_returns <= self.monthly_savings_rate):
                capital *= (1 + self.monthly_savings_rate)
                return TradingPeriod.from_cash_hold(date=date, capital=capital, cash_capital=cash_capital,
                                                    buy_and_hold_capital=buy_and_hold_capital).to_dict()

            best_etf = monthly_returns.idxmax()
            capital *= (1 + monthly_returns[best_etf])

            return TradingPeriod.from_calculation(
                date=date,
                monthly_returns=monthly_returns,
                returns=returns,
                capital=capital,
                cash_capital=cash_capital,
                buy_and_hold_capital=buy_and_hold_capital,
            ).to_dict()
        except Exception as e:
            logger.error(f"Error processing trading period {date}: {e}")
            return None

    def _generate_summary(self, results_df: pd.DataFrame) -> BackTestSummaryModel:
        """백테스트 결과 요약 생성"""
        if results_df.empty:
            model = BackTestSummaryModel.of_empty(self.config)
            return model

        final_capital = float(results_df['capital'].iloc[-1])
        final_cash = float(results_df['cash_hold'].iloc[-1])
        final_ewy = float(results_df['ewy_hold'].iloc[-1])
        final_best_etf = results_df['best_etf'].iloc[-1]

        # 지난 6개월간 듀얼모멘텀 전략 수익률 계산
        today_best_profit = self._calculate_strategy_return_last_6_months()

        model = BackTestSummaryModel.of_calculation(
            config=self.config
            , final_capital=final_capital
            , final_cash=final_cash
            , final_ewy=final_ewy
            , final_best_etf=final_best_etf
            , today_best_profit=today_best_profit
        )
        return model

    def _calculate_strategy_return_last_6_months(self) -> float:
        """지난 6개월간 듀얼모멘텀 전략 수익률 계산 (매월 리밸런싱)"""
        capital = 1.0  # 초기 자본 1 (비율 계산용)
        check_date = datetime.today()
        start_date = check_date - pd.DateOffset(months=6)

        for date in pd.date_range(start=start_date, end=check_date, freq='ME'):
            # 데이터가 충분한지 확인
            if date - pd.DateOffset(months=self.config.lookback_months) < self.df.index[0]:
                continue

            try:
                returns, monthly_returns = self._calculate_returns(date)

                # 모든 ETF가 예금 금리보다 낮으면 현금 보유
                if all(monthly_returns <= self.monthly_savings_rate):
                    capital *= (1 + self.monthly_savings_rate)
                else:
                    # 최고 수익률 ETF에 투자
                    best_etf = monthly_returns.idxmax()
                    capital *= (1 + monthly_returns[best_etf])
            except Exception as e:
                logger.error(f"Error calculating strategy return for {date}: {e}")
                continue

        # 총 수익률을 퍼센트로 반환
        return (capital - 1) * 100

    def _calculate_returns(self, current_date: datetime) -> tuple[pd.Series, pd.Series]:
        """수익률 계산"""
        lookback_date = current_date - pd.DateOffset(months=self.config.lookback_months)

        # 가장 가까운 거래일로 조정
        if lookback_date not in self.df.index:
            valid_lookback = self.df.index[self.df.index >= lookback_date]
            if len(valid_lookback) == 0:
                lookback_date = self.df.index[0]
            else:
                lookback_date = valid_lookback[0]

        if current_date not in self.df.index:
            valid_current = self.df.index[self.df.index <= current_date]
            if len(valid_current) == 0:
                current_date = self.df.index[-1]
            else:
                current_date = valid_current[-1]

        prices = self.df.loc[lookback_date:current_date]

        # 데이터가 충분한지 확인
        if len(prices) < 2:
            logger.warning(f"Insufficient price data between {lookback_date} and {current_date}")
            return pd.Series(0, index=self.df.columns), pd.Series(0, index=self.df.columns)

        # NaN 체크 및 처리
        prices_filled = prices.ffill().bfill()  # forward fill 후 backward fill로 모든 NaN 제거

        start_prices = prices_filled.iloc[0]
        end_prices = prices_filled.iloc[-1]

        returns = (end_prices / start_prices - 1) * 100
        monthly_returns = (1 + returns / 100) ** (1 / self.config.lookback_months) - 1
        return returns, monthly_returns

    def _calculate_buy_and_hold(self, date: datetime, initial_capital: float) -> float:
        """Buy & Hold 전략 수익률 계산 (EWY 기준)"""
        try:
            buy_and_hold_symbol = 'EWY'
            date = pd.Timestamp(date).normalize()
            today = pd.Timestamp.today().normalize()
            if date > today:
                date = self.df.index.max()
            if date not in self.df.index:
                date = self.df.index[self.df.index <= date].max()
            start_price = self.df[buy_and_hold_symbol].iloc[0]
            current_price = self.df[buy_and_hold_symbol].loc[date]
            if not pd.isna(start_price) and not pd.isna(current_price):
                return initial_capital * (current_price / start_price)
            return initial_capital
        except Exception as e:
            logger.error(f"Error calculating buy and hold return for {date}: {e}")
            try:
                last_valid_date = self.df.index.max()
                return self._calculate_buy_and_hold(last_valid_date, initial_capital)
            except Exception:
                return initial_capital