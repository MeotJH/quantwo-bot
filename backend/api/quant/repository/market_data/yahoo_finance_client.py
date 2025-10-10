import pandas as pd
import yfinance

from api.quant.domain.value_objects.model import TrendFollowRequestDTO
from api.quant.domain.value_objects.quant_type import DataSource
from api.quant.repository.market_data.mappers.stock_info_wrapper import StockInfoWrapper
from api.quant.repository.market_data.market_data_client import MarketDataClient
from util.logging_util import logger


class YahooFinanceClient(MarketDataClient):

    def get_stocks(self, dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        logger.info(f":::yahoo finance api data::")
        # 주식 데이터를 최근 period간 가져옴
        logger.info(f"this is tickername :::: {dto.ticker}")
        stock_data = yfinance.Ticker(dto.ticker).history(period=period)
        # 75일 이동평균선 계산
        stock_data['Trend_Follow'] = stock_data['Close'].rolling(window=trend_follow_days).mean()

        logger.info(f"{stock_data['Trend_Follow']} :::: <<<<")
        stock_info_model = StockInfoWrapper.from_source(source=DataSource.YAHOO.value
                                                        , category=dto.asset_type
                                                        , raw_data=yfinance.Ticker(dto.ticker).info
                                                        )

        logger.info(f'stock_info_model.__dict__ :::: {stock_info_model.__dict__}')
        return {"stock_data": stock_data, "stock_info": stock_info_model.__dict__}

    def get_close_prices(self,etf_symbols: list, start_date_str: str, end_date_str: str) -> dict[str, pd.Series]:
        data: dict[str, pd.Series] = {}

        try:
            df = yfinance.download(
                etf_symbols,
                start=start_date_str,
                end=end_date_str,
                progress=False,
                threads=True,
                group_by="column",
            )
        except Exception as e:
            logger.error(f"Batch download failed: {e}")
            return data

        if df.empty:
            logger.error("Batch download returned empty DataFrame.")
            return data

        # 단일/다중 심볼 모두 df['Close']로 접근 가능
        try:
            close = df["Close"]
        except KeyError:
            logger.error("No 'Close' level in downloaded DataFrame.")
            return data

        # 단일 심볼이면 Series, 다중이면 DataFrame
        if isinstance(close, pd.Series):
            series = close.dropna()
            if series.empty:
                logger.error(f"No 'Close' data points for symbol: {next(iter(etf_symbols), None)}")
            else:
                data[next(iter(etf_symbols))] = series
            return data

        # 다중 심볼
        for sym in etf_symbols:
            if sym not in close.columns:
                logger.error(f"Missing 'Close' column for symbol: {sym}")
                continue
            series = close[sym].dropna()
            if series.empty:
                logger.error(f"No 'Close' data points for symbol: {sym}")
                continue
            data[sym] = series

        return data