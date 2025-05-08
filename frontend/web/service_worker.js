   self.addEventListener('push', function(event) {
    console.info(event,"event::::");
    const data = event.data.json();
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: '/icons/app-icon.png',
      data: { url: data.url }
    });
  });
  
  self.addEventListener('notificationclick', function(event) {
    event.notification.close();
    event.waitUntil(clients.openWindow(event.notification.data.url));
  });
  