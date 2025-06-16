import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/pages/tool_pages/tools_lite_calculator_compound_summary_card.dart';
import 'package:quant_bot_flutter/pages/tool_pages/tools_lite_calculator_compound_summary_line_chart.dart';
import 'package:quant_bot_flutter/providers/tools_providers/compound_calculator_notifier.dart';

class ToolsLiteCalculatorCompoundResult extends ConsumerStatefulWidget {
  const ToolsLiteCalculatorCompoundResult({super.key});

  @override
  ConsumerState<ToolsLiteCalculatorCompoundResult> createState() =>
      _ToolsLiteCalculatorCompoundResultState();
}

class _ToolsLiteCalculatorCompoundResultState
    extends ConsumerState<ToolsLiteCalculatorCompoundResult> {
  @override
  Widget build(BuildContext context) {
    final compoundRslt = ref.read(compoundCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('복리 계산기 결과',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ToolsLiteCalculatorCompoundSummaryCard(
                totalPrincipal: compoundRslt.totalPrincipal,
                totalInterest: compoundRslt.totalInterest,
                finalAsset: compoundRslt.finalAsset,
              ),
              ToolsLiteCalculatorCompoundSummaryLineChart(
                  data: compoundRslt.yearlyBreakdown),
            ],
          ),
        ),
      ),
    );
  }
}
