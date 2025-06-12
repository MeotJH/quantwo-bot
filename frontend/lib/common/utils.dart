import 'package:dio/dio.dart';

double roundToSecondDecimal(double value) {
  return (value * 100).round() / 100;
}

calculatePercentageChange({required double open, required double close}) {
  return roundToSecondDecimal(((close - open) / open) * 100);
}

String getErrorMessage(dynamic error) {
  if (error is DioException) {
    final response = error.response;
    if (response != null && response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;
      if (responseData.containsKey('message')) {
        return responseData['message'] as String;
      }
    }
  }
  return '오류가 발생했습니다.';
}
