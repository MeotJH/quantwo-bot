// 계산 Notifier
import 'dart:developer';

import 'package:quant_bot/models/tools_model/compound_calculator_model/compound_result.dart';
import 'package:quant_bot/providers/tools_providers/compound_calculator_controller_provider.dart';
import 'package:quant_bot/widgets/currency_text_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compound_calculator_notifier.g.dart';

@riverpod
class CompoundCalculator extends _$CompoundCalculator {
  @override
  CompoundSummaryResult build() {
    // 초기 상태
    return CompoundSummaryResult(
      initialInvestment: 0,
      yearlyInvestment: 0,
      annualYield: 0,
      durationYears: 0,
      totalPrincipal: 0,
      totalInterest: 0,
      finalAsset: 0,
      yearlyBreakdown: const [],
    );
  }

  Future<void> calculate() async {
    final model = ref.read(compoundCalculatorControllerProvider);

    final double initial = model.initial.decimalValue;
    final double invest = model.invest.decimalValue;
    final double yields = model.yields.decimalValue;
    final int year = model.year.numericValue;

    double asset = initial;
    final List<CompoundAnnualResult> breakdown = [];

    for (int i = 1; i <= year; i++) {
      final tempYear = i;
      asset = (asset + invest) * (1 + yields / 100);
      final invested = initial + invest * tempYear;
      final interest = asset - invested;

      breakdown.add(
        CompoundAnnualResult(
          year: tempYear,
          totalInvested: invested,
          interestEarned: interest,
          totalAsset: asset,
        ),
      );
    }

    final totalPrincipal = initial + invest * year;
    final totalInterest = asset - totalPrincipal;

    state = CompoundSummaryResult(
      initialInvestment: initial,
      yearlyInvestment: invest,
      annualYield: yields,
      durationYears: year,
      totalPrincipal: totalPrincipal,
      totalInterest: totalInterest,
      finalAsset: asset,
      yearlyBreakdown: breakdown,
    );
  }
}
