import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_button.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';

class DualMomentuInternationalDescription extends StatelessWidget {
  const DualMomentuInternationalDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 색상
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '듀얼모멘텀 전략 설명',
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
                '듀얼모멘텀 전략이란?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '듀얼모멘텀은 상대 모멘텀과 절대 모멘텀을 결합한 투자 전략입니다. 상대 모멘텀은 여러 자산군 간의 성과를 비교해 가장 강한 자산에 투자하며, 절대 모멘텀은 선택된 자산의 과거 성과를 기준으로 상승세인지 판단하여 투자합니다.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),

              // 국제화 듀얼모멘텀
              const Text(
                '국제화 듀얼모멘텀 전략',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '국제화 듀얼모멘텀 전략은 미국 상장 지수 ETF를 이용하여 한국(EWY), 유럽(FEZ), 일본(EWJ), 미국(SPY) 4개 자산군의 상대적 성과를 비교하고, 가장 높은 모멘텀을 가진 자산을 선택합니다. 또한 선택된 자산이 절대 모멘텀(6개월 수익률 기준) 기준으로 상승세인 경우에만 투자합니다. 이 전략은 한 달에 한 번, 매월 말일에 리밸런싱하여 자산을 교체합니다.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),

              // 특징
              const Text(
                '듀얼모멘텀 전략의 특징',
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
                  '상대 모멘텀으로 가장 강한 자산에 집중 투자.',
                  '절대 모멘텀으로 하락장에서 손실을 최소화.',
                  '한 달에 한 번 자산을 리밸런싱하여 효율적인 포트폴리오 유지.',
                  '다양한 자산군에 분산 투자하여 리스크 관리 가능.',
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                title: '단점',
                details: [
                  '횡보장(변동성이 낮은 시장)에서는 성과가 제한될 수 있음.',
                  '성과가 과거 데이터에 의존하므로 갑작스러운 시장 변화에 취약.',
                  '한 달에 한 번 리밸런싱이 반드시 최적의 결과를 보장하지는 않음.',
                ],
              ),
              const SizedBox(height: 24),

              // 예시
              const Text(
                '듀얼모멘텀 전략의 구성 요소',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildExpansionTile(
                title: '상대 모멘텀 (Relative Momentum)',
                content:
                    '한국(EWY), 유럽(FEZ), 일본(EWJ), 미국(SPY)의 4개 ETF 중 지난 6개월간 가장 높은 성과를 보인 자산을 선택합니다.',
              ),
              _buildExpansionTile(
                title: '절대 모멘텀 (Absolute Momentum)',
                content:
                    '선택된 자산의 6개월 수익률이 양수일 경우에만 투자하며, 음수일 경우 안전 자산(현금)에 투자합니다.',
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
                '- 과거 데이터를 기반으로 하므로 미래 성과를 보장하지 않습니다.\n- 자산군 간 상관관계를 지속적으로 모니터링해야 합니다.\n- 리밸런싱 주기에 따른 비용(세금, 거래수수료)을 고려해야 합니다.',
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),

              // 마무리
              const Text(
                '듀얼모멘텀 전략에 대한 한 마디',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '"듀얼모멘텀은 상승장에서 수익을 극대화하고, 하락장에서 손실을 줄이는 데 효과적입니다. 하지만 리밸런싱 주기와 투자 비용을 고려한 신중한 접근이 필요합니다."',
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
                      context.go(RouteNotifier.dualMomentumInternationalPath);
                    },
                    textColor: CustomColors.white,
                    backgroundColor: CustomColors.clearBlue120,
                    text: '다음'),
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
