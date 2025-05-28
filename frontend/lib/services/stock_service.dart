import 'package:dio/dio.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'dart:developer';

class StockService {
  final Dio dio;

  StockService(this.dio);

  Future<void> addStockToProfile(String ticker, String quantType,
      double initialPrice, double initialTrendFollow) async {
    final data = {
      "stock": ticker,
      "quant_type": quantType,
      "initial_price": initialPrice,
      "initial_trend_follow": initialTrendFollow,
      "initial_status": initialPrice > initialTrendFollow ? "BUY" : "SELL"
    };

    try {
      final response =
          await dio.post('/quants/trend-follow/us/$ticker', data: data);

      if (response.statusCode == 200) {
        print('주식이 프로필에 추가되었습니다.');
      } else {
        throw Exception('주식 추가 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('예외 발생: $e');
      rethrow;
    }
  }

  Future<bool> toggleNotification(String id) async {
    try {
      final response = await dio.patch('/quants/$id/notification');
      log('toggleNotification statusCode: ${response.statusCode}');
      // 상태 코드가 200일 때만 성공으로 간주합니다.
      if (response.statusCode == 200) {
        print('알림 상태가 변경되었습니다.');
        return true; // 성공 시 true 반환
      } else {
        CustomToast.show(message: '서버와의 연결이 원활하지 않습니다.', isWarn: true);
        throw Exception('알림 상태 변경 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('예외 발생: $e');
      return false; // 예외 발생 시 false 반환
    }
  }

  Future<bool> deleteQuant(String id) async {
    try {
      final response = await dio.delete('/quants/$id');
      log('delete quants statusCode: ${response.statusCode}');
      // 상태 코드가 200일 때만 성공으로 간주합니다.
      if (response.statusCode == 200) {
        CustomToast.show(message: '성공적으로 삭제되었습니다.', isWarn: true);
        return true; // 성공 시 true 반환
      } else {
        CustomToast.show(message: '서버와의 연결이 원활하지 않습니다.', isWarn: true);
        throw Exception('삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('예외 발생: $e');
      return false; // 예외 발생 시 false 반환
    }
  }
}
