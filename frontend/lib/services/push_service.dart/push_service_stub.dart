import 'package:dio/dio.dart';

abstract class PushService {
  void sendNotification(String message);

  Future<void> togglePush({isToggle = bool});

  Future<void> doJob();
}

class PushServiceStub {
  Dio dio;
  PushServiceStub({required this.dio});

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
