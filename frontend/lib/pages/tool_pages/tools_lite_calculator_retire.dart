import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/components/tool_item_card.dart';
import 'package:quant_bot_flutter/constants/router_path_constants.dart';
import 'package:quant_bot_flutter/providers/step_form_provider.dart';

class ToolsLiteCalculatorRetire extends ConsumerWidget {
  const ToolsLiteCalculatorRetire({super.key});

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
            const SizedBox(height: 32),
            ToolItemCard(
              context: context,
              title: 'Lite',
              description: '투자의 첫걸음을 위한, 가볍고 유용한 도구 모음입니다.',
              icon: Icons.calculate_outlined,
              color: CustomColors.gray100,
              onTap: () {
                context.push(RouterPath.toolsLite);
              },
            ),
            const SizedBox(height: 16),
            ToolItemCard(
              context: context,
              title: 'Pro',
              description: '정교한 AI 분석으로 깊이 있는 인사이트를 제공합니다.',
              icon: Icons.trending_up,
              color: CustomColors.gray100,
              onTap: () {
                context.push('/tools/lite');
              },
            ),
          ],
        ),
      ),
    );
  }
}
