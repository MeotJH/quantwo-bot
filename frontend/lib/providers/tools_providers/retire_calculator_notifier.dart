// 계산 Notifier
import 'dart:developer';
import 'dart:math';

import 'package:quant_bot/components/custom_toast.dart';
import 'package:quant_bot/models/tools_model/compound_calculator_model/retire_result.dart';
import 'package:quant_bot/providers/tools_providers/retire_calculator_controller_provider.dart';
import 'package:quant_bot/widgets/currency_text_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'retire_calculator_notifier.g.dart';

@riverpod
class RetireCalculator extends _$RetireCalculator {
  @override
  RetireSummaryResult build() {
    // 초기 상태
    return RetireSummaryResult(
      expense: 0,
      yields: 0.00,
      inflation: 0.00,
      retireYear: 0,
      requiredFund: 0,
      monthlySavingAmount: 0.0,
      monthlyPlans: [],
    );
  }

  Future<void> calculate() async {
    final model = ref.read(retireCalculatorControllerProvider);

    final double expense = model.expense.decimalValue;
    final double yields = model.yields.decimalValue / 100;
    final double inflation = model.inflation.decimalValue / 100;
    final int retireYear = model.retireYear.numericValue;

    if (yields <= inflation) {
      CustomToast.show(message: '기대 수익률은 물가상승률보다 커야 합니다.', isWarn: true);
      throw Exception('기대 수익률은 물가상승률보다 커야 합니다.');
    }

    final double inflatedSpending = expense * pow((1 + inflation), retireYear);

    // 기준 수익률로 은퇴자금 계산 (기준 카드에 표시)
    final double defaultRequiredFund = inflatedSpending / (yields - inflation);

    final List<double> assumedYields =
        List.generate(5, (i) => yields + (2 - i) * 0.01);

    final List<RetireMonthlyPlan> monthlyPlans = [];

    final double monthlySavingAmount = defaultRequiredFund *
        (yields / 12) /
        (pow(1 + (yields / 12), retireYear * 12) - 1);

    for (final assumed in assumedYields) {
      final int months = retireYear * 12;
      final double r = assumed / 12;

      // 시나리오 별 은퇴자금 계산
      final double fund = inflatedSpending / (assumed - inflation);
      final double monthlySaving = fund * r / (pow(1 + r, months) - 1);

      monthlyPlans.add(
        RetireMonthlyPlan(
          expectedYields: assumed,
          requiredFund: fund,
          monthlySavingAmount: monthlySaving,
        ),
      );
    }

    state = RetireSummaryResult(
      expense: expense,
      yields: yields,
      inflation: inflation,
      retireYear: retireYear,
      requiredFund: defaultRequiredFund,
      monthlySavingAmount: monthlySavingAmount,
      monthlyPlans: monthlyPlans,
    );
  }
}
