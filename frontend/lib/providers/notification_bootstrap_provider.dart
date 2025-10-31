import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/providers/auth_provider.dart';
import 'package:quant_bot/providers/push_provider/push_mobile_provider.dart';
import 'package:quant_bot/services/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('백그라운드 메시지 처리: ${message.messageId}');
  log('백그라운드 메시지 데이터: ${message.data}');
}

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final notificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

class NotificationBootstrap extends AutoDisposeAsyncNotifier<void> {
  String? _lastInitializedAuthToken;
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  Future<void> build() async {
    final authState = ref.watch(authStorageProvider);
    final authToken = authState.valueOrNull;
    final hasAuthToken = authToken != null && authToken.isNotEmpty;

    if (!hasAuthToken) {
      _lastInitializedAuthToken = null;
      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub = null;
      return;
    }
    if (_lastInitializedAuthToken == authToken) {
      return;
    }
    _lastInitializedAuthToken = authToken;

    final webPush = ref.read(pushServiceProvider);
    webPush.doJob();

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
