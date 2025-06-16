import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/components/tool_item_card.dart';
import 'package:quant_bot_flutter/constants/router_path_constants.dart';
import 'package:quant_bot_flutter/providers/step_form_provider.dart';

class ToolsLitePage extends ConsumerWidget {
  const ToolsLitePage({super.key});

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
              title: '복리계산기',
              description: '작은 투자도 시간이 지나면 큰 자산이 됩니다. 복리의 마법을 지금 계산해보세요.',
              icon: Icons.calculate_rounded,
              color: CustomColors.gray100,
              onTap: () {
                context.push(RouterPath.toolsLiteCompound);
              },
            ),
            const SizedBox(height: 16),
            ToolItemCard(
              context: context,
              title: '은퇴자금 계산기',
              description: '노후 준비를 시작하는 당신을 위한, 쉬운 은퇴자금 시뮬레이터입니다.',
              icon: Icons.calculate_outlined,
              color: CustomColors.gray100,
              onTap: () {
                context.push(RouterPath.toolsLiteRetire);
              },
            ),
          ],
        ),
      ),
    );
  }
}
