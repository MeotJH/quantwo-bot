import yfinance

from api.quant.domain.model import TrendFollowRequestDTO
from api.quant.domain.quant_type import AssetType, DataSource
from api.quant.domain.trend_follow_yahoo import TrendFollowYahoo
from exceptions import EntityNotFoundException
from util.logging_util import logger


class TrendFollow():

    @staticmethod
    def find_stock_by_id(dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        logger.info(f'item_id :::::: {dto.ticker}')
        finance_result = TrendFollow._get_stock(dto, period, trend_follow_days)
        # 마지막 교차점의 이동평균 값 가져오기
        last_cross_trend_follow = TrendFollow._find_last_cross_trend_follow(stock_data=finance_result['stock_data'])
        finance_result['stock_info']['lastCrossTrendFollow'] = last_cross_trend_follow

        stock_data = finance_result['stock_data'].sort_index(ascending=False)
        stock_data = stock_data.dropna(subset=['Trend_Follow'])
        # 결과를 딕셔너리 형태로 변환하여 반환
        stocks_dict = stock_data.reset_index().to_dict(orient='records')
        for stock in stocks_dict:
            stock['Date'] = stock['Date'].strftime('%Y-%m-%d')
        
        return {'stock_history' : stocks_dict, 'stock_info': finance_result['stock_info']}
    

    @staticmethod
    def _find_last_cross_trend_follow(stock_data: dict):
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
    

    @classmethod
    def _get_stock(cls, dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        #일단 야후만 존재하니까 이렇게 넣기
        key = (DataSource.YAHOO, AssetType.from_str(dto.asset_type))
        handler = cls._dispatch_table.get(key)
        if handler is None:
            raise EntityNotFoundException(f"Unsupported source/asset combination: {key}",422)

        return handler(dto, period, trend_follow_days)
    
    _dispatch_table = {
        (DataSource.YAHOO, AssetType.US): TrendFollowYahoo._get_stock_use_yfinance,
        (DataSource.YAHOO, AssetType.CRYPTO): TrendFollowYahoo._get_stock_use_yfinance,
        # (DataSource.COINMARKETCAP, AssetType.CRYPTO): _get_stock_coinmarketcap, 등 추가 가능
    }