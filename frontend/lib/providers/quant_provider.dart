import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_model.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';
import 'package:quant_bot_flutter/models/trend_follow_model/trend_follow_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:quant_bot_flutter/providers/profile_provider.dart';
import 'package:quant_bot_flutter/services/stock_service.dart';
import 'package:quant_bot_flutter/services/trend_follow_service.dart';

//변수 받아서 get 요청하는 notifier 예제
final trendFollowProvider = AsyncNotifierProvider.autoDispose
    .family<TrendFollowNotifier, TrendFollowModel, String>(
  TrendFollowNotifier.new,
);

class TrendFollowNotifier
    extends AutoDisposeFamilyAsyncNotifier<TrendFollowModel, String> {
  late final StockService _stockService;
  @override
  Future<TrendFollowModel> build(String arg) async {
    final dio = ref.read(dioProvider);
    _stockService = StockService(ref.read(dioProvider));
    try {
      final response = await dio.get('/quants/trend_follow/$arg');

      if (response.statusCode != 200) {
        return TrendFollowModel(
            firstLineChart: [],
            secondLineChart: [],
            models: [],
            recentStockOne: QuantStockModel());
      }

      final List stockHistory = response.data['stock_history'];
      final Map<String, dynamic> stockInfo = response.data['stock_info'];

      List<QuantModel> models =
          stockHistory.map((e) => QuantModel.fromJson(stock: e)).toList();
      final QuantStockModel quantStockModel =
          QuantStockModel.fromJson(json: stockInfo);

      return TrendFollowService(models: models, recentStockOne: quantStockModel)
          .generateTrendFollows();
    } catch (e) {
      return TrendFollowModel(
          firstLineChart: [],
          secondLineChart: [],
          models: [],
          recentStockOne: QuantStockModel());
    }
  }

  Future<void> addStockToProfile(String ticker, String quantType,
      double initialPrice, double initialTrendFollow) async {
    try {
      await _stockService.addStockToProfile(
          ticker, quantType, initialPrice, initialTrendFollow);
      ref.invalidate(profileStocksProvider);
      // 상태 변경 없이 작업 완료
    } catch (e) {
      // 오류 처리, 하지만 상태 변경은 하지 않음
      print('주식 추가 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<void> toggleNotification(String ticker) async {
    try {
      await _stockService.toggleNotification(ticker);
    } catch (e) {
      print('알림 상태 변경 중 오류 발생: $e');
      rethrow;
    }
  }
}
