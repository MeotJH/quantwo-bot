import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/components/toggle_number_text.dart';
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
          _buildTableCell(recentStockOne.trailingPE),
          _buildTableCell(recentStockOne.trailingEps),
          _buildTableCell(recentStockOne.ebitda),
        ]),
        // 첫 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('전일종가'),
          _buildTableHeader('개장가'),
          _buildTableHeader('거래량'),
        ]),
        // 첫 번째 데이터 행
        TableRow(children: [
          _buildTableCell(recentStockOne.previousClose, prefix: '\$'),
          _buildTableCell(recentStockOne.open, prefix: '\$'),
          _buildTableCell(recentStockOne.volume),
        ]),
        // 두 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('최고가'),
          _buildTableHeader('최저가'),
          _buildTableHeader('시가총액'),
        ]),
        // 두 번째 데이터 행
        TableRow(children: [
          _buildTableCell(recentStockOne.dayHigh,
              color: CustomColors.joyOrange100, prefix: '\$'),
          _buildTableCell(recentStockOne.dayLow,
              color: CustomColors.clearBlue100, prefix: '\$'),
          _buildTableCell(recentStockOne.enterpriseValue, prefix: '\$'),
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
  Widget _buildTableCell(double? val,
      {Color? color, String? prefix, String? suffix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ToggleNumberText(
        value: val,
        prefix: prefix,
        suffix: suffix,
        color: color,
      ),
    );
  }
}
