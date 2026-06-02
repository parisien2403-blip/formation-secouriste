const CACHE = 'secourisme-v7';
const ASSETS = [
  '/formation-secouriste/index.html',
  '/formation-secouriste/manifest.json',
  '/formation-secouriste/sw.js',
  '/formation-secouriste/phonix.png',
  '/formation-secouriste/icon-192.png',
  '/formation-secouriste/icon-512.png',
  '/formation-secouriste/icon-maskable-512.png'
];

self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open(CACHE).then(function (c) {
      return Promise.allSettled(ASSETS.map(function (u) {
        return c.add(u);
      }));
    }).then(function () { return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function (e) {
  e.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(keys.filter(function (k) { return k !== CACHE; }).map(function (k) {
        return caches.delete(k);
      }));
    }).then(function () { return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function (e) {
  if (e.request.method !== 'GET') return;
  var url = new URL(e.request.url);
  if (url.origin !== self.location.origin) return;
  if (!url.pathname.startsWith('/formation-secouriste/')) return;

  if (e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request).catch(function () {
        return caches.match('/formation-secouriste/index.html');
      })
    );
    return;
  }

  e.respondWith(
    caches.match(e.request).then(function (cached) {
      return cached || fetch(e.request).then(function (r) {
        if (r && r.status === 200 && r.type === 'basic') {
          var clone = r.clone();
          caches.open(CACHE).then(function (c) { c.put(e.request, clone); });
        }
        return r;
      });
    })
  );
});
