import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quant_bot_flutter/common/colors.dart';

class DualMomenTumLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> firstChartData;
  final List<Map<String, dynamic>> secondChartData;
  final List<Map<String, dynamic>> thirdChartData;
  final List<String> legendLabels;
  final bool showTooltip;

  const DualMomenTumLineChart({
    required this.firstChartData,
    required this.secondChartData,
    required this.thirdChartData,
    required this.legendLabels,
    this.showTooltip = false,
    super.key,
  });

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
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(12),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final data = touchedSpot.barIndex == 0
                          ? firstChartData[touchedSpot.spotIndex]
                          : touchedSpot.barIndex == 1
                              ? secondChartData[touchedSpot.spotIndex]
                              : thirdChartData[touchedSpot.spotIndex];

                      const textStyle = TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      );

                      return LineTooltipItem(
                        '${data['date']}\n\$${data['y'].toStringAsFixed(2)}',
                        textStyle,
                        children: [
                          TextSpan(
                            text: '\n${legendLabels[touchedSpot.barIndex]}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
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
                _createLineChartBarData(firstChartData, CustomColors.error),
                _createLineChartBarData(
                    secondChartData, CustomColors.clearBlue100),
                _createLineChartBarData(thirdChartData, Colors.grey),
              ],
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  color: CustomColors.clearBlue120,
                  label: '국제 전략 퀀트 수익률',
                ),
                const SizedBox(width: 10),
                _buildLegendItem(
                  color: CustomColors.clearBlue120,
                  label: '현금 보유',
                ),
                const SizedBox(width: 10),
                _buildLegendItem(
                  color: CustomColors.gray50,
                  label: '코스피(EWJ) 보유',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _createLineChartBarData(
      List<Map<String, dynamic>> data, Color color) {
    return LineChartBarData(
      spots: data
          .map((item) => FlSpot(item['x'] as double, item['y'] as double))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 2,
          width: 30,
          color: color,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
