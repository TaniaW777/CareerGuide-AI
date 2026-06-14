import { Link, useLocation } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import { useAppMode } from '../store/useAppMode';
import AppLogo from './Logo';

const navLinks = [
  {
    to: '/',
    label: 'Accueil',
  },
  {
    to: '/profil',
    label: 'Mon Profil',
  },
  {
    to: '/etablissements',
    label: 'Établissements',
  },
  {
    to: '/filieres',
    label: 'Filières',
  },
  {
    to: '/recommendations',
    label: 'Recommandations IA',
  },
  {
    to: '/chat',
    label: 'Conseiller IA',
  },
];

export default function Navbar() {
  const location = useLocation();
  const { theme, toggleTheme } = useOfflineStore();
  const { isOnline, toggleMode } = useAppMode();

  return (
    <>
      {/* ===== Desktop Top Navbar ===== */}
      <nav className="hidden md:block bg-white dark:bg-[#0f172a] border-b border-gray-200 dark:border-gray-800 fixed top-0 w-full z-50 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-20">
            {/* Logo + Brand */}
            <Link to="/" className="flex-shrink-0 flex items-center gap-4 group">
              <div className="w-12 h-12 flex items-center justify-center overflow-hidden">
                <AppLogo className="w-12 h-12 object-contain group-hover:scale-105 transition-transform" />
              </div>
              <span className="text-2xl font-black text-blue-900 dark:text-white tracking-tight">
                CareerGuide
              </span>
            </Link>

            {/* Nav Links */}
            <div className="flex items-center gap-6">
              {navLinks.map((link) => (
                <Link
                  key={link.to}
                  to={link.to}
                  className={`text-base font-bold transition-all duration-200
                    ${location.pathname === link.to
                      ? 'text-blue-700 dark:text-amber-400 border-b-2 border-blue-700 dark:border-amber-400 pb-1'
                      : 'text-gray-600 hover:text-blue-700 dark:text-gray-300 dark:hover:text-amber-400 pb-1'
                    }`}
                >
                  {link.label}
                </Link>
              ))}
            </div>

            <div className="flex items-center gap-4">
              <Link
                to="/settings"
                className="text-gray-500 hover:text-blue-700 dark:text-gray-400 dark:hover:text-amber-400 transition-colors"
                title="Paramètres"
              >
                <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
              </Link>
              <button
                type="button"
                onClick={toggleMode}
                title={isOnline ? 'Passer en mode hors-ligne' : 'Passer en mode en ligne'}
                className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-colors ${isOnline ? 'bg-green-100 text-green-700 dark:bg-green-900/40 dark:text-green-400' : 'bg-gray-200 text-gray-700 dark:bg-gray-800 dark:text-gray-400'}`}
              >
                {isOnline ? '🟢 En Ligne' : '⚪ Hors Ligne'}
              </button>
              <button
                type="button"
                onClick={toggleTheme}
                title={theme === 'dark' ? 'Passer au Mode Jour' : 'Passer au Mode Nuit'}
                className="p-2 rounded-xl bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
              >
                {theme === 'dark' ? (
                  <svg className="w-5 h-5 text-amber-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                  </svg>
                ) : (
                  <svg className="w-5 h-5 text-blue-900" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                  </svg>
                )}
              </button>
            </div>
          </div>
        </div>
      </nav>

      {/* ===== Mobile Top Bar ===== */}
      <div className="md:hidden fixed top-0 left-0 right-0 bg-white dark:bg-[#0f172a] border-b border-gray-200 dark:border-gray-800 h-16 z-50 flex items-center justify-between px-4 shadow-sm">
        <Link to="/" className="flex items-center gap-3">
          <div className="w-10 h-10 flex items-center justify-center overflow-hidden">
            <AppLogo className="w-10 h-10 object-contain" />
          </div>
          <span className="text-xl font-black text-blue-900 dark:text-white tracking-tight">
            CareerGuide
          </span>
        </Link>
        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={toggleMode}
            className={`px-2 py-1 rounded-lg text-[10px] font-bold ${isOnline ? 'bg-green-100 text-green-700 dark:bg-green-900/40 dark:text-green-400' : 'bg-gray-200 text-gray-700 dark:bg-gray-800 dark:text-gray-400'}`}
          >
            {isOnline ? '🟢 En Ligne' : '⚪ Hors Ligne'}
          </button>
          <button
            type="button"
            onClick={toggleTheme}
            className="p-2 rounded-lg bg-gray-100 dark:bg-gray-800"
          >
          {theme === 'dark' ? (
            <svg className="w-5 h-5 text-amber-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
          ) : (
            <svg className="w-5 h-5 text-blue-900" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
            </svg>
          )}
        </button>
        </div>
      </div>

      {/* ===== Mobile Bottom Navigation Bar ===== */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-[#0f172a] border-t border-gray-200 dark:border-gray-800 z-50 px-2 pb-safe shadow-[0_-4px_10px_rgba(0,0,0,0.05)]">
        <div className="flex justify-around items-center h-16">
          {navLinks.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              className={`flex flex-col items-center justify-center flex-1 py-1 transition-all
                ${location.pathname === link.to
                  ? 'text-blue-700 dark:text-amber-400'
                  : 'text-gray-500 hover:text-blue-600'
                }`}
            >
              <span className={`text-[10px] mt-1 font-bold tracking-tight uppercase`}>
                {link.label}
              </span>
            </Link>
          ))}
          <Link
            to="/settings"
            className={`flex flex-col items-center justify-center flex-1 py-1 transition-all ${location.pathname === '/settings' ? 'text-blue-700 dark:text-amber-400' : 'text-gray-500'}`}
          >
            <span className={`text-[10px] mt-1 font-bold tracking-tight uppercase`}>
              Paramètres
            </span>
          </Link>
        </div>
      </nav>
    </>
  );
}
