// src/main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App';
import './index.css';
import { registerSW } from 'virtual:pwa-register';

// Register service worker for offline support
if ('serviceWorker' in navigator) {
  registerSW({
    onNeedRefresh() {
      if (confirm('Une nouvelle version est disponible. Voulez-vous mettre à jour ?')) {
        window.location.reload();
      }
    },
    onOfflineReady() {
      console.log('L\'application est prête à être utilisée hors-ligne.');
    },
  });
}

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);

