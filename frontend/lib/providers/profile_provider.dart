import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/profile_stock_model/profile_stock_model.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:quant_bot_flutter/services/stock_service.dart';
// import 'package:quant_bot_flutter/providers/dio_provider.dart';

final profileStocksProvider =
    AsyncNotifierProvider<ProfileStocksNotifier, List<ProfileStockModel>>(
        ProfileStocksNotifier.new);

class ProfileStocksNotifier extends AsyncNotifier<List<ProfileStockModel>> {
  late final StockService _stockService;
  @override
  Future<List<ProfileStockModel>> build() async {
    try {
      _stockService;
    } catch (e) {
      _stockService = StockService(ref.read(dioProvider));
    }
    return fetchProfileStocks();
  }

  Future<List<ProfileStockModel>> fetchProfileStocks() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/quants');

      if (response.statusCode != 200) {
        throw Exception('프로필 주식 정보를 불러오는데 실패했습니다.');
      }

      final List<dynamic> stocksJson = response.data['quants'] as List<dynamic>;
      return stocksJson
          .map((stock) => ProfileStockModel.fromJson(stock))
          .toList();
    } catch (e) {
      throw Exception('프로필 주식 정보를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> refreshProfileStocks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchProfileStocks());
  }

  Future<void> toggleNotification(ProfileStockModel model) async {
    // 알림 상태 토글 시도
    final success = await _stockService.toggleNotification(model.id);

    // 성공하지 않은 경우 에러 상태로 변경
    if (!success) {
      // state = const AsyncValue.data(value)
      return; // 여기서 함수가 종료되어 이후 코드가 실행되지 않음
    }

    // 성공한 경우에만 아래 코드가 실행됨
    state = await AsyncValue.guard(() async {
      final updatedStocks = state.value?.map((stock) {
            if (stock.id == model.id) {
              return ProfileStockModel(
                id: stock.id,
                ticker: stock.ticker,
                name: stock.name,
                quantType: stock.quantType,
                notification: !stock.notification,
                profit: stock.profit,
                profitPercent: stock.profitPercent,
                initialStatus: stock.initialStatus,
                currentStatus: stock.currentStatus,
              );
            }
            return stock;
          }).toList() ??
          [];
      state = AsyncValue.data(updatedStocks);
      CustomToast.show(
          message: '${model.name} 알림 : ${model.notification ? 'Off' : 'On'}');
      return updatedStocks;
    });
  }

  Future<void> deleteQuant(ProfileStockModel model) async {
    // 알림 상태 토글 시도
    final success = await _stockService.deleteQuant(model.id);

    // 성공하지 않은 경우 에러 상태로 변경
    if (!success) {
      // state = const AsyncValue.data(value)
      return; // 여기서 함수가 종료되어 이후 코드가 실행되지 않음
    }

    // 상태를 직접 수정하는 대신 provider 자체를 재빌드
    // optimistic update (즉시 반영)
    final current = state.value ?? [];
    state = AsyncValue.data([...current.where((e) => e.id != model.id)]);
    ref.invalidateSelf();
  }
}

final profileInfoProvider = FutureProvider<Widget>((ref) async {
  Future<Widget> buildProfileInfo(
      AuthStorageNotifier authStorageNotifier) async {
    final user = await authStorageNotifier.findUserByAuth();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: CustomColors.gray40,
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(user.email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  final authStorageNotifier = ref.read(authStorageProvider.notifier);
  return buildProfileInfo(authStorageNotifier);
});

final lightSwitchProvider = StateProvider<bool>((ref) => true);
