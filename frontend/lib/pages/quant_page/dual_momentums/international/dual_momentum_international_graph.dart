import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/models/dual_momentum_international_model/dual_momentum_international_model.dart';
import 'package:quant_bot_flutter/widgets/quant_line_chart.dart';

class DualMomentumInternationalGraph extends StatelessWidget {
  final DualMomentumInternationalModel data; // 실제 데이터 타입에 맞게 수정 필요
  final VoidCallback onTap;
  final List<String> etfSymbols;
  const DualMomentumInternationalGraph({
    super.key,
    required this.data,
    required this.onTap,
    required this.etfSymbols,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      etfSymbols.join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      '| \$10,000 달러를 10년간',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '\$${data.summary.finalCapital.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '\$${(data.summary.finalCapital - data.summary.initialCapital).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: data.summary.totalReturn > 0
                          ? CustomColors.error
                          : CustomColors.clearBlue100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${data.summary.totalReturn.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      fontSize: 14,
                      color: data.summary.totalReturn > 0
                          ? CustomColors.error
                          : CustomColors.clearBlue100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ' 현재포지션 🎯 ${data.summary.finalBestEtf.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: DualMomenTumLineChart(
            firstChartData: data.data
                .map((record) => {
                      'x': record.date.millisecondsSinceEpoch.toDouble(),
                      'y': record.capital,
                      'date': record.date.toString().substring(0, 10),
                    })
                .toList(),
            secondChartData: data.data
                .map((record) => {
                      'x': record.date.millisecondsSinceEpoch.toDouble(),
                      'y': record.cashHold,
                      'date': record.date.toString().substring(0, 10),
                    })
                .toList(),
            thirdChartData: data.data
                .map((record) => {
                      'x': record.date.millisecondsSinceEpoch.toDouble(),
                      'y': record.ewyHold,
                      'date': record.date.toString().substring(0, 10),
                    })
                .toList(),
            legendLabels: const ['국제 전략 퀀트 수익률', '현금 보유', '코스피(EWJ) 보유'],
            showTooltip: true,
          ),
        ),
      ],
    );
  }
}
