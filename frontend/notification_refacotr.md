# 알림 리팩터링 가이드 (Quant Bot 코드 기준)

## 현재 `main.dart`의 이슈
- Firebase 초기화와 로컬 알림 세팅이 `main()`과 `initNotifications()` 양쪽에서 중복 호출된다.
- FCM 토큰 갱신을 `ProviderContainer()`로 처리하면서, 리버팟 DI 체인 밖에서 새 컨테이너를 생성해 의도치 않은 인스턴스가 생긴다.
- 웹/모바일 분기가 한 파일에 섞여 있고, 토큰 업데이트가 `authStorageProvider`의 책임과 분리돼 테스트가 어렵다.

## 리팩터링 목표
- `main.dart`는 부트스트랩(`Environment`, Firebase 초기화, `runApp`)만 담당한다.
- 알림 초기화는 Riverpod 프로바이더(`notification_bootstrap_provider.dart`)에서 수행하고, 필요 시 UI에서는 해당 프로바이더를 `listen`만 한다.
- 모바일 FCM과 웹 Push 로직은 각각 `services/notification_service.dart`, `services/push_service.dart` 계층으로 위임한다.
- FCM 토큰 저장은 기존 `authStorageProvider`의 `updateFcmToken`을 재사용해 백엔드 연동 흐름을 그대로 유지한다.

## 권장 파일 구조
```
lib/
 ├─ main.dart
 ├─ providers/
 │   └─ notification_bootstrap_provider.dart
 └─ services/
     ├─ notification_service.dart          // 기존 로컬 알림 초기화 유지
     └─ push_service.dart/                 // WebPushService 그대로 사용
```

## 구현 예시
### 1. `lib/main.dart`
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/constants/enviroment_constant.dart';
import 'package:quant_bot/providers/router_provider.dart';
import 'package:quant_bot/providers/notification_bootstrap_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:developer';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment();
  log('ENVIRONMENT: ${Environment.env}');
  setPathUrlStrategy();

  if (!kIsWeb) {
    await Firebase.initializeApp();
  }

  runApp(const ProviderScope(child: QuantBot()));
}

class QuantBot extends ConsumerStatefulWidget {
  const QuantBot({super.key});

  @override
  ConsumerState<QuantBot> createState() => _QuantBotState();
}

class _QuantBotState extends ConsumerState<QuantBot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationBootstrapProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      notificationBootstrapProvider,
      (_, next) => next.when(
        data: (_) => log('알림 준비 완료'),
        error: (err, stack) => log('알림 초기화 실패: $err'),
        loading: () {},
      ),
    );

    return MaterialApp.router(
      title: 'Quant Bot',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
            .copyWith(background: Colors.white),
        dialogBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: ref.read(routeProvider),
    );
  }
}
```

### 2. `lib/providers/notification_bootstrap_provider.dart`
```dart
import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/providers/auth_provider.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/services/notification_service.dart';
import 'package:quant_bot/services/push_service.dart/push_service.dart';

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

final notificationBootstrapProvider =
    FutureProvider.autoDispose<void>((ref) async {
  if (kIsWeb) {
    final webPush = ref.watch(webPushServiceProvider);
    await webPush?.doJob();
    return;
  }

  final messaging = ref.watch(firebaseMessagingProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await notificationService.initNotification();

  final settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return;
  }

  final token = await messaging.getToken();
  if (token != null) {
    await ref.read(authStorageProvider.notifier).updateFcmToken(token);
  }

  final subscription = messaging.onTokenRefresh.listen((newToken) {
    ref.read(authStorageProvider.notifier).updateFcmToken(newToken);
  });

  ref.onDispose(subscription.cancel);
});
```

### 3. `lib/services/notification_service.dart`
```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'quant_bot_channel',
      'QuantBot Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, details);
  }
}
```

### 4. 웹 푸시 연동 (`lib/services/push_service.dart/webpush_service.dart`)
- 기존 구현을 그대로 사용하되, `notificationBootstrapProvider`에서 `WebPushService.doJob()`을 호출하면 서비스 워커 구독/해제와 백엔드 `/notification/subscribe` 연동이 실행된다.
- 토글 API 호출이 필요할 경우 별도 `FutureProvider`나 `Notifier`를 만들어 UI 버튼에서 `WebPushService.togglePush`를 호출한다.

## 리팩터링 체크리스트
- [ ] `main.dart`에서 `initNotifications()`와 직접적인 토큰 갱신 코드를 제거한다.
- [ ] `lib/providers`에 `notification_bootstrap_provider.dart`를 추가하고 `QuantBot`에서 `ref.read` / `ref.listen`으로만 접근한다.
- [ ] `NotificationService`는 로컬 알림 초기화/표시만 담당하도록 유지한다.
- [ ] 안드로이드에서 `android/app/src/main/AndroidManifest.xml`에 포그라운드 서비스 권한(`POST_NOTIFICATIONS`)이 선언돼 있는지 확인한다.
- [ ] iOS라면 `Info.plist`에 알림 권한 문구를 추가한다.

## 테스트 아이디어
- `authStorageProvider`를 `ProviderScope`에서 오버라이드해 목 객체를 주입하고, `notificationBootstrapProvider`가 토큰을 수신했을 때 `updateFcmToken`을 호출하는지 검증한다.
- `FirebaseMessaging`과 `FlutterLocalNotificationsPlugin`을 `Mocktail`/`Mockito`로 대체하여 권한 거부, 토큰 null, 스트림 에러 시나리오를 단위 테스트한다.
- 웹 환경에선 `WebPushService`를 오버라이드하여 `doJob()`이 호출될 때 구독 API가 정확한 payload로 호출되는지 확인한다.
