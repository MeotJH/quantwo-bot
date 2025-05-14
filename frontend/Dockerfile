# 1단계: Flutter build
FROM instrumentisto/flutter:3.19.5 AS builder

WORKDIR /app
COPY . .
# Flutter 패키지 설치
RUN flutter pub get

# Flutter 빌드
RUN flutter build web --web-renderer canvaskit

# flutter_service_worker.js 수정 웹앱알림 보내기 위한 구문
RUN echo "self.addEventListener('push', function(event) {\
  const data = event.data.json();\
  const img_url = '/Icon-512.png';\
  self.registration.showNotification(data.title, {\
    body: data.title.body,\
    icon: img_url,\
    data: { url: data.url }\
  })\
  .then(() => console.log('알림 표시 성공'))\
  .catch(err => console.error('알림 표시 실패:', err));\
});\
self.addEventListener('notificationclick', function(event) {\
  event.notification.close();\
  event.waitUntil(clients.openWindow(event.notification.data.url));\
});" >> ./build/web/flutter_service_worker.js


# 2단계: Nginx로 서빙
FROM nginx:1.25

# Flutter 빌드 결과물 복사
COPY --from=builder /app/build/web/ /usr/share/nginx/html/web

# 필요하면 nginx 설정 덮어쓰기
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
