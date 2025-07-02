import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/providers/step_form_provider.dart';
import 'package:quant_bot/models/quant_strategy_model/quant_strategy_model.dart';

class QuantSelectPage extends ConsumerWidget {
  const QuantSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(stepFormProvider);

    if (formData.strategy == null) {
      return const Scaffold(
        body: Center(child: Text('전략을 선택해주세요')),
      );
    }

    final strategies =
        QuantStrategyModel.getStrategiesByType(formData.strategy!);

    return Scaffold(
      appBar: AppBar(
        title: Text('${formData.strategy!.name} 전략 선택',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: strategies.length,
        itemBuilder: (context, index) {
          final strategy = strategies[index];
          return _buildQuantCard(
            context: context,
            strategy: strategy,
            onTap: () {
              ref.read(stepFormProvider.notifier).setQuantType(strategy.type);
              context.push(strategy.route);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuantCard({
    required BuildContext context,
    required QuantStrategyModel strategy,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                    Icon(strategy.icon, size: 32, color: CustomColors.gray100),
                    const SizedBox(width: 12),
                    Text(
                      strategy.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  strategy.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.gray50,
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '예상 수익률',
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.gray50,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strategy.profitDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '리스크',
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.gray50,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strategy.riskDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
