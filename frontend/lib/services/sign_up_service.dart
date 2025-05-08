import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/models/sign_up_model/sign_up_model.dart';

class SignUpService {
  final SignUpModel model;
  SignUpModel _modelWithToken = SignUpModel();
  SignUpService({required this.model});

  Future<bool> signUp({required Dio dio}) async {
    try {
      validate();
      await addAppToken();

      final response = await dio
          .post(
        '/users/sign-up',
        data: _modelWithToken.toJson(),
      )
          .timeout(
        const Duration(seconds: 10), // 타임아웃 설정
        onTimeout: () {
          throw TimeoutException('회원가입 요청 시간이 초과되었습니다.');
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        CustomToast.show(
            message: '회원가입에 실패했습니다: ${response.statusMessage}', isWarn: true);
        throw Exception('회원가입에 실패했습니다: ${response.statusMessage}');
      }
    } catch (e) {
      if (e is DioException) {
        final errorCode = e.response?.statusCode;
        e.message;
        final data = e.response?.data;
        CustomToast.show(message: data['message'].toString(), isWarn: true);
        throw DioException(requestOptions: data);
      } else {
        CustomToast.show(message: '회원가입 처리 중 오류가 발생했습니다.', isWarn: true);
        throw Exception('회원가입 처리 중 오류가 발생했습니다.');
      }
    }
  }

  Future<void> addAppToken() async {
    try {
      if (kIsWeb) {
        _modelWithToken = model;
      } else {
        final token = await FirebaseMessaging.instance.getToken();
        _modelWithToken = model.copyWith(appToken: token);
      }
    } catch (e) {
      debugPrint('Firebase token error: $e');
      // Firebase 토큰 획득 실패시에도 계속 진행
      _modelWithToken = model;
    }
  }

  void validate() {
    final fields = {
      '이메일이': model.email,
      '비밀번호가': model.password,
      '이름이': model.userName,
      '전화번호가': model.mobile,
    };

    for (var entry in fields.entries) {
      if (entry.value.isEmpty) {
        throw Exception('${entry.key} 올바르지 않습니다.');
      }
    }
  }

  // 이메일 유효성 검사
  static bool validateEmail(String email) {
    // 이메일 형식에 맞는지 확인
    if (email.isEmpty) return true;
    final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailReg.hasMatch(email);
  }

  // 비밀번호 유효성 검사
  static bool validatePassword(String password) {
    // 8자리 이상 문자, 숫자, 특수문자를 포함해야 함
    if (password.isEmpty) return true;
    final passwordReg =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordReg.hasMatch(password);
  }

  // 비밀번호 유효성 검사
  static bool validateMatchPassword(
      {required String password, required String passwordDuplicate}) {
    return password == passwordDuplicate;
  }
}
