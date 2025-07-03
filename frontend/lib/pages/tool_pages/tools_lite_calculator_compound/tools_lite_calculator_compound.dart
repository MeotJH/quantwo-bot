import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/components/custom_button.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_calculator_compound/tools_lite_calculator_compound_result.dart';
import 'package:quant_bot/providers/tools_providers/compound_calculator_controller_provider.dart';
import 'package:quant_bot/providers/tools_providers/compound_calculator_notifier.dart';

class ToolsLiteCalculatorCompound extends ConsumerStatefulWidget {
  const ToolsLiteCalculatorCompound({super.key});

  @override
  ConsumerState<ToolsLiteCalculatorCompound> createState() =>
      _ToolsLiteCalculatorCompoundState();
}

class _ToolsLiteCalculatorCompoundState
    extends ConsumerState<ToolsLiteCalculatorCompound> {
  @override
  Widget build(BuildContext context) {
    final controllers = ref.watch(compoundCalculatorControllerProvider);
    final compoundCalculator = ref.watch(compoundCalculatorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('복리 계산기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textFieldWidget(
                '기초자금',
                hintText: 'EX) 100,000,000',
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.Comma, // 1,000,000 형식
                    mantissaLength: 0, // 소수점 자리수 (0이면 없음)
                    trailingSymbol: '원', // 또는 '$'
                  ),
                ],
                controller: controllers.initial,
              ),
              textFieldWidget(
                '투자금',
                hintText: 'EX) 10,000,000',
                isRequired: true,
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.Comma, // 1,000,000 형식
                    mantissaLength: 0, // 소수점 자리수 (0이면 없음)
                    trailingSymbol: '원', // 또는 '$'
                  ),
                ],
                controller: controllers.invest,
              ),
              textFieldWidget(
                '수익률',
                hintText: 'EX) 8%',
                isRequired: true,
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.Comma, // 1,000,000 형식
                    mantissaLength: 0, // 소수점 자리수 (0이면 없음)
                    trailingSymbol: '%', // 또는 '$'
                  ),
                ],
                controller: controllers.yields,
              ),
              textFieldWidget(
                '투자기간',
                hintText: 'EX) 10년',
                isRequired: true,
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.Comma, // 1,000,000 형식
                    mantissaLength: 0, // 소수점 자리수 (0이면 없음)
                    trailingSymbol: '년', // 또는 '$'
                  ),
                ],
                controller: controllers.year,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CustomButton(
                  onPressed: () async {
                    await compoundCalculator.calculate();
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                            insetPadding: EdgeInsets.zero, // 💡 여백 제거
                            backgroundColor: Colors.transparent,
                            child: ToolsLiteCalculatorCompoundResult(),
                          );
                        },
                      );
                    }
                  },
                  textColor: CustomColors.white,
                  backgroundColor: CustomColors.clearBlue120,
                  text: '결과보기',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
    String label, {
    String? hintText,
    bool? isRequired = false,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.black,
                ),
              ),
              if (isRequired == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    "*",
                    style: TextStyle(fontSize: 12, color: CustomColors.red100),
                  ),
                ),
            ],
          ),
          TextField(
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: CustomColors.gray40),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: CustomColors.black),
              ),
            ),
            controller: controller,
          ),
        ],
      ),
    );
  }
}
