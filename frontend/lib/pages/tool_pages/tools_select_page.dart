import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/providers/step_form_provider.dart';

class ToolsSelectPage extends ConsumerWidget {
  const ToolsSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도구 선택',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(stepFormProvider.notifier).reset();
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '어떤 도구를 사용하시나요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '퀀트투자에 도움되는 다양한 전략을 사용해보세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            _buildStrategyCard(
              context: context,
              title: 'Lite',
              description: '투자의 첫걸음을 위한, 가볍고 유용한 도구 모음입니다.',
              icon: Icons.shield_outlined,
              color: CustomColors.gray100,
              onTap: () {
                context.push('/tools/lite');
              },
            ),
            const SizedBox(height: 16),
            // TODO 후에 AI 분석기능 만든 후 주석 해제 예정
            // _buildStrategyCard(
            //   context: context,
            //   title: 'Pro',
            //   description: '정교한 AI 분석으로 깊이 있는 인사이트를 제공합니다.',
            //   icon: Icons.trending_up,
            //   color: CustomColors.gray100,
            //   onTap: () {
            //     //개발중입니다 toast
            //     CustomToast.show(message: '해당 기능은 준비중입니다.', isWarn: true);
            //     // ref
            //     //     .read(stepFormProvider.notifier)
            //     //     .setStrategy(StrategyType.aggressive);
            //     // context.push('/quant-form/quant');
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 32, color: color),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.gray50,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '선택하기',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
