import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot/components/custom_button.dart';
import 'package:quant_bot/common/colors.dart';

class TrendFollowDescription extends StatelessWidget {
  const TrendFollowDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 색상
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '추세추종 전략 설명',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              const Text(
                '추세추종 전략이란?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '추세추종 전략은 주식이나 자산의 가격이 상승하거나 하락하는 추세를 따라 투자하는 방법입니다. 오르는 자산은 더 오를 거라 믿고 매수하며, 내리는 자산은 매도합니다.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),

              // 특징
              const Text(
                '추세추종 전략의 특징',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                title: '장점',
                details: [
                  '큰 상승장에서 높은 수익을 기대할 수 있습니다.',
                  '시장의 방향성을 잘 타면 효율적인 수익 창출이 가능',
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                title: '단점',
                details: [
                  '횡보장에서는 손실 가능성이 커질 수 있습니다.',
                  '진입/이탈 시점이 늦으면 손실이 발생',
                ],
              ),
              const SizedBox(height: 24),

              // 예시
              const Text(
                '추세추종 전략의 예시',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildExpansionTile(
                title: '이동평균선 (Moving Average)',
                content: '단기 이동평균선이 장기 이동평균선을 돌파할 때 매수하고, 반대일 때 매도하는 방식입니다.',
              ),
              _buildExpansionTile(
                title: '모멘텀 지표 활용',
                content: '특정 기간 동안의 수익률이 양수인 자산에 투자하거나, 하락세에 있는 자산은 매도합니다.',
              ),
              const SizedBox(height: 24),

              // 주의사항
              const Text(
                '주의할 점',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '- 손절매 기준을 설정해 추세 반전 시 손실을 줄이세요.\n- 시장의 큰 전환이 올 때 빠르게 대응할 준비를 하세요.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),

              // 마무리
              const Text(
                '추세추종 전략에 대한 한 마디',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '"시장의 흐름에 올라타는 것은 수익 창출의 기본입니다. 하지만 꾸준한 관찰과 데이터 분석이 성공의 열쇠입니다."',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 버튼
              Center(
                child: CustomButton(
                    onPressed: () {
                      context.go('/quant-form/quant/trend-follow');
                    },
                    textColor: CustomColors.white,
                    backgroundColor: CustomColors.clearBlue120,
                    text: '주식 선택하기'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<String> details}) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...details.map((detail) => Text(
                  '- $detail',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 상하 여백 추가
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // 배경색 추가
          borderRadius: BorderRadius.circular(12), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4), // 부드러운 그림자
            ),
          ],
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            iconColor: Colors.black54, // 아이콘 색상
            collapsedIconColor: Colors.black54,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5, // 줄 간격
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
