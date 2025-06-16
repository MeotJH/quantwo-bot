import 'package:flutter/material.dart';

extension CurrencyTextController on TextEditingController {
  int get numericValue {
    final cleaned = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  double get decimalValue {
    final cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}
