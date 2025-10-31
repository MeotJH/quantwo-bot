import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/providers/notification_bootstrap_provider.dart';
import 'package:quant_bot/services/push_service.dart/android_push_service.dart';
import 'package:quant_bot/services/push_service.dart/push_service_stub.dart';

final pushServiceProvider = Provider.autoDispose<PushService>((ref) {
  final messaging = ref.read(firebaseMessagingProvider);
  final notificationService = ref.read(notificationServiceProvider);
  final dio = ref.read(dioProvider);

  final service = AndroidPushService(
    messaging: messaging,
    notificationService: notificationService,
    dio: dio,
  );

  ref.onDispose(() async {
    await service.dispose();
  });

  return service;
});
