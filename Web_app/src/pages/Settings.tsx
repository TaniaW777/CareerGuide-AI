

import { useOfflineStore } from '../store/useOfflineStore';

export default function Settings() {
  const { theme, toggleTheme } = useOfflineStore();

  return (
    <div className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">Paramètres</h1>
      
      <div className="space-y-6">
        <section className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden">
          <div className="p-6 border-b border-gray-100 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">Apparence</h2>
          </div>
          <div className="p-6 space-y-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="font-semibold text-gray-900 dark:text-white">Mode Sombre</p>
                <p className="text-sm text-gray-500 dark:text-gray-400">Activer le thème sombre pour l'application</p>
              </div>
              <button 
                onClick={toggleTheme}
                className={`w-12 h-6 rounded-full relative transition-colors ${theme === 'dark' ? 'bg-indigo-600' : 'bg-gray-300'}`}
              >
                <span className={`absolute top-1 w-4 h-4 bg-white rounded-full shadow-sm transition-all ${theme === 'dark' ? 'right-1' : 'left-1'}`} />
              </button>
            </div>
          </div>
        </section>

        <section className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden">
          <div className="p-6 border-b border-gray-100 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">Données et Confidentialité</h2>
          </div>
          <div className="p-6 space-y-6">
            <div className="flex items-center justify-between text-left">
              <div>
                <p className="font-semibold text-gray-900 dark:text-white">Mode Hors-ligne</p>
                <p className="text-sm text-gray-500 dark:text-gray-400">Gérer le cache des données locales</p>
              </div>
              <button className="px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
                Vider le cache
              </button>
            </div>
            <div className="pt-4 border-t border-gray-100 dark:border-gray-700">
              <button className="text-red-600 dark:text-red-400 font-semibold text-sm hover:underline">
                Supprimer toutes mes données
              </button>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}

