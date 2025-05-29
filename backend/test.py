import json
import yfinance as yf

btc_info = yf.Ticker("BTC-USD").info
aapl_info = yf.Ticker("AAPL").info
btc = yf.Ticker("BTC-USD")
data = btc.history(period="1d")

print(f'json btc_info :::>>>>{json.dumps(btc_info, indent=2, ensure_ascii=False)}')
print(f'===========================================================================')
print(f'this is aapl_info:::::>>>>>>>>{json.dumps(aapl_info, indent=2, ensure_ascii=False)}')
