import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/components/custom_toast.dart';
import 'package:quant_bot/models/profile_stock_model/profile_stock_model.dart';
import 'package:quant_bot/models/user_model/user_model.dart';
import 'package:quant_bot/providers/auth_provider.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/services/stock_service.dart';

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
      return;
    }

    // 상태를 직접 수정하는 대신 provider 자체를 재빌드
    // optimistic update (즉시 반영)
    final current = state.value ?? [];
    state = AsyncValue.data([...current.where((e) => e.id != model.id)]);
    ref.invalidateSelf();
  }
}

final profileInfoNotifier =
    AsyncNotifierProvider<ProfileInfoNotifier, UserModel>(
        ProfileInfoNotifier.new);

class ProfileInfoNotifier extends AsyncNotifier<UserModel> {
  @override
  Future<UserModel> build() async {
    final authStorage = ref.read(authStorageProvider.notifier);
    return await authStorage.findUserByAuth();
  }

  // 필요 시 수동으로 재조회 가능
  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    try {
      final authStorage = ref.read(authStorageProvider.notifier);
      final user = await authStorage.findUserByAuth();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// ✅ notification 값을 변경하는 메서드
  Future<void> toggleNotification(bool enabled) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    // 1. 서버 업데이트 (필요 시)
    final updatedUser = currentUser.copyWith(notification: enabled);

    // 2. 상태 갱신
    state = AsyncValue.data(updatedUser);
  }
}

//간단한 프로바이더 사용 예시 전원 on/off 불린 provider
final lightSwitchProvider = StateProvider<bool>((ref) => true);
