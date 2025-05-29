import yfinance

from api.quant.domain.model import TrendFollowRequestDTO
from api.quant.domain.stock_info_wrapper import DataSource, StockInfoWrapper


class TrendFollow():

    @staticmethod
    def find_stock_by_id(dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        print(f'item_id :::::: {dto.ticker}')
        finance_result = TrendFollow._get_stock_use_yfinance(dto, period, trend_follow_days)
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
    def _get_stock_use_yfinance(dto: TrendFollowRequestDTO, period='1y', trend_follow_days=75):
        #asset_type에 따른 api값 달라짐으로
        #TODO api값에 따라서 달라지지 않게 wrapping 필요함 response를 infrastucture를 만들어서 closeprice로 통일 등..
        #close_price =  'Close' if dto.asset_type == 'US' else 'regularMarketPreviousClose'

         # 주식 데이터를 최근 period간 가져옴
        print(f"this is tickername :::: {dto.ticker}")
        stock_data = yfinance.Ticker(dto.ticker).history(period=period)
        # 75일 이동평균선 계산
        stock_data['Trend_Follow'] = stock_data['Close'].rolling(window=trend_follow_days).mean()

        print(f"{stock_data['Trend_Follow']} :::: <<<<")
        stock_info_model = StockInfoWrapper.from_source(source=DataSource.YAHOO.value
                                ,category=dto.asset_type
                                , raw_data=yfinance.Ticker(dto.ticker).info
                                )
        
        print(f'stock_info_model.__dict__ :::: {stock_info_model.__dict__}')
        return {"stock_data": stock_data, "stock_info": stock_info_model.__dict__}
    

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