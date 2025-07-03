import 'package:flutter/material.dart';
import 'package:quant_bot/components/toggle_number_text.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/constants/currency_type_enu.dart';
import 'package:quant_bot/models/tools_model/compound_calculator_model/compound_result.dart';

class ToolsLiteCalculatorCompoundTable extends StatelessWidget {
  final List<CompoundAnnualResult> data;

  const ToolsLiteCalculatorCompoundTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.2),
      },
      children: [
        TableRow(children: [
          _buildHeader('연도'),
          _buildHeader('총 투자액'),
          _buildHeader('이자 수익'),
          _buildHeader('총 자산'),
        ]),
        ...data.map((item) => TableRow(children: [
              _buildCell(item.year.toString()),
              _buildNumberCell(item.totalInvested, suffix: '원'),
              _buildNumberCell(item.interestEarned, suffix: '원'),
              _buildNumberCell(item.totalAsset, suffix: '원'),
            ])),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: CustomColors.gray50,
        ),
      ),
    );
  }

  Widget _buildCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildNumberCell(double value, {String? suffix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ToggleNumberText(
        value: value,
        suffix: suffix,
        displayLength: 5,
        currencyType: CurrencyType.KOR,
      ),
    );
  }
}
