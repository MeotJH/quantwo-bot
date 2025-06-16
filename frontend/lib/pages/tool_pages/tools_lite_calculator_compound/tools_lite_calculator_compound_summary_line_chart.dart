import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/common/colors.dart';

import 'package:quant_bot_flutter/models/tools_model/compound_calculator_model/compound_result.dart';
import 'package:quant_bot_flutter/widgets/create_display_korean.dart';

class ToolsLiteCalculatorCompoundSummaryLineChart extends StatelessWidget {
  final List<CompoundAnnualResult> data;

  const ToolsLiteCalculatorCompoundSummaryLineChart(
      {super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final display = createDisplayKorean(length: 5, separator: ',', decimal: 2);

    if (data.isEmpty) return const SizedBox();

    final totalAsset =
        data.map((e) => FlSpot(e.year.toDouble(), e.totalAsset)).toList();

    final totalInvested =
        data.map((e) => FlSpot(e.year.toDouble(), e.totalInvested)).toList();

    final interestEarned =
        data.map((e) => FlSpot(e.year.toDouble(), e.interestEarned)).toList();
    final maxY = data.map((e) => e.totalAsset).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.all(12),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final index = touchedSpot.spotIndex;
                    final result = data[index];
                    final bar = touchedSpot.barIndex;

                    const textStyle = TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    );

                    switch (bar) {
                      case 0:
                        return LineTooltipItem(
                            '[${result.year}Y]자산: ${display(result.totalAsset)}원',
                            const TextStyle(color: Colors.white));
                      case 1:
                        return LineTooltipItem(
                            '[${result.year}Y] 납입: ${display(result.totalInvested)}원',
                            const TextStyle(color: Colors.white));
                      case 2:
                        return LineTooltipItem(
                            '[${result.year}Y] 수익: ${display(result.interestEarned)}원',
                            const TextStyle(color: Colors.white));
                      default:
                        return null;
                    }
                  }).toList();
                },
              ),
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: Colors.grey.shade400,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blueAccent,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  );
                }).toList();
              },
            ),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 30,
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  interval: (maxY / 5).toDouble(),
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: CustomColors.gray50, width: 2),
                bottom: BorderSide(color: CustomColors.gray50, width: 2),
                top: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
            minX: 1,
            maxX: data.length.toDouble(),
            minY: 0,
            maxY: maxY * 1.1,
            lineBarsData: [
              LineChartBarData(
                spots: totalAsset,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: totalInvested,
                isCurved: true,
                color: Colors.amber,
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: interestEarned,
                isCurved: true,
                color: Colors.deepOrangeAccent,
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
