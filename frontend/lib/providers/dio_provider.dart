import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:developer';

class DioNotifier extends Notifier<Dio> {
  late String apiUrl;
  late Dio _dio;

  String resolveApiBaseUrl() {
    final isLocalEnvironment =
        (dotenv.env['ENVIROMENT']?.toLowerCase() ?? 'LOCAL') ==
            'LOCAL'.toLowerCase();
    log('am i local? $isLocalEnvironment');
    if (!isLocalEnvironment) {
      return 'https://quantwo-bot.com/api/v1';
    }

    return kIsWeb
        ? 'http://127.0.0.1:8080/api/v1'
        : 'http://10.0.2.2:8080/api/v1';
  }

  @override
  Dio build() {
    apiUrl = resolveApiBaseUrl();
    _dio = Dio(BaseOptions(baseUrl: apiUrl));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(authStorageProvider.notifier).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          CustomToast.show(message: 'mail 또는 비밀번호가 올바르지 않습니다.', isWarn: true);
        }

        if (error.response?.statusCode == 500) {
          CustomToast.show(
              message: '서버 오류가 발생했습니다. 개발 도비가 열심히 고칠게요! 🥺', isWarn: true);
        }

        if (error.response?.statusCode == 400) {
          CustomToast.show(
              message: '잘못된 요청입니다. 아마 그런데 개발자 도비 잘못일거예요 😢', isWarn: true);
        }
        handler.reject(error);
      },
    ));

    return _dio;
  }

  void addAuth({required String token}) {
    _dio.options = _dio.options.copyWith(
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  void removeAuth() {
    _dio.options = _dio.options.copyWith(headers: {});
  }
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
