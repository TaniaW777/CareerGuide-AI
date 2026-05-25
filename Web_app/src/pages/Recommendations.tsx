

import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import { useOfflineStore } from '../store/useOfflineStore';

interface Recommendation {
  program: string;
  score: number;
  schools: { name: string; city: string }[];
}

export default function Recommendations() {
  const { profile } = useOfflineStore();
  const [recommendations, setRecommendations] = useState<Recommendation[]>([]);
  const [analysis, setAnalysis] = useState('');
  const [enhancedAnalysis, setEnhancedAnalysis] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isLoadingEnhanced, setIsLoadingEnhanced] = useState(false);
  const [error, setError] = useState('');

  // Fetch initial recommendations (fast)
  useEffect(() => {
    const fetchRecommendations = async () => {
      if (!profile || !profile.name) return;

      setIsLoading(true);
      setError('');
      try {
        const backendUrl = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000';
      const response = await axios.post(`${backendUrl}/recommend/`, {
          first_name: profile.name,
          class_level: profile.education || '3ème',
          interests: profile.interests,
          favorite_subjects: (profile.skills || '').split(',').map(s => s.trim())
        });

        setRecommendations(response.data.recommendations);
        setAnalysis(response.data.analysis);
        
        // Fetch enhanced analysis in background
        setIsLoadingEnhanced(true);
        try {
          const enhancedResponse = await axios.post(`${backendUrl}/recommend/analysis/enhanced`, {
            first_name: profile.name,
            class_level: profile.education || '3ème',
            interests: profile.interests,
            favorite_subjects: (profile.skills || '').split(',').map(s => s.trim())
          });
          setEnhancedAnalysis(enhancedResponse.data.analysis);
        } catch (enhancedError) {
          console.error('Erreur analyse améliorée:', enhancedError);
          // Keep the initial analysis
        } finally {
          setIsLoadingEnhanced(false);
        }
      } catch (err) {
        console.error('Erreur recommendations:', err);
        setError('Impossible de charger les recommandations. Vérifiez que le serveur est lancé.');
      } finally {
        setIsLoading(false);
      }
    };

    fetchRecommendations();
  }, [profile]);

  if (!profile || !profile.name) {
    return (
      <div className="container mx-auto py-20 px-4 text-center">
        <div className="max-w-md mx-auto bg-white dark:bg-gray-800 p-10 rounded-[3rem] shadow-xl border border-gray-100 dark:border-gray-700">
          <div className="text-6xl mb-6">👤</div>
          <h2 className="text-2xl font-black mb-4">Profil incomplet</h2>
          <p className="text-gray-500 dark:text-gray-400 mb-8">Vous devez d'abord configurer votre profil pour obtenir des recommandations personnalisées.</p>
          <Link to="/profile-setup" className="inline-block px-8 py-4 bg-indigo-600 text-white rounded-2xl font-bold shadow-lg shadow-indigo-500/20">
            Configurer mon profil
          </Link>
        </div>
      </div>
    );
  }

  // Show current analysis (initial or enhanced if available)
  const displayedAnalysis = enhancedAnalysis || analysis;

  return (
    <div className="container mx-auto py-12 px-4 pb-24">
      <header className="mb-12 text-center md:text-left">
        <h1 className="text-4xl font-black text-gray-900 dark:text-white mb-4 tracking-tight">Vos Recommandations</h1>
        <p className="text-lg text-gray-600 dark:text-gray-400 font-medium max-w-2xl">
          Basé sur votre profil d'élève en <span className="text-indigo-600 font-bold">{profile.education}</span>, 
          voici les filières qui correspondent le mieux à vos talents.
        </p>
      </header>

      {isLoading ? (
        <div className="flex flex-col items-center justify-center py-20">
          <div className="w-16 h-16 border-4 border-indigo-600 border-t-transparent rounded-full animate-spin mb-4" />
          <p className="text-indigo-600 font-bold animate-pulse text-lg">Chargement de vos recommandations...</p>
        </div>
      ) : error ? (
        <div className="p-8 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-3xl border border-red-100 dark:border-red-800 text-center font-bold">
          {error}
        </div>
      ) : (
        <div className="space-y-12">
          {displayedAnalysis && (
            <div className={`bg-indigo-600 rounded-[2.5rem] p-8 md:p-12 text-white relative overflow-hidden shadow-2xl animate-in fade-in slide-in-from-top-4 duration-700 ${isLoadingEnhanced ? 'opacity-75' : ''}`}>
              <div className="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 bg-white/10 rounded-full blur-3xl" />
              <div className="relative z-10">
                <div className="flex items-center gap-4 mb-6">
                  <div className="w-14 h-14 bg-white/20 rounded-2xl flex items-center justify-center text-3xl">🤖</div>
                  <div>
                    <h2 className="text-2xl font-black">L'analyse de l'IA</h2>
                    <p className="text-indigo-100 font-medium">{isLoadingEnhanced ? 'Amélioration en cours...' : 'Conseils personnalisés'}</p>
                  </div>
                </div>
                <p className="text-lg md:text-xl font-medium leading-relaxed italic">
                  "{displayedAnalysis}"
                </p>
              </div>
            </div>
          )}

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {recommendations.map((career, i) => (
              <div 
                key={career.program} 
                className="bg-white dark:bg-gray-800 rounded-[2rem] border-2 border-transparent hover:border-indigo-500 overflow-hidden hover:shadow-2xl transition-all group animate-in fade-in slide-in-from-bottom-8 duration-500"
                style={{ animationDelay: `${i * 100}ms` }}
              >
                <div className="p-8">
                  <div className="flex items-center justify-between mb-6">
                    <span className="text-4xl">🎓</span>
                    <span className="px-4 py-1.5 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 text-sm font-black rounded-full uppercase tracking-tighter">
                      {Math.round(career.score * 100)}% Match
                    </span>
                  </div>
                  <h3 className="text-2xl font-black text-gray-900 dark:text-white mb-4 group-hover:text-indigo-600 transition-colors">
                    {career.program}
                  </h3>
                  
                  <div className="space-y-4 mb-8">
                    <p className="text-xs font-black text-gray-400 uppercase tracking-widest">Établissements suggérés :</p>
                    <div className="flex flex-wrap gap-2">
                      {career.schools.slice(0, 3).map(school => (
                        <span key={school.name} className="px-3 py-1.5 bg-gray-50 dark:bg-gray-900 text-gray-600 dark:text-gray-300 text-xs font-bold rounded-xl border border-gray-100 dark:border-gray-700">
                          {school.name}
                        </span>
                      ))}
                      {career.schools.length > 3 && (
                        <span className="text-xs text-gray-400 font-bold flex items-center">+{career.schools.length - 3} autres</span>
                      )}
                    </div>
                  </div>

                  <Link
                    to="/chat"
                    className="block w-full text-center py-4 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 font-black rounded-2xl hover:bg-indigo-600 hover:text-white transition-all shadow-sm active:scale-95"
                  >
                    En discuter avec l'IA
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}


