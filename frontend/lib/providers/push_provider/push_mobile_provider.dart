import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/services/push_service.dart/push_service_stub.dart';
import 'package:quant_bot/services/push_service.dart/webpush_service.dart';

final pushServiceProvider = Provider<PushService>((ref) {
  final dio = ref.watch(dioProvider);
  return WebPushService(dio: dio);
});
