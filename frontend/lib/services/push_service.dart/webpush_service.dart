import 'dart:developer';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quant_bot/services/push_service.dart/push_service_stub.dart';

class WebPushService implements PushService {
  Dio dio;
  WebPushService({required this.dio});

  @override
  Future<void> togglePush({isToggle = bool}) async {
    // 📌 Flask 서버로 구독 정보 전송
    final response = await dio.patch(
      '/notification/',
      options: Options(headers: {"Content-Type": "application/json"}),
      data: {
        'enabled': isToggle,
      },
    );

    if (response.statusCode == 201) {
      log("✅ 푸시 구독 OFF");
    } else {
      log("❌ 푸시 구독 OFF 실패: $response");
    }
  }

  @override
  Future<void> doJob() async {
    if (kIsWeb) {
      await _unsubscribeAllPush();
      await _subscribeToPush();
    } else {}
  }

  Future<void> _subscribeToPush() async {
    const publicKey =
        "BIlHgOs-gz1uDm-FWUU6RNHLR8onrvuGtlgoUB4BfQuhEJ51vkAPm1nBTy6ZZn8-fqESnQFbBzP0AXgkB6bHuRs="; // VAPID 공개 키

    // 📌 Service Worker가 등록되었는지 확인
    final swRegistration = await html.window.navigator.serviceWorker?.ready;
    if (swRegistration == null) {
      log("❌ Service Worker 미등록");
      return;
    }

    // 📌 웹 푸시 구독 요청
    // 📌 JavaScript 객체로 PushSubscriptionOptions 생성
    final subscription = await js_util.promiseToFuture(
      js_util.callMethod(
        swRegistration.pushManager!,
        'subscribe',
        [
          js_util.jsify({
            "userVisibleOnly": true,
            "applicationServerKey": urlBase64ToUint8Array(publicKey),
          })
        ],
      ),
    );

    final p256dhBuffer = subscription.getKey("p256dh"); // NativeByteBuffer
    final authBuffer = subscription.getKey("auth"); // NativeByteBuffer

    // NativeByteBuffer를 ByteBuffer로 캐스팅 → Uint8List.view()를 통해 List<int> 변환
    final p256dhBytes = Uint8List.view((p256dhBuffer as ByteBuffer));
    final authBytes = Uint8List.view((authBuffer as ByteBuffer));

    // 이제 base64Encode에 넣어 문자열로 만든다.
    final subscriptionJson = {
      "endpoint": subscription.endpoint,
      "keys": {
        "p256dh": base64Encode(p256dhBytes),
        "auth": base64Encode(authBytes),
      },
    };

    // 📌 Flask 서버로 구독 정보 전송
    final response = await dio.post(
      '/notification/subscribe',
      options: Options(headers: {"Content-Type": "application/json"}),
      data: subscriptionJson,
    );

    if (response.statusCode == 201) {
      log("✅ 푸시 구독 성공");
    } else {
      log("❌ 푸시 구독 실패: $response");
    }
  }

  Future<void> _unsubscribeAllPush() async {
    // 📌 Service Worker가 등록되었는지 확인
    final swRegistration = await html.window.navigator.serviceWorker?.ready;
    if (swRegistration == null) {
      log("❌ Service Worker 미등록 상태");
      return;
    }

    // 📌 pushManager가 있는지 확인
    if (swRegistration.pushManager == null) {
      log("❌ pushManager 사용 불가 (브라우저가 웹 푸시 미지원)");
      return;
    }

    // 📌 현재 등록된 모든 구독 가져오기
    final existingSubscription = await js_util.promiseToFuture(
      js_util.callMethod(
        swRegistration.pushManager!,
        'getSubscription',
        [],
      ),
    );

    if (existingSubscription != null) {
      log("✅ 기존 푸시 구독 발견! 삭제 진행...");

      // 📌 구독 해제
      final unsubResult = await js_util.promiseToFuture<bool>(
        js_util.callMethod(
          existingSubscription,
          'unsubscribe',
          [],
        ),
      );

      if (unsubResult) {
        log("✅ 기존 푸시 구독 해제 성공");
      } else {
        log("❌ 기존 푸시 구독 해제 실패");
      }
    } else {
      log("🔹 기존 구독 없음");
    }
  }

  // 📌 Base64 URL을 Uint8Array로 변환하는 함수
  List<int> urlBase64ToUint8Array(String base64String) {
    // 먼저 URL-safe Base64에 사용되는 문자들을 일반 Base64 문자로 치환합니다.
    String output = base64String.replaceAll('-', '+').replaceAll('_', '/');

    // 문자열 길이가 4의 배수가 아니라면, '=' 패딩을 적절히 추가해줍니다.
    while (output.length % 4 != 0) {
      output += '=';
    }

    // 실제 Base64 디코딩을 수행합니다.
    return base64Decode(output);
  }

  @override
  void sendNotification(String message) {
    // TODO: implement sendNotification
  }
}
