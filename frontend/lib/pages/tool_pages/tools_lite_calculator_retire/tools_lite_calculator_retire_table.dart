import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quant_bot_flutter/models/tools_model/compound_calculator_model/retire_result.dart';
import 'package:quant_bot_flutter/widgets/create_display_korean.dart';

class ToolsLiteCalculatorRetireTable extends StatelessWidget {
  final RetireSummaryResult result;

  const ToolsLiteCalculatorRetireTable({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month_outlined, size: 20),
              SizedBox(width: 4),
              Text(
                '월 저축 계획 (수익률 시나리오)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              _buildHeaderRow(),
              ...result.monthlyPlans.map(
                (plan) => _buildDataRow(
                  plan.expectedYields,
                  plan.requiredFund,
                  plan.monthlySavingAmount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('기대 수익률', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('필요 은퇴 자금', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('월 저축 필요액', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ]);
  }

  TableRow _buildDataRow(double rate, double fund, double saving) {
    final formatter = NumberFormat('#,###');
    final display = createDisplayKorean(length: 5, decimal: 2, separator: ',');
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('${(rate * 100).toStringAsFixed(1)}%'),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('${display(fund)}원'),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('${formatter.format(saving)}원'),
      ),
    ]);
  }
}
