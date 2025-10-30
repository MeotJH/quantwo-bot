# Android 알림 통합 로드맵

웹(Service Worker) 기반 푸시를 유지하면서 안드로이드 네이티브 푸시(FCM)를 객체지향적으로 확장하기 위한 작업 항목을 정리했습니다. 백엔드와 프론트엔드 모두 공통 인터페이스를 정의하고, 각 플랫폼 전용 구현체를 추가하는 방향을 기준으로 작성했습니다.

## 1. 백엔드

### 1.1 설계 방향
- `api/notification/infrastructure/push/push_sender.py`의 인터페이스를 활용하여 `WebPushSender`와 병렬 구조의 `AppPushSender`(FCM) 구현체를 추가합니다.
- `NotificationService`에서 푸시 전송 시점에 **전략 선택 로직**을 추가하거나, `PushSenderFactory`(예: `infrastructure/push/push_sender_factory.py`)를 도입하여 사용자별 등록 채널에 따라 적절한 Sender를 주입합니다.
- 사용자당 여러 단말(웹, 앱)을 지원해야 한다면 `NotificationEntity`(현재 `notification_keys`, `fcm_token`)를 확장하거나 별도 `NotificationDeviceEntity` 테이블로 분리하는 것을 검토합니다.

### 1.2 인프라 준비
- Firebase Admin SDK를 requirements에 추가하고 서비스 계정 키(`firebase_admin`)를 안전하게 주입합니다.
  - 예: `requirements.txt`에 `firebase-admin` 추가, `config.py` 또는 환경 변수로 서비스 계정 경로 관리.
- `AppPushSender` 구현:
  - `firebase_admin.messaging`으로 FCM 메시지 전송.
  - 데이터 페이로드(`title`, `body`, `url`, `click_action`) 구성.
  - `validate_subscription`에서 `fcm_token` 존재 여부 검증.
  - 실패 시 토큰 만료/삭제 로직 포함.

### 1.3 API 확장
- **토큰 등록**: `NotificationService.save_fcm_token`을 호출하는 새 엔드포인트 추가 (예: `POST /notification/fcm-token`).
  - 요청 바디: `{ "fcm_token": "..." }`
  - 기존 JWT 인증 흐름 재사용.
- **알림 토글**: 모바일에서도 공통으로 사용 가능하도록 `toggle_notification` 응답 구조를 확장(`channel`: web/app 등 표시).
- **테스트/디버그**: `POST /notification/test`와 같은 엔드포인트에서 웹/앱 채널 선택 옵션 제공.
- **메시지 공통화**: Notification 모델에 채널별 옵션 추가를 고려 (`platform_overrides`).

### 1.4 서비스/리포지토리
- `NotificationRepository`에 다중 단말 지원 로직 구현:
  - `update_fcm_token`이 동일 사용자에 대해 여러 토큰을 저장할 수 있도록 구조 개선 (JSON 배열 또는 별도 테이블).
  - 토글 시 채널별 enable 상태 관리 (`enabled_web`, `enabled_app`).
- `NotificationService.send_notification` 흐름 보완:
  - 사용자별 등록 채널을 순회하며 적절한 Sender로 메시지 전송.
  - 실패한 토큰은 정리(soft delete) 후 DB 업데이트.
  - 전략 패턴 적용: `PushSender`를 구현체 주입 또는 팩토리로 선택.

### 1.5 배포/운영
- 서비스 계정 키 비공개 저장 (예: AWS Secret Manager, Docker secret).
- 로깅(`util/logging_util.py`)에 채널명, 토큰 상태 포함.
- 통합 테스트: `tests/api/notification/test_notification.py` 등에 앱 푸시 경로 케이스 추가 (mocking).

## 2. 프론트엔드 (Flutter)

### 2.1 의존성/환경 설정
- `firebase_core`, `firebase_messaging`, (필요 시) `flutter_local_notifications` 추가.
- Android 프로젝트(`android/app/build.gradle`)에 `apply plugin: 'com.google.gms.google-services'`, `com.google.gms:google-services` 추가.
- Firebase Console에서 프로젝트 생성 → Android 앱 등록 → `google-services.json`을 `android/app/`에 배치.
- `AndroidManifest.xml`에 FCM permission 및 notification channel 설정.

### 2.2 객체지향 구조 정비
- `lib/services/push_service.dart`에 플랫폼별 구현을 매핑하는 추상 계층 도입:
  ```dart
  abstract class PushService {
    Future<void> register();
    Future<void> toggle(bool enabled);
    Future<void> syncState();
  }
  ```
- 웹: 기존 `WebPushService`가 `PushService` 구현체를 따르도록 수정.
- 안드로이드: `AndroidPushService`(신규)에서 FCM 토큰 수집, 백엔드에 등록, 권한 처리 구현.
- `push_service.dart`가 `dart.library.html`/`dart.library.io` 조건부 import로 적절한 구현체를 반환하도록 조정.

### 2.3 FCM 토큰 흐름
- 앱 시작 시 `Firebase.initializeApp()` → `FirebaseMessaging.instance.requestPermission()`.
- `FirebaseMessaging.instance.getToken()`으로 토큰 획득 후
  - 신규 토큰이면 `POST /notification/fcm-token` 호출.
  - 토글 상태와 연계하여 토큰/알림 상태를 백엔드에 반영.
- 토큰 갱신(`onTokenRefresh`) 리스너에서 자동으로 백엔드에 업데이트.

### 2.4 알림 표시
- 포그라운드: `FirebaseMessaging.onMessage.listen`에서 로컬 알림(`flutter_local_notifications`) 표시.
- 백그라운드/종료 상태: `firebase_messaging`의 background handler 등록 (`_firebaseMessagingBackgroundHandler`).
- 탭 액션: 메시지 데이터(`url`)를 이용하여 적절한 화면으로 라우팅.
- Android 13 이상을 대비하여 POST_NOTIFICATIONS 권한 처리.

### 2.5 사용자 설정 연동
- 기존 웹 토글 UI 재사용 또는 분기 처리하여 “푸시 알림” 스위치가 플랫폼을 감지해 적절한 API 호출.
- 알림 OFF 시 백엔드에 `enabled=false` 전달 → FCM 토큰 비활성화/삭제.
- 사용자가 웹&앱 모두 사용 시 상태 동기화 전략 정의 (예: 채널별 토글, 공통 토글 등).

### 2.6 테스트/검증
- Flutter integration test로 토큰 등록 흐름 Mocking.
- 안드로이드 디바이스/에뮬레이터에서 포그라운드/백그라운드 시나리오 검증.
- 서비스 워커와 동시에 접속한 계정으로 웹/앱 모두 알림 수신이 가능한지 엔드투엔드 체크.

## 3. 추가 고려사항
- **보안**: FCM 토큰은 사용자 인증 후에만 수집/저장, HTTPS 필수.
- **메시지 정책**: 앱이 백그라운드일 때 데이터 메시지만 보내고 기기에서 노티 생성하거나, 알림 메시지를 이용해 즉시 표시할지 정책 결정.
- **분석**: Firebase Analytics 또는 자체 로깅으로 알림 수신/탭 이벤트 추적.
- **릴리즈 플로우**: 안드로이드용 SHA1/SHA256 지문 등록, Play Store 출시 시 FCM 권한 가이드 포함.

위의 단계에 따라 구조를 정비하면 기존 웹 푸시 아키텍처 위에 안드로이드 네이티브 알림을 안전하게 확장할 수 있습니다.
