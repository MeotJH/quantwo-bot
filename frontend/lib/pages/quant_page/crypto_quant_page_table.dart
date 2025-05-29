import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';

class CryptoQuantPageTable extends StatelessWidget {
  final QuantStockModel recentStockOne;
  const CryptoQuantPageTable({super.key, required this.recentStockOne});

  String formatSmart(double value) {
    if (value % 1 == 0) {
      // 정수라면 소수점 없이
      return NumberFormat('#,###').format(value);
    } else {
      // 소수점이 있다면 둘째 자리까지
      return NumberFormat('#,###.##').format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###.00');
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(children: [
          _buildTableHeader('변동률 (24h)'),
          _buildTableHeader('순환공급량'),
          _buildTableHeader('24시간 거래량'),
        ]),
        // 세 번째 데이터 행
        TableRow(children: [
          _buildTableCell(
            '${(recentStockOne.trailingPE ?? 0.0).toStringAsFixed(2)}%',
          ),
          _buildTableCell(
              '\$${formatSmart(recentStockOne.trailingEps ?? 0.0)}'),
          _buildTableCell('\$${formatSmart(recentStockOne.ebitda ?? 0.0)}'),
        ]),
        // 첫 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('전일종가'),
          _buildTableHeader('개장가'),
          _buildTableHeader('거래량'),
        ]),
        // 첫 번째 데이터 행
        TableRow(children: [
          _buildTableCell(
              '\$${(formatSmart(recentStockOne.previousClose ?? 0.0))}'),
          _buildTableCell('\$${formatSmart(recentStockOne.open ?? 0.0)}'),
          _buildTableCell('\$${formatSmart(recentStockOne.volume ?? 0.0)}'),
        ]),
        // 두 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('최고가'),
          _buildTableHeader('최저가'),
          _buildTableHeader('시가총액'),
        ]),
        // 두 번째 데이터 행
        TableRow(children: [
          _buildTableCell('\$${formatSmart(recentStockOne.dayHigh ?? 00)}',
              color: CustomColors.joyOrange100),
          _buildTableCell('\$${formatSmart(recentStockOne.dayLow ?? 00)}',
              color: CustomColors.clearBlue100),
          _buildTableCell(
              '\$${formatSmart(recentStockOne.enterpriseValue ?? 00)}'),
        ]),
      ],
    );
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
