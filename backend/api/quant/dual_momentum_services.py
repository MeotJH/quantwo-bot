
from datetime import datetime
from typing import List, Dict, Any

from api.quant.domain.services.dual_momentum import DualMomentumBacktest
from api import cache
from api.quant.domain.value_objects.model import RebalancingRecommendation

def run_dual_momentum_backtest(
    etf_symbols: List[str],
    duration: str,
    savings_rate: float
) -> Dict[str, Any]:
    """백테스트 실행을 위한 편의 함수"""
    backtest = DualMomentumBacktest(etf_symbols, duration, str(savings_rate))
    return backtest.run_backtest()

@cache.cached(timeout=86400, key_prefix="dual_momentum_intl")
def get_todays_dual_momentum(saved_symbol: str, etf_symbols: List[str], savings_rate: float = 3.0) -> RebalancingRecommendation:
    """
    매월 1일 리밸런싱 추천

    Args:
        saved_symbol: 현재 보유 중인 심볼
        etf_symbols: ETF 심볼 리스트 (예: ['SPY', 'FEZ', 'EWJ'])
        savings_rate: 현금 보유시 연간 수익률 (기본값 3.0%)

    Returns:
        RebalancingRecommendation: 리밸런싱 추천 정보를 담은 데이터 클래스
    """
    check_date = datetime.today()
    backtest = DualMomentumBacktest(etf_symbols=etf_symbols, duration="1", savings_rate=str(savings_rate))
    returns, _ = backtest._calculate_returns(check_date)
    cash_return = (float(savings_rate) / 100) * 0.5 * 100

    if all(returns <= cash_return):
        recommendation = 'cash'
        best_return = cash_return
    else:
        recommendation = returns.idxmax().lower()
        best_return = float(returns.max())

    should_rebalance = saved_symbol != recommendation
    return RebalancingRecommendation(
        date=check_date.strftime('%Y-%m-%d'),
        recommendation=recommendation,
        returns={symbol.lower(): float(returns[symbol]) for symbol in etf_symbols},
        best_return=best_return,
        cash_return=cash_return,
        should_rebalance=should_rebalance
    )

