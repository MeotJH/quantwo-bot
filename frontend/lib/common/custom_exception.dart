import 'package:quant_bot/components/custom_toast.dart';

class CustomException implements Exception {
  final String message;
  CustomException(this.message);

  @override
  String toString() => message;

  void showToastMessage() => CustomToast.show(message: message, isWarn: true);
}
