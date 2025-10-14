import requests

url = "https://financialmodelingprep.com/api/v3/stock/list?apikey=demo"
r = requests.get(url)
data = r.json()

tickers = [x['symbol'] for x in data]
print(f"총 {len(tickers)}개 ticker 수집")
