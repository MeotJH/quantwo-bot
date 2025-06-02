import 'package:dio/dio.dart';

class WebPushService {
  Dio dio;
  WebPushService({required this.dio});

  void sendNotification(String message) {
    throw UnsupportedError('Web push not supported on this platform.');
  }

  Future<void> togglePush({isToggle = bool}) async {
    throw UnsupportedError('Web push not supported on this platform.');
  }

  Future<void> doJob() async {
    throw UnsupportedError('Web push not supported on this platform.');
  }
}
