import 'package:flutter/material.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/models/trend_follow_model/trend_follow_list_model.dart';

class TrendFollowScoreDetailBottomSheet extends StatelessWidget {
  final TrendFollowListModel stock;

  const TrendFollowScoreDetailBottomSheet({
    super.key,
    required this.stock,
  });

  Map<String, double> _parseReasons(List<String> reasons) {
    Map<String, double> parsed = {
      'liquidityScore': 0.0,
      'sectorWeight': 0.0,
      'volPenalty': 0.0,
      'ipoPenalty': 0.0,
    };

    for (String reason in reasons) {
      if (reason.startsWith('LiquidityScore=')) {
        parsed['liquidityScore'] = double.tryParse(reason.split('=')[1]) ?? 0.0;
      } else if (reason.startsWith('SectorWeight=')) {
        parsed['sectorWeight'] = double.tryParse(reason.split('=')[1]) ?? 0.0;
      } else if (reason.startsWith('VolPenalty=')) {
        parsed['volPenalty'] = double.tryParse(reason.split('=')[1]) ?? 0.0;
      } else if (reason.startsWith('IPOPenalty=')) {
        parsed['ipoPenalty'] = double.tryParse(reason.split('=')[1]) ?? 0.0;
      }
    }

    return parsed;
  }

  String _getBucketEmoji(String bucket) {
    if (bucket.startsWith('A.')) return '🏆';
    if (bucket.startsWith('B.')) return '⭐';
    if (bucket.startsWith('C.')) return '⚠️';
    return '❌';
  }

  Color _getBucketColor(String bucket) {
    if (bucket.startsWith('A.')) return const Color(0xFF4CAF50);
    if (bucket.startsWith('B.')) return const Color(0xFF2196F3);
    if (bucket.startsWith('C.')) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    final reasonsData = _parseReasons(stock.reasons);
    final liquidityContribution = 0.6 * reasonsData['liquidityScore']!;
    final sectorContribution = 2.0 * reasonsData['sectorWeight']!;
    final volPenaltyContribution = 1.5 * reasonsData['volPenalty']!;
    final ipoPenaltyContribution = 1.0 * reasonsData['ipoPenalty']!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.ticker,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Text(
                    stock.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.gray50,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 설명
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ℹ️',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '이 점수는 추세추종 전략에 적합한 종목인지를 나타냅니다.\n지금 당장 매수해야 한다는 의미가 아닙니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.gray50,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 최종 점수
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📊 최종 점수',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stock.score.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 등급
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getBucketColor(stock.bucket).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBucketColor(stock.bucket).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  _getBucketEmoji(stock.bucket),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    stock.bucket,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getBucketColor(stock.bucket),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 점수 구성
          const Text(
            '📈 점수 구성',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _buildScoreItem(
            '유동성',
            reasonsData['liquidityScore']!,
            liquidityContribution,
            '0.6배',
            true,
          ),
          _buildScoreItem(
            '섹터 가중치',
            reasonsData['sectorWeight']!,
            sectorContribution,
            '2.0배',
            true,
          ),
          _buildScoreItem(
            '변동성 페널티',
            reasonsData['volPenalty']!,
            volPenaltyContribution,
            '1.5배',
            false,
          ),
          _buildScoreItem(
            'IPO 페널티',
            reasonsData['ipoPenalty']!,
            ipoPenaltyContribution,
            '1.0배',
            false,
          ),

          const SizedBox(height: 24),

          // 계산식
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📐 계산식',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '(0.6 × 유동성) + (2.0 × 섹터)\n- (1.5 × 변동성) - (1.0 × IPO)',
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.gray50,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(
    String label,
    double baseValue,
    double contribution,
    String multiplier,
    bool isPositive,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            isPositive ? '✅' : '⚠️',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF222222),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${baseValue.toStringAsFixed(2)} × $multiplier',
                style: TextStyle(
                  fontSize: 12,
                  color: CustomColors.gray50,
                ),
              ),
              Text(
                '${isPositive ? '+' : '-'}${contribution.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPositive
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFFF9800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
