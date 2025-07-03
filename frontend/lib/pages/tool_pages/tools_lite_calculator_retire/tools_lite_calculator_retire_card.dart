import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quant_bot/models/tools_model/compound_calculator_model/retire_result.dart';

class ToolsLiteCalculatorRetireCard extends StatelessWidget {
  final RetireSummaryResult result;

  const ToolsLiteCalculatorRetireCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    final selectedPlan = result.monthlyPlans.firstWhere(
      (plan) => plan.expectedYields == result.yields,
      orElse: () => result.monthlyPlans.first,
    );

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('은퇴 후 연 지출액', '${formatter.format(result.expense)}원'),
            const SizedBox(height: 8),
            _buildRow('기대 수익률', '${(result.yields * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            _buildRow(
                '물가상승률', '${(result.inflation * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            _buildRow('남은 기간', '${result.retireYear}년'),
            const Divider(height: 24),
            _buildRow(
              '필요 은퇴 자금',
              '${formatter.format(result.requiredFund)}원',
              valueColor: Colors.blueAccent,
            ),
            const SizedBox(height: 8),
            _buildRow(
              '월 저축 필요액',
              '${formatter.format(selectedPlan.monthlySavingAmount)}원',
              valueColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
