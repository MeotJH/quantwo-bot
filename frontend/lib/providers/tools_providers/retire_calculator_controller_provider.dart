import 'package:quant_bot/models/tools_model/compound_calculator_model/retire_calculator_controller_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'retire_calculator_controller_provider.g.dart'; // 파일명에 맞게 변경

@riverpod
RetireCalculatorControllerModel retireCalculatorController(
    RetireCalculatorControllerRef ref) {
  final model = RetireCalculatorControllerModel();
  ref.onDispose(() => model.dispose());
  return model;
}
