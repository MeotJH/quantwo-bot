from api.quant.domain.model import StockInfoModel


def from_yahoo_us(data: dict) -> dict:
    return StockInfoModel(
        shortName=data.get("shortName", ""),
        currentPrice=data.get("currentPrice", 0.0),
        previousClose=data.get("previousClose", 0.0),
        open=data.get("open", 0.0),
        volume=data.get("volume", 0.0),
        dayHigh=data.get("dayHigh", 0.0),
        dayLow=data.get("dayLow", 0.0),
        trailingPE=data.get("trailingPE", 0.0),
        fiftyTwoWeekHigh=data.get("fiftyTwoWeekHigh", 0.0),
        fiftyTwoWeekLow=data.get("fiftyTwoWeekLow", 0.0),
        trailingEps=data.get("trailingEps", 0.0),
        enterpriseValue=data.get("enterpriseValue", 0.0),
        ebitda=data.get("ebitda", 0.0),
    )

def from_yahoo_crypto(data: dict) -> dict:
    return StockInfoModel(
        shortName=data.get("shortName", ""),
        currentPrice=data.get("regularMarketPrice", 0.0),
        previousClose=data.get("previousClose", 0.0),
        open=data.get("open", 0.0),
        volume=data.get("volume", 0.0),
        dayHigh=data.get("dayHigh", 0.0),
        dayLow=data.get("dayLow", 0.0),
        trailingPE=0.0,
        fiftyTwoWeekHigh=data.get("fiftyTwoWeekHigh", 0.0),
        fiftyTwoWeekLow=data.get("fiftyTwoWeekLow", 0.0),
        trailingEps=0.0,
        enterpriseValue=data.get("marketCap", 0.0),
        ebitda=0.0,
    )
