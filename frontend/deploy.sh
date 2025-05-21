flutter build web --web-renderer canvaskit  --dart-define=ENVIROMENT=PROD &&

# 서비스 워커 파일 넣어야 알림처리 가능해서 넣은 로직
CUSTOM_CODE=$(cat <<EOF

self.addEventListener('push', function(event) {
  const data = event.data.json();
  const img_url = '/Icon-512.png';
  self.registration.showNotification(data.title, {
    body: data.title.body,
    icon: img_url,
    data: { url: data.url }
  })
  .then(() => console.log('알림 표시 성공'))
  .catch(err => console.error('알림 표시 실패:', err));
});

self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  event.waitUntil(clients.openWindow(event.notification.data.url));
});
EOF
)

echo "$CUSTOM_CODE" >> ./build/web/flutter_service_worker.js &&

aws s3 sync ./build/web s3://quantwo-bot-frontend && 
aws cloudfront create-invalidation --distribution-id E2QNZ99BY6GHQ9 --paths '/*'\