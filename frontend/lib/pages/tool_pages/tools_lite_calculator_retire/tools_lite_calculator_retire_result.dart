import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_calculator_retire/tools_lite_calculator_retire_card.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_calculator_retire/tools_lite_calculator_retire_table.dart';
import 'package:quant_bot/providers/tools_providers/retire_calculator_notifier.dart';

class ToolsLiteCalculatorRetireResult extends ConsumerStatefulWidget {
  const ToolsLiteCalculatorRetireResult({super.key});

  @override
  ConsumerState<ToolsLiteCalculatorRetireResult> createState() =>
      _ToolsLiteCalculatorRetireResultState();
}

class _ToolsLiteCalculatorRetireResultState
    extends ConsumerState<ToolsLiteCalculatorRetireResult> {
  @override
  Widget build(BuildContext context) {
    final retireResult = ref.watch(retireCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('은퇴자금 계산 결과',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ToolsLiteCalculatorRetireCard(result: retireResult),
                ToolsLiteCalculatorRetireTable(result: retireResult),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
