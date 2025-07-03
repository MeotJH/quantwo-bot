import 'package:flutter/material.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/models/dual_momentum_international_model/dual_momentum_international_model.dart';

class DualMomentumInternationalTable extends StatelessWidget {
  final Summary summary;

  const DualMomentumInternationalTable({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(children: [
              _buildTableHeader('초기 투자금'),
              _buildTableHeader('최종 자산'),
              _buildTableHeader('듀얼모멘텀 수익률'),
            ]),
            TableRow(children: [
              _buildTableCell('\$${summary.initialCapital.toStringAsFixed(2)}'),
              _buildTableCell(
                '\$${summary.finalCapital.toStringAsFixed(2)}',
                color: summary.finalCapital > summary.initialCapital
                    ? CustomColors.error
                    : CustomColors.clearBlue100,
              ),
              _buildTableCell(
                '${summary.totalReturn.toStringAsFixed(2)}%',
                color: summary.totalReturn > 0
                    ? CustomColors.error
                    : CustomColors.clearBlue100,
              ),
            ]),
            TableRow(children: [
              _buildTableHeader('현금보유 수익률'),
              _buildTableHeader('코스피(EWY)  보유 수익률'),
              _buildTableHeader('한달 듀얼모멘텀 수익률'),
            ]),
            TableRow(children: [
              _buildTableCell(
                '${summary.cashHoldReturn.toStringAsFixed(2)}%',
              ),
              _buildTableCell(
                '${summary.ewyHoldReturn.toStringAsFixed(2)}%',
              ),
              _buildTableCell(
                '${summary.todayBestProfit.toStringAsFixed(2)}%',
              ),
            ]),
          ],
        ),
      );
    });
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: CustomColors.gray50,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildTableCell(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
