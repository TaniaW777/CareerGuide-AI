import { Routes, Route } from 'react-router-dom';
import { useEffect } from 'react';
import { useOfflineStore } from './store/useOfflineStore';

import Landing from './pages/Landing';
import Profil from './pages/Profil';
import Recommendations from './pages/Recommendations';
import Chat from './pages/Chat';
import Testimonials from './pages/Testimonials';
import Settings from './pages/Settings';
import Layout from './components/Layout';

function App() {
  const setOfflineStatus = useOfflineStore(state => state.setOfflineStatus);
  const theme = useOfflineStore(state => state.theme);

  useEffect(() => {
    const isDark = theme === 'dark';
    document.documentElement.classList.toggle('dark', isDark);
    document.body.classList.toggle('dark', isDark);
    document.documentElement.style.colorScheme = isDark ? 'dark' : 'light';
  }, [theme]);

  useEffect(() => {
    const handleOnline = () => setOfflineStatus(false);
    const handleOffline = () => setOfflineStatus(true);
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);
    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, [setOfflineStatus]);

  return (
    <div className="antialiased min-h-screen">
      <Layout>
        <Routes>
          <Route path="/" element={<Landing />} />
          <Route path="/profil" element={<Profil />} />
          {/* Legacy route redirects to /profil or handles navigation properly if needed, but since we updated all Links, it's fine */}
          <Route path="/profile-setup" element={<Profil />} />
          <Route path="/profit" element={<Profil />} />
          <Route path="/recommendations" element={<Recommendations />} />
          <Route path="/chat" element={<Chat />} />
          <Route path="/testimonials" element={<Testimonials />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </Layout>
    </div>
  );
}

export default App;
