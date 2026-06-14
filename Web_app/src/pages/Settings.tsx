

import { useOfflineStore } from '../store/useOfflineStore';

export default function Settings() {
  const { theme, setTheme, clearStorage, aiEngineStatus, isOnline, setOnlineStatus, setForcedOffline, setOfflineStatus } = useOfflineStore();

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
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">État du Moteur IA (Architecture Hybride)</h2>
          </div>
          <div className="p-6 space-y-4">
            <p className="text-sm text-gray-500 dark:text-gray-400">
              L'application utilise une architecture "Offline-First". Elle tente d'abord de se connecter à votre IA locale (Ollama), puis bascule sur le Cloud (Groq), et enfin sur un mode hors-ligne restreint en cas de besoin.
            </p>
            <div className="rounded-2xl border border-gray-100 dark:border-gray-700 bg-gray-50 dark:bg-gray-900 p-4 flex flex-col gap-2">
              <span className="text-sm font-bold text-gray-700 dark:text-gray-300">Statut Actuel du Conseiller IA :</span>
              <span className={`px-4 py-2 rounded-lg font-black text-xs uppercase tracking-widest inline-block text-center
                ${aiEngineStatus === 'ollama' ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400' : ''}
                ${aiEngineStatus === 'groq' ? 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400' : ''}
                ${aiEngineStatus === 'offline' ? 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400' : ''}
                ${aiEngineStatus === 'checking' ? 'bg-gray-200 text-gray-600 dark:bg-gray-700 dark:text-gray-400' : ''}
              `}>
                {aiEngineStatus === 'ollama' && '🟢 Ollama (Local)'}
                {aiEngineStatus === 'groq' && '🔵 Groq (Cloud)'}
                {aiEngineStatus === 'offline' && '🟠 Mode Hors-Ligne'}
                {aiEngineStatus === 'checking' && '⚪ En attente...'}
              </span>
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

            {/* Connexion/Déconnexion */}
            <div className="p-6 border-t border-gray-100 dark:border-gray-700">
              <h2 className="text-xl font-bold text-gray-900 dark:text-white">Connexion</h2>
              <div className="mt-4 flex items-center space-x-4">
                <span className={`px-3 py-1 rounded ${isOnline ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400'}`}>
                  {isOnline ? '🟢 En ligne' : '🔴 Hors ligne'}
                </span>
                <button
                  type="button"
                  onClick={() => {
                    const newStatus = !isOnline;
                    setOnlineStatus(newStatus);
                    setForcedOffline(!newStatus);
                    setOfflineStatus(!newStatus);
                  }}
                  className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
                >
                  {isOnline ? 'Passer hors‑ligne' : 'Se connecter'}
                </button>
              </div>
            </div>

            <div className="pt-4 border-t border-gray-100 dark:border-gray-700 space-y-4">
              <div>
                <a href="/privacy" className="text-blue-600 dark:text-blue-400 font-semibold text-sm hover:underline">
                  Voir la Politique de Confidentialité
                </a>
              </div>
              <div>
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
          </div>
        </section>
        <section className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden">
          <div className="p-6 border-b border-gray-100 dark:border-gray-700">
            <h2 className="text-xl font-bold text-gray-900 dark:text-white">À propos & Licence</h2>
          </div>
          <div className="p-6 space-y-4">
            <p className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">
              <strong>CareerGuide AI</strong> a été conçu pour aider les élèves et étudiants du Burkina Faso à trouver leur voie, même sans connexion internet, grâce à une IA locale sécurisée.
            </p>
            <p className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">
              Distribué sous <strong>Licence MIT</strong>. Vous êtes libre d'utiliser, copier, modifier et distribuer ce logiciel, sous réserve d'inclure la notice de copyright d'origine.
            </p>
            <div className="pt-4 flex flex-col sm:flex-row gap-4">
              <a href="https://github.com/TaniaW777/CareerGuide-AI" target="_blank" rel="noopener noreferrer" className="text-blue-600 dark:text-blue-400 font-semibold text-sm hover:underline">
                Voir le code source sur GitHub
              </a>
              <a href="https://opensource.org/licenses/MIT" target="_blank" rel="noopener noreferrer" className="text-blue-600 dark:text-blue-400 font-semibold text-sm hover:underline">
                Lire la licence MIT
              </a>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}

