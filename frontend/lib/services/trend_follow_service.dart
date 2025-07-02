import 'package:quant_bot/models/quant_model/quant_model.dart';
import 'package:quant_bot/models/quant_model/quant_stock_model.dart';
import 'package:quant_bot/models/trend_follow_model/trend_follow_model.dart';

class TrendFollowService {
  final List<QuantModel> models;
  final QuantStockModel recentStockOne;
  const TrendFollowService(
      {required this.models, required this.recentStockOne});

  TrendFollowModel generateTrendFollows() {
    final fistChartData = models.reversed
        .toList()
        .asMap()
        .map((index, entry) => MapEntry(
            index, {'x': index.toDouble(), 'y': double.parse(entry.close)}))
        .values
        .toList();

    final secondChartData = models.reversed
        .toList()
        .asMap()
        .map((index, entry) => MapEntry(index, {
              'x': index.toDouble(),
              'y': double.tryParse(entry.trendFollow) ?? 0.0
            }))
        .values
        .toList();
    return TrendFollowModel(
        firstLineChart: fistChartData,
        secondLineChart: secondChartData,
        models: models,
        recentStockOne: recentStockOne);
  }
}
