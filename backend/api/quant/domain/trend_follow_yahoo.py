
import yfinance
from api.quant.domain.model import TrendFollowRequestDTO
from api.quant.domain.quant_type import DataSource
from api.quant.domain.stock_info_wrapper import StockInfoWrapper
from util.logging_util import logger


class TrendFollowYahoo():

    @staticmethod
    def _get_stock_use_yfinance(dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        logger.info(f":::yahoo finance api data::")
         # 주식 데이터를 최근 period간 가져옴
        logger.info(f"this is tickername :::: {dto.ticker}")
        stock_data = yfinance.Ticker(dto.ticker).history(period=period)
        # 75일 이동평균선 계산
        stock_data['Trend_Follow'] = stock_data['Close'].rolling(window=trend_follow_days).mean()

        logger.info(f"{stock_data['Trend_Follow']} :::: <<<<")
        stock_info_model = StockInfoWrapper.from_source(source=DataSource.YAHOO.value
                                ,category=dto.asset_type
                                , raw_data=yfinance.Ticker(dto.ticker).info
                                )
        
        logger.info(f'stock_info_model.__dict__ :::: {stock_info_model.__dict__}')
        return {"stock_data": stock_data, "stock_info": stock_info_model.__dict__}