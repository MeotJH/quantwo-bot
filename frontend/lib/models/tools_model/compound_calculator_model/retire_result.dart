class RetireMonthlyPlan {
  final double expectedYields; // 예상 수익률 (%)
  final double requiredFund; // 해당 수익률일 때 필요한 은퇴 자금
  final double monthlySavingAmount; // 매달 저축해야 할 금액 (원)

  RetireMonthlyPlan({
    required this.expectedYields,
    required this.requiredFund,
    required this.monthlySavingAmount,
  });
}

class RetireSummaryResult {
  final double expense; // 은퇴 후 연간 지출액
  final double yields; // 기대 수익률 (%)
  final double inflation; // 물가상승률 (%)
  final int retireYear; // 은퇴까지 남은 연수

  final double requiredFund; // 필요 은퇴 자금 (원)
  final double monthlySavingAmount; // 매달 저축해야 할 금액 (원)

  final List<RetireMonthlyPlan> monthlyPlans; // 수익률 별 월 저축 금액

  RetireSummaryResult({
    required this.expense,
    required this.yields,
    required this.inflation,
    required this.retireYear,
    required this.requiredFund,
    required this.monthlySavingAmount,
    required this.monthlyPlans,
  });
}
