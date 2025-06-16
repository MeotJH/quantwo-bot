class CompoundAnnualResult {
  final int year;
  final double totalInvested;
  final double interestEarned;
  final double totalAsset;

  CompoundAnnualResult({
    required this.year,
    required this.totalInvested,
    required this.interestEarned,
    required this.totalAsset,
  });
}

class CompoundSummaryResult {
  final double initialInvestment;
  final double yearlyInvestment;
  final double annualYield;
  final int durationYears;

  final double totalPrincipal; // 총 납입금
  final double totalInterest; // 총 수익
  final double finalAsset; // 최종 자산

  final List<CompoundAnnualResult> yearlyBreakdown;

  CompoundSummaryResult({
    required this.initialInvestment,
    required this.yearlyInvestment,
    required this.annualYield,
    required this.durationYears,
    required this.totalPrincipal,
    required this.totalInterest,
    required this.finalAsset,
    required this.yearlyBreakdown,
  });
}
