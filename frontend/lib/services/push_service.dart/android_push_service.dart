import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quant_bot/providers/auth_provider.dart';
import 'package:quant_bot/providers/notification_bootstrap_provider.dart';
import 'package:quant_bot/services/local_notification_service.dart';
import 'package:quant_bot/services/push_service.dart/push_service_stub.dart';

class AndroidPushService implements PushService {
  FirebaseMessaging messaging;
  LocalNotificationService notificationService;
  Dio dio;
  StreamSubscription<String>? _tokenRefreshSub;

  AndroidPushService({
    required this.messaging,
    required this.notificationService,
    required this.dio,
  });

  @override
  Future<void> doJob() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await notificationService.initNotification();

    final permission = await messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    final currentFcmToken = await messaging.getToken();
    if (currentFcmToken != null) {
      await _updateFcmToken(currentFcmToken);
    }

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = messaging.onTokenRefresh.listen((newToken) async {
      await _updateFcmToken(newToken);
    });
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
  }

  Future<void> _updateFcmToken(String newToken) async {
    try {
      log('iscalled ');
      final response = await dio.patch('/users/', data: {'fcmToken': newToken});

      if (response.statusCode != 200) {
        throw Exception('FCM 토큰 업데이트 실패');
      }
      log('FCM 토큰이 성공적으로 업데이트되었습니다');
    } catch (e) {
      log('FCM 토큰 업데이트 중 오류: $e');
      // 실패 시 재시도 로직 구현 가능
    }
  }

  @override
  void sendNotification(String message) {
    // TODO: implement sendNotification
  }

  @override
  Future<void> togglePush({isToggle = bool}) {
    // TODO: implement togglePush
    throw UnimplementedError();
  }
}
