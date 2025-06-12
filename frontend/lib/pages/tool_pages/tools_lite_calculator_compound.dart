import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/common/colors.dart';

import 'package:quant_bot_flutter/components/line_chart.dart';

class CompoundYearlyResult {
  final int year; // 몇 년차인지
  final double principal; // 원금
  final double interest; // 누적 이자
  final double total; // 총 자산 (원금 + 이자)

  CompoundYearlyResult({
    required this.year,
    required this.principal,
    required this.interest,
    required this.total,
  });
}

class ToolsLiteCalculatorCompound extends StatefulWidget {
  const ToolsLiteCalculatorCompound({super.key});

  @override
  State<ToolsLiteCalculatorCompound> createState() =>
      _ToolsLiteCalculatorCompoundState();
}

class _ToolsLiteCalculatorCompoundState
    extends State<ToolsLiteCalculatorCompound> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();

  bool _showInputs = true;
  List<CompoundYearlyResult> _results = [];

  void _calculate() {
    final double principal = double.tryParse(_principalController.text) ?? 0;
    final double rate = double.tryParse(_rateController.text) ?? 0;
    final int years = int.tryParse(_yearsController.text) ?? 0;

    List<CompoundYearlyResult> results = [];
    for (int year = 1; year <= years; year++) {
      double total = principal * pow((1 + rate / 100), year);
      double interest = total - principal;
      results.add(CompoundYearlyResult(
        year: year,
        principal: principal,
        interest: interest,
        total: total,
      ));
    }

    setState(() {
      _results = results;
      _showInputs = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('복리계산기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('복리의 마법을 직접 체험해보세요.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _showInputs
                  ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(_principalController, '초기 투자금 (₩)'),
                          const SizedBox(height: 16),
                          _buildTextField(_rateController, '연 이자율 (%)'),
                          const SizedBox(height: 16),
                          _buildTextField(_yearsController, '기간 (년)'),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _calculate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.clearBlue100,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('계산하기',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 32),
            if (_results.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('최종 자산: ₩${_results.last.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                        '총 이자 수익: ₩${_results.last.interest.toStringAsFixed(0)}'),
                  ],
                ),
              ),
              Container(
                height: 260,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              Text('${value.toInt()}년'),
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: _results
                            .map((e) => FlSpot(e.year.toDouble(), e.total))
                            .toList(),
                        color: CustomColors.clearBlue100,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              Center(child: _buildResultTable(_results)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildResultTable(List<CompoundYearlyResult> results) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.white),
        dataRowColor: MaterialStateProperty.all(Colors.white),
        dividerThickness: 0.3,
        columns: const [
          DataColumn(label: Text('연도')),
          DataColumn(label: Text('원금')),
          DataColumn(label: Text('이자')),
          DataColumn(label: Text('총액')),
        ],
        rows: results
            .map(
              (e) => DataRow(cells: [
                DataCell(Text('${e.year}')),
                DataCell(Text('₩${e.principal.toStringAsFixed(0)}')),
                DataCell(Text('₩${e.interest.toStringAsFixed(0)}')),
                DataCell(Text('₩${e.total.toStringAsFixed(0)}')),
              ]),
            )
            .toList(),
      ),
    );
  }
}
