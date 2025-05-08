import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';

class QuantPageTable extends StatelessWidget {
  final QuantStockModel recentStockOne;
  const QuantPageTable({super.key, required this.recentStockOne});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(children: [
          _buildTableHeader('PER'),
          _buildTableHeader('EPS'),
          _buildTableHeader('EV/EBITDA'),
        ]),
        // 세 번째 데이터 행
        TableRow(children: [
          _buildTableCell(recentStockOne.trailingPE),
          _buildTableCell(recentStockOne.trailingEps),
          _buildTableCell(_getEvEbitda(recentStockOne).toStringAsFixed(2)),
        ]),
        // 첫 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('전일종가'),
          _buildTableHeader('개장가'),
          _buildTableHeader('거래량'),
        ]),
        // 첫 번째 데이터 행
        TableRow(children: [
          _buildTableCell('\$${recentStockOne.previousClose}'),
          _buildTableCell('\$${recentStockOne.open}'),
          _buildTableCell(recentStockOne.volume),
        ]),
        // 두 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('최고가'),
          _buildTableHeader('최저가'),
          _buildTableHeader('기업가치(EV)'),
        ]),
        // 두 번째 데이터 행
        TableRow(children: [
          _buildTableCell('\$${recentStockOne.dayHigh}',
              color: CustomColors.joyOrange100),
          _buildTableCell('\$${recentStockOne.dayLow}',
              color: CustomColors.clearBlue100),
          _buildTableCell('\$${recentStockOne.enterpriseValue}'),
        ]),
      ],
    );
  }

  double _getEvEbitda(QuantStockModel recentStockOne) {
    final enterpriseValue =
        double.tryParse(recentStockOne.enterpriseValue) ?? 0.0;
    final ebitda = double.tryParse(recentStockOne.ebitda) ?? 0.0;
    return enterpriseValue / ebitda;
  }

  // 테이블 헤더 스타일링 함수
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

  // 테이블 셀 스타일링 함수
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
