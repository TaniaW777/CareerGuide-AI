import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { useOfflineStore } from '../store/useOfflineStore';

const interestColors: Record<string, string> = {
  'Technologie': 'bg-blue-100 text-blue-700 dark:bg-blue-900/40 dark:text-blue-300',
  'Art & Design': 'bg-pink-100 text-pink-700 dark:bg-pink-900/40 dark:text-pink-300',
  'Science': 'bg-purple-100 text-purple-700 dark:bg-purple-900/40 dark:text-purple-300',
  'Business': 'bg-green-100 text-green-700 dark:bg-green-900/40 dark:text-green-300',
  'Santé': 'bg-red-100 text-red-700 dark:bg-red-900/40 dark:text-red-300',
  'Social': 'bg-orange-100 text-orange-700 dark:bg-orange-900/40 dark:text-orange-300',
  'Écologie': 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-300',
  'Sport': 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/40 dark:text-yellow-300',
  'Médias': 'bg-violet-100 text-violet-700 dark:bg-violet-900/40 dark:text-violet-300',
};

export default function Profit() {
  const navigate = useNavigate();
  const { profile, clearStorage } = useOfflineStore();
  const [showConfirm, setShowConfirm] = useState(false);

  if (!profile) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-4 bg-gradient-to-br from-indigo-50 via-white to-violet-50 dark:from-gray-950 dark:via-gray-900 dark:to-gray-950">
        <div className="max-w-md w-full bg-white dark:bg-gray-800 rounded-3xl shadow-2xl p-10 text-center border border-gray-100 dark:border-gray-700">
          <div className="w-20 h-20 bg-indigo-100 dark:bg-indigo-900/40 rounded-2xl flex items-center justify-center mx-auto mb-6">
            <svg className="w-10 h-10 text-indigo-600 dark:text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </div>
          <h1 className="text-2xl font-black text-gray-900 dark:text-white mb-3">Aucun profil trouvé</h1>
          <p className="text-gray-500 dark:text-gray-400 mb-8 leading-relaxed">
            Créez votre profil pour obtenir des recommandations personnalisées et suivre votre parcours.
          </p>
          <button
            onClick={() => navigate('/profile-setup')}
            className="w-full px-8 py-4 bg-gradient-to-r from-indigo-600 to-violet-600 text-white rounded-2xl font-bold shadow-xl shadow-indigo-500/20 hover:shadow-indigo-500/40 hover:scale-105 transition-all duration-200"
          >
            Créer mon profil
          </button>
        </div>
      </div>
    );
  }

  const { name, age, education, interests, skills, goals } = profile;
  const initials = name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-violet-50 dark:from-gray-950 dark:via-gray-900 dark:to-gray-950 py-10 px-4">
      <div className="max-w-4xl mx-auto space-y-6">

        {/* Header card */}
        <div className="bg-gradient-to-r from-indigo-600 via-indigo-500 to-violet-600 rounded-3xl p-8 text-white shadow-2xl shadow-indigo-500/30 relative overflow-hidden">
          <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -mr-20 -mt-20 blur-3xl" />
          <div className="absolute bottom-0 left-0 w-48 h-48 bg-black/5 rounded-full -ml-16 -mb-16 blur-2xl" />
          <div className="relative flex items-center gap-6">
            <div className="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center text-3xl font-black ring-4 ring-white/30 flex-shrink-0">
              {initials}
            </div>
            <div className="flex-1">
              <p className="text-indigo-200 text-sm font-semibold uppercase tracking-widest mb-1">Mon Profil CareerGuide</p>
              <h1 className="text-3xl font-black leading-tight">{name}</h1>
              <div className="flex flex-wrap gap-3 mt-3">
                <span className="px-3 py-1 bg-white/20 rounded-full text-sm font-semibold">{education}</span>
                {age && <span className="px-3 py-1 bg-white/20 rounded-full text-sm font-semibold">{age} ans</span>}
              </div>
            </div>
          </div>
        </div>

        {/* Info grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">

          {/* Centres d'intérêt */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-pink-100 dark:bg-pink-900/30 rounded-xl flex items-center justify-center">
                <svg className="w-5 h-5 text-pink-600 dark:text-pink-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                </svg>
              </div>
              <h2 className="text-lg font-bold text-gray-900 dark:text-white">Centres d'intérêt</h2>
            </div>
            {interests.length > 0 ? (
              <div className="flex flex-wrap gap-2">
                {interests.map((interest) => (
                  <span
                    key={interest}
                    className={`px-3 py-1.5 rounded-xl text-sm font-semibold ${interestColors[interest] || 'bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-200'}`}
                  >
                    {interest}
                  </span>
                ))}
              </div>
            ) : (
              <p className="text-gray-400 text-sm italic">Aucun centre d'intérêt sélectionné</p>
            )}
          </div>

          {/* Niveau scolaire */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-indigo-100 dark:bg-indigo-900/30 rounded-xl flex items-center justify-center">
                <svg className="w-5 h-5 text-indigo-600 dark:text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 14l9-5-9-5-9 5 9 5z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z" />
                </svg>
              </div>
              <h2 className="text-lg font-bold text-gray-900 dark:text-white">Niveau scolaire</h2>
            </div>
            <div className="flex items-center gap-3">
              <div className="flex-1">
                <p className="text-2xl font-black text-indigo-600 dark:text-indigo-400">{education}</p>
                {age && <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">{age} ans</p>}
              </div>
            </div>
          </div>

          {/* Compétences */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-green-100 dark:bg-green-900/30 rounded-xl flex items-center justify-center">
                <svg className="w-5 h-5 text-green-600 dark:text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m1.636 6.364l-.707-.707M6.343 6.343l-.707-.707M12 21v-1M6 12a6 6 0 1112 0A6 6 0 016 12z" />
                </svg>
              </div>
              <h2 className="text-lg font-bold text-gray-900 dark:text-white">Compétences clés</h2>
            </div>
            <p className="text-gray-700 dark:text-gray-300 whitespace-pre-line leading-relaxed text-sm">
              {skills || <span className="text-gray-400 italic">Non renseigné</span>}
            </p>
          </div>

          {/* Vision */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-violet-100 dark:bg-violet-900/30 rounded-xl flex items-center justify-center">
                <svg className="w-5 h-5 text-violet-600 dark:text-violet-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </div>
              <h2 className="text-lg font-bold text-gray-900 dark:text-white">Vision à 5 ans</h2>
            </div>
            <p className="text-gray-700 dark:text-gray-300 whitespace-pre-line leading-relaxed text-sm">
              {goals || <span className="text-gray-400 italic">Non renseigné</span>}
            </p>
          </div>
        </div>

        {/* Actions */}
        <div className="flex flex-col sm:flex-row gap-4">
          <button
            onClick={() => navigate('/profile-setup')}
            className="flex-1 flex items-center justify-center gap-2 px-6 py-4 bg-indigo-600 text-white rounded-2xl font-bold hover:bg-indigo-700 shadow-xl shadow-indigo-500/20 transition-all hover:scale-105"
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
            </svg>
            Modifier le profil
          </button>
          <button
            onClick={() => navigate('/recommendations')}
            className="flex-1 flex items-center justify-center gap-2 px-6 py-4 bg-green-600 text-white rounded-2xl font-bold hover:bg-green-700 shadow-xl shadow-green-500/20 transition-all hover:scale-105"
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
            Voir mes recommandations
          </button>
          {!showConfirm ? (
            <button
              onClick={() => setShowConfirm(true)}
              className="flex items-center justify-center gap-2 px-6 py-4 bg-gray-100 dark:bg-gray-800 text-red-500 dark:text-red-400 rounded-2xl font-semibold hover:bg-red-50 dark:hover:bg-red-900/20 transition-all"
            >
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
              Réinitialiser
            </button>
          ) : (
            <div className="flex gap-2">
              <button
                onClick={() => { clearStorage(); navigate('/'); }}
                className="px-4 py-4 bg-red-600 text-white rounded-2xl font-bold hover:bg-red-700 transition-all"
              >
                Confirmer
              </button>
              <button
                onClick={() => setShowConfirm(false)}
                className="px-4 py-4 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-200 rounded-2xl font-bold transition-all"
              >
                Annuler
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
