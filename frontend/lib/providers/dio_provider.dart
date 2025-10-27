import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:quant_bot/components/custom_toast.dart';
import 'package:quant_bot/constants/api_constants.dart';
import 'package:quant_bot/constants/enviroment_constant.dart';
import 'package:quant_bot/providers/auth_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:developer';

class DioNotifier extends Notifier<Dio> {
  late String apiUrl;
  late Dio _dio;
  static const appLocalUri = 'http://10.0.2.2:8080/api/v1';
  String resolveApiBaseUrl() {
    log('which env ::: ${Environment.env}');
    //환경이 로컬이 아니면 api서버에 요청
    if (Environment.env == 'PROD') {
      return ApiUrl.prodUri;
    }

    //로컬인데 web이면 웹로컬 앱이면 앱로컬
    return kIsWeb ? ApiUrl.webLocalUri : appLocalUri;
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
        // 네트워크 연결 실패 (서버에 도달하지 못함)
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.unknown &&
                error.error is SocketException) {
          CustomToast.show(
            message: '서버에 연결할 수 없습니다. 네트워크를 확인해주세요. 🌐',
            isWarn: true,
          );
          return handler.next(error);
        }

        // 타임아웃 관련
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          CustomToast.show(
            message: '요청이 시간 초과되었습니다. 다시 시도해주세요. ⏳',
            isWarn: true,
          );
          return handler.next(error);
        }

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
