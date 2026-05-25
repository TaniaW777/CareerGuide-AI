import { Routes, Route } from 'react-router-dom';
import { useEffect } from 'react';
import { useOfflineStore } from './store/useOfflineStore';

import Landing from './pages/Landing';
import ProfileSetup from './pages/ProfileSetup';
import Recommendations from './pages/Recommendations';
import Chat from './pages/Chat';
import Testimonials from './pages/Testimonials';
import Settings from './pages/Settings';
import Layout from './components/Layout';

function App() {
  const setOfflineStatus = useOfflineStore(state => state.setOfflineStatus);
  const theme = useOfflineStore(state => state.theme);

  useEffect(() => {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
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
    <div className="antialiased text-gray-900 dark:text-gray-100 min-h-screen">
      <Layout>
        <Routes>
          <Route path="/" element={<Landing />} />
          <Route path="/profile-setup" element={<ProfileSetup />} />
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

