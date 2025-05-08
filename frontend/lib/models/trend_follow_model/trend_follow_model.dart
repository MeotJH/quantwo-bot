import 'package:quant_bot_flutter/models/quant_model/quant_model.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';

class TrendFollowModel {
  final List<Map<String, double>> firstLineChart;
  final List<Map<String, double>> secondLineChart;
  final List<QuantModel> models;
  final QuantStockModel recentStockOne;
  TrendFollowModel(
      {required this.firstLineChart,
      required this.secondLineChart,
      required this.models,
      required this.recentStockOne});
}
