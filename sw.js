self.addEventListener('install',e=>self.skipWaiting());
self.addEventListener('activate',e=>e.waitUntil(
  caches.keys().then(keys=>Promise.all(keys.filter(k=>k.startsWith('baseball-vision-')).map(k=>caches.delete(k))))
  .then(()=>self.clients.claim())
));
