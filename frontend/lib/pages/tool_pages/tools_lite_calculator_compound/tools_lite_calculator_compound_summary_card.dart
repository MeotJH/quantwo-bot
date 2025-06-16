import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToolsLiteCalculatorCompoundSummaryCard extends StatelessWidget {
  final double totalPrincipal;
  final double totalInterest;
  final double finalAsset;

  const ToolsLiteCalculatorCompoundSummaryCard({
    super.key,
    required this.totalPrincipal,
    required this.totalInterest,
    required this.finalAsset,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    final rate =
        totalPrincipal == 0 ? 0 : (totalInterest / totalPrincipal * 100);

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('총 납입금', '${formatter.format(totalPrincipal)}원'),
            const SizedBox(height: 8),
            _buildRow('총 수익', '${formatter.format(totalInterest)}원'),
            const SizedBox(height: 8),
            _buildRow('최종 자산', '${formatter.format(finalAsset)}원'),
            const Divider(height: 24),
            _buildRow(
              '수익률',
              '${rate >= 0 ? '+' : ''}${rate.toStringAsFixed(1)}%',
              valueColor: rate >= 0 ? Colors.red : Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
