import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/stock_model/stock_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';

final stocksProvider =
    AsyncNotifierProvider.autoDispose<StocksNotifier, List<StockModel>>(
        StocksNotifier.new);

class StocksNotifier extends AutoDisposeAsyncNotifier<List<StockModel>> {
  late List<StockModel> firstFetchStocks = [];

  @override
  Future<List<StockModel>> build() async {
    ref.keepAlive(); // ✅ 데이터가 자동 삭제되지 않도록 유지
    return fetchStocks();
  }

  // Fetch stocks from API
  Future<List<StockModel>> fetchStocks() async {
    try {
      final dio = ref.read(dioProvider);

      final response = await dio.get('/stocks');

      if (response.statusCode != 200) {
        return [];
      }

      final List<dynamic> stocksJson = response.data['stocks'] as List<dynamic>;
      final List<StockModel> stocks = stocksJson.map((stock) {
        return StockModel.fromJson(stock: stock);
      }).toList();
      firstFetchStocks = stocks;
      return stocks;
    } catch (e) {
      print(e);
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
    final List<StockModel> searchedStocks = firstFetchStocks.where((stock) {
      final tickerMatch = stock.ticker.toLowerCase().contains(lowerQuery);
      final nameMatch = stock.name.toLowerCase().contains(lowerQuery);
      return tickerMatch || nameMatch;
    }).toList();

    state = AsyncValue.data(searchedStocks);
  }
}
