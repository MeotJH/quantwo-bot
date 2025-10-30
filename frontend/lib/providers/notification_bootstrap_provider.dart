import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/providers/auth_provider.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/providers/push_provider/push_mobile_provider.dart';
import 'package:quant_bot/services/notification_service.dart';
import 'package:quant_bot/services/push_service.dart/push_service.dart';
import 'package:quant_bot/services/push_service.dart/webpush_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('백그라운드 메시지 처리: ${message.messageId}');
  log('백그라운드 메시지 데이터: ${message.data}');
}

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final webPushServiceProvider = Provider<WebPushService?>((ref) {
  if (!kIsWeb) return null;
  final dio = ref.watch(dioProvider);
  return WebPushService(dio: dio);
});

class NotificationBootstrap extends AutoDisposeAsyncNotifier<void> {
  String? _lastInitializedAuthToken;
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  Future<void> build() async {
    print('111');
    final authState = ref.watch(authStorageProvider);
    final authToken = authState.valueOrNull;
    final hasAuthToken = authToken != null && authToken.isNotEmpty;

    if (!hasAuthToken) {
      _lastInitializedAuthToken = null;
      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub = null;
      return;
    }
    print('222');
    print('aaa');
    if (_lastInitializedAuthToken == authToken) {
      return; // 이미 현재 로그인 토큰으로 초기화 완료
    }

    _lastInitializedAuthToken = authToken;

    if (kIsWeb) {
      final webPush = ref.read(pushServiceProvider);
      webPush.doJob();
      return;
    }

    final messaging = ref.watch(firebaseMessagingProvider);
    final notificationService = ref.watch(notificationServiceProvider);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await notificationService.initNotification();

    final permission = await messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    final currentFcmToken = await messaging.getToken();
    if (currentFcmToken != null) {
      await ref
          .read(authStorageProvider.notifier)
          .updateFcmToken(currentFcmToken);
    }

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = messaging.onTokenRefresh.listen((newToken) {
      ref.read(authStorageProvider.notifier).updateFcmToken(newToken);
    });

    ref.onDispose(() async {
      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub = null;
      _lastInitializedAuthToken = null;
    });
  }
}

final notificationBootstrapProvider =
    AutoDisposeAsyncNotifierProvider<NotificationBootstrap, void>(
  NotificationBootstrap.new,
);
