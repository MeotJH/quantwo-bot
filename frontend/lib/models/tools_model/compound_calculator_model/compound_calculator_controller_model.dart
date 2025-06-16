import 'package:flutter/material.dart';

class CompoundCalculatorControllerModel {
  final TextEditingController initial = TextEditingController();
  final TextEditingController invest = TextEditingController();
  final TextEditingController yields = TextEditingController();
  final TextEditingController year = TextEditingController();

  void dispose() {
    initial.dispose();
    invest.dispose();
    yields.dispose();
    year.dispose();
  }
}
