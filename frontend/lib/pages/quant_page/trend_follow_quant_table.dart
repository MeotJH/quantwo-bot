import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quant_bot/components/custom_dialog.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/models/quant_model/quant_stock_model.dart';

class TrendFollowQuantTable extends StatefulWidget {
  final QuantStockModel recentStockOne;
  const TrendFollowQuantTable({super.key, required this.recentStockOne});

  @override
  State<TrendFollowQuantTable> createState() => _TrendFollowQuantTableState();
}

class _TrendFollowQuantTableState extends State<TrendFollowQuantTable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    ); // 애니메이션 반복

    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentStockOne = widget.recentStockOne;
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        // 첫 번째 행: 제목들
        TableRow(children: [
          _buildTableHeader('최근 추세역전가'),
          _buildTableHeader('전일 종가'),
          _buildTableHeader(_buildQuantHeaderCellData(recentStockOne)),
        ]),
        // 첫 번째 데이터 행
        TableRow(children: [
          _buildTableCell(
              '\$${(recentStockOne.lastCrossTrendFollow ?? 0.0).toStringAsFixed(2)}'),
          _buildTableCell('\$${recentStockOne.previousClose}'),
          //_buildAnimatedCell(),
          _buildTrendFollowCell(model: recentStockOne),
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

  String _buildQuantHeaderCellData(QuantStockModel model) {
    final previouseClose = (model.previousClose ?? 0.0);
    final lastCrossTrendFollow = (model.lastCrossTrendFollow ?? 0.0);
    final profit = previouseClose - lastCrossTrendFollow;
    return profit > 0 ? '예상 수익' : '예상 방어 손실';
  }

  Widget _buildTrendFollowCell({required QuantStockModel model}) {
    final previouseClose = (model.previousClose ?? 0.0);
    final lastCrossTrendFollow = (model.lastCrossTrendFollow ?? 0.0);
    final profit = previouseClose - lastCrossTrendFollow;
    final profitPercent = (profit / previouseClose) * 100;
    final color = profit > 0 ? CustomColors.error : CustomColors.clearBlue120;
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      )),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                '\$${profit.toStringAsFixed(2)} (${profitPercent.toStringAsFixed(2)}%)',
                style: TextStyle(
                    fontSize: 16, color: color, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  final words = profit > 0
                      ? ['매수', '예상 수익', '실현했을 것입니다.']
                      : ['매도', '예상 방어 손실', '잃지 않았을 것입니다.'];
                  showQuantBotDialog(
                      context: context,
                      title: words[1],
                      content:
                          '만약 알람 설정 후 ${words[0]} 시점에 ${words[0]} 했다면 ${words[1]}을 ${words[2]} ');
                },
                child: Icon(
                  CupertinoIcons.question_circle_fill,
                  size: 18,
                  color: CustomColors.brightYellow120,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
