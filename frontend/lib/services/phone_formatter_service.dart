import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    // Format based on the number of digits
    if (digitsOnly.length <= 3) {
      return newValue.copyWith(text: digitsOnly);
    } else if (digitsOnly.length <= 7) {
      final formattedText = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    } else if (digitsOnly.length <= 11) {
      final formattedText = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    return oldValue;
  }
}
