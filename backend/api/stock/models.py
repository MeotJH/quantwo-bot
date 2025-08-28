from dataclasses import dataclass

@dataclass
class Stock:
    symbol: str
    name: str
    lastsale: str
    netchange: str
    pctchange: str
    volume: str
    market_cap: str
    country: str
    ipo_year: str
    industry: str
    sector: str
    url: str

    @classmethod
    def from_nasdaq(cls, stock):
        return cls(
            symbol=stock.get('symbol', None),
            name=stock.get('name', None),
            lastsale=stock.get('lastsale', None),
            netchange=stock.get('netchange', None),
            pctchange=stock.get('pctchange', None),
            volume=stock.get('volume', None),
            market_cap=stock.get('marketCap', '0'),
            country=stock.get('country', None),
            ipo_year=stock.get('ipoyear', None),
            industry=stock.get('industry', None),
            sector=stock.get('sector', None),
            url=stock.get('url', None)
        )
    
    @classmethod
    def from_coingecko(cls, info):
        return cls(
            symbol=info.get('symbol', ''),
            name=info.get('name', ''),
            lastsale=str(info.get('current_price', '')),
            netchange='0',
            pctchange=str(info.get('price_change_percentage_24h', '')),
            volume=str(info.get('total_volume', 0)),
            market_cap=str(info.get('market_cap', 0)),
            country='',
            ipo_year='',
            industry='',
            sector='',
            url=info.get('image', '')
        )