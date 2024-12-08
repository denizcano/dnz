// manifest.json
{
  "name": "Aralık 2024 Takvimi",
  "short_name": "Takvim",
  "description": "Yılbaşı temalı plan takvimi",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#ef4444",
  "icons": [
    {
      "src": "/icons/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}

// service-worker.js
const CACHE_NAME = 'calendar-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/styles.css',
  '/app.js',
  '/icons/icon-192.png',
  '/icons/icon-512.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});

// App.js
import React, { useState, useEffect } from 'react';
import { Calendar, Plus } from 'lucide-react';

const App = () => {
  const [events, setEvents] = useState({});
  
  // LocalStorage'dan verileri yükle
  useEffect(() => {
    const savedEvents = localStorage.getItem('calendarEvents');
    if (savedEvents) {
      setEvents(JSON.parse(savedEvents));
    }
  }, []);

  // Verileri LocalStorage'a kaydet
  useEffect(() => {
    localStorage.setItem('calendarEvents', JSON.stringify(events));
  }, [events]);

  // ... (önceki takvim komponentinin geri kalanı aynı kalacak)
};

// index.html
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aralık 2024 Takvimi</title>
    <link rel="manifest" href="/manifest.json">
    <meta name="theme-color" content="#ef4444">
    <link rel="apple-touch-icon" href="/icons/icon-192.png">
</head>
<body>
    <div id="root"></div>
    <script>
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/service-worker.js')
                    .then(registration => {
                        console.log('ServiceWorker başarıyla kaydedildi');
                    })
                    .catch(error => {
                        console.log('ServiceWorker kaydı başarısız:', error);
                    });
            });
        }
    </script>
</body>
</html>
