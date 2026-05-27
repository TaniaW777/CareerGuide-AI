

import { useOfflineStore } from '../store/useOfflineStore';

export default function Settings() {
  const { theme, setTheme, clearStorage } = useOfflineStore();

  return (
    <div className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">Paramètres</h1>
      
      <div className="space-y-6">
        <section className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden">
          <div className="p-6 border-b border-gray-100 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">Apparence</h2>
          </div>
          <div className="p-6 space-y-6">
            <div>
              <p className="font-semibold text-gray-900 dark:text-white">Thème de l'application</p>
              <p className="text-sm text-gray-500 dark:text-gray-400">Choisissez le mode jour ou nuit explicitement.</p>
            </div>
            <div className="flex flex-col sm:flex-row gap-3">
              <button
                type="button"
                onClick={() => setTheme('light')}
                className={`flex-1 px-5 py-3 rounded-2xl font-semibold transition-colors border-2 ${theme === 'light' ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-200 border-gray-200 dark:border-gray-700 hover:border-indigo-300'}`}
              >
                Mode Jour
              </button>
              <button
                type="button"
                onClick={() => setTheme('dark')}
                className={`flex-1 px-5 py-3 rounded-2xl font-semibold transition-colors border-2 ${theme === 'dark' ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-200 border-gray-200 dark:border-gray-700 hover:border-indigo-300'}`}
              >
                Mode Nuit
              </button>
            </div>
            <div className="rounded-2xl border border-gray-100 dark:border-gray-700 bg-gray-50 dark:bg-gray-900 p-4">
              <p className="text-sm text-gray-600 dark:text-gray-300">Thème actuel : <span className="font-semibold text-gray-900 dark:text-white">{theme === 'dark' ? 'Nuit' : 'Jour'}</span></p>
            </div>
          </div>
        </section>

        <section className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden">
          <div className="p-6 border-b border-gray-100 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">Données et Confidentialité</h2>
          </div>
          <div className="p-6 space-y-6">
            <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between text-left">
              <div>
                <p className="font-semibold text-gray-900 dark:text-white">Nettoyer les données locales</p>
                <p className="text-sm text-gray-500 dark:text-gray-400">Supprime les informations enregistrées et rafraîchit l'application.</p>
              </div>
              <button
                type="button"
                onClick={() => {
                  clearStorage();
                  window.location.reload();
                }}
                className="px-4 py-3 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 rounded-2xl text-sm font-semibold hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
              >
                Réinitialiser l'application
              </button>
            </div>
            <div className="pt-4 border-t border-gray-100 dark:border-gray-700">
              <button
                type="button"
                onClick={() => {
                  clearStorage();
                  window.location.reload();
                }}
                className="text-red-600 dark:text-red-400 font-semibold text-sm hover:underline"
              >
                Supprimer toutes mes données
              </button>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}

