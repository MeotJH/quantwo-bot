from api.quant.domain.value_objects.model import TrendFollowRequestDTO
from api.quant.repository.market_data.market_data_client import MarketDataClient
from util.logging_util import logger


class TrendFollow():

    def __init__(self, market_data_client:MarketDataClient):
        self.market_data_client = market_data_client

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
