import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/common/colors.dart';

class QuantLineChart extends StatelessWidget {
  final List<Map<String, double>> firstChartData;
  final List<Map<String, double>> secondChartData;

  final List<Map<String, dynamic>> filteredData;
  final double minYValue;
  final double maxYValue;

  QuantLineChart({
    super.key,
    required this.firstChartData,
    required this.secondChartData,
  })  : filteredData =
            firstChartData.where((element) => element['y'] != null).toList(),
        minYValue = firstChartData
            .where((element) => element['y'] != null)
            .map((point) => point['y'] as double)
            .reduce(min),
        maxYValue = firstChartData
            .where((element) => element['y'] != null)
            .map((point) => point['y'] as double)
            .reduce(max);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipRoundedRadius: 3,
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = TextStyle(
                        color: touchedSpot.bar.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      return LineTooltipItem(
                        touchedSpot.y.toStringAsFixed(2),
                        textStyle,
                      );
                    }).toList();
                  },
                ),
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: CustomColors.gray40,
                        strokeWidth: 2,
                        dashArray: [5, 5],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 3,
                          color: CustomColors.gray80,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: firstChartData.map((element) {
                    return FlSpot(element['x'] ?? 0, element['y'] ?? 0);
                  }).toList(),
                  isCurved: true,
                  color: CustomColors.clearBlue120,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                  dotData: const FlDotData(
                    show: false,
                  ),
                ),
                LineChartBarData(
                  spots: secondChartData.map((element) {
                    return FlSpot(element['x'] ?? 0, element['y'] ?? 0);
                  }).toList(),
                  isCurved: true,
                  color: CustomColors.freshGreen100,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                  dotData: const FlDotData(
                    show: false,
                  ),
                ),
              ],
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: const FlGridData(show: false),
              maxY: maxYValue + 20,
              minY: minYValue - 20,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 2, // Thickness of the line
              width: 30, // Length of the line
              color: CustomColors.clearBlue120, // Color of the line
            ),
            const Text('종가'),
            const SizedBox(
              width: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 2, // Thickness of the line
              width: 30, // Length of the line
              color: CustomColors.freshGreen100, // Color of the line
            ),
            const Text('75일 추세이동선'),
          ],
        )
      ],
    );
  }
}
