import 'package:quant_bot_flutter/models/tools_model/compound_calculator_model/compound_calculator_controller_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compound_calculator_controller_provider.g.dart'; // 파일명에 맞게 변경

@riverpod
CompoundCalculatorControllerModel compoundCalculatorController(
    CompoundCalculatorControllerRef ref) {
  final model = CompoundCalculatorControllerModel();
  ref.onDispose(() => model.dispose());
  return model;
}
