import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/models/trend_follow_model/trend_follow_list_model.dart';
import 'package:quant_bot/providers/dio_provider.dart';

final trendFollowProvider = AsyncNotifierProvider.autoDispose<StocksNotifier,
    List<TrendFollowListModel>>(StocksNotifier.new);

class StocksNotifier
    extends AutoDisposeAsyncNotifier<List<TrendFollowListModel>> {
  late List<TrendFollowListModel> firstFetchStocks = [];

  @override
  Future<List<TrendFollowListModel>> build() async {
    ref.keepAlive(); // ✅ 데이터가 자동 삭제되지 않도록 유지
    return fetchStocks();
  }

  // Fetch stocks from API
  Future<List<TrendFollowListModel>> fetchStocks() async {
    try {
      final dio = ref.read(dioProvider);

      final response = await dio.get('/quants/trend-follows');

      if (response.statusCode != 200) {
        return [];
      }

      final List<dynamic> stocksJson = response.data as List<dynamic>;
      final List<TrendFollowListModel> stocks = stocksJson.map((stock) {
        return TrendFollowListModel.fromJson(stock);
      }).toList();
      firstFetchStocks = stocks;
      return stocks;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // You can optionally add methods to refresh or modify the state
  Future<void> refreshStocks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchStocks());
  }

  Future<void> searchStocks({required String query}) async {
    if (query.isEmpty) {
      state = AsyncValue.data(firstFetchStocks);
      return;
    }

    final lowerQuery = query.toLowerCase();

    //model 의 ticker와 name이 같은게 있으면 return
    final List<TrendFollowListModel> searchedStocks =
        firstFetchStocks.where((stock) {
      final tickerMatch = stock.ticker.toLowerCase().contains(lowerQuery);
      final nameMatch = stock.name.toLowerCase().contains(lowerQuery);
      return tickerMatch || nameMatch;
    }).toList();

    state = AsyncValue.data(searchedStocks);
  }
}
