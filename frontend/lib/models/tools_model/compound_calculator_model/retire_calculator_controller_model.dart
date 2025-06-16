import 'package:flutter/material.dart';

class RetireCalculatorControllerModel {
  final TextEditingController expense = TextEditingController();
  final TextEditingController yields = TextEditingController();
  final TextEditingController inflation = TextEditingController();
  final TextEditingController retireYear = TextEditingController();

  void dispose() {
    expense.dispose();
    yields.dispose();
    inflation.dispose();
    retireYear.dispose();
  }
}
