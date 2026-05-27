import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import { getRecommendationsForProfile } from '../services/localCareerBackend';
import type { Recommendation, Scholarship } from '../services/localCareerBackend';
import { ProfileUserIcon, RobotIcon, GraduationIcon } from '../components/Icons';

export default function Recommendations() {
  const { profile } = useOfflineStore();
  const [recommendations, setRecommendations] = useState<Recommendation[]>([]);
  const [scholarships, setScholarships] = useState<Scholarship[]>([]);
  const [analysis, setAnalysis] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchRecommendations = async () => {
      if (!profile || !profile.name) return;

      setIsLoading(true);
      setError('');
      try {
        const result = getRecommendationsForProfile(profile);
        setRecommendations(result.recommendations);
        setScholarships(result.scholarships);
        setAnalysis(result.analysis);
      } catch (err) {
        console.error('Erreur recommendations:', err);
        setError('Impossible de charger les recommandations.');
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
          <div className="text-blue-600 dark:text-blue-400 mb-6 flex justify-center">
            <ProfileUserIcon className="w-14 h-14" />
          </div>
          <h2 className="text-2xl font-black mb-4">Profil incomplet</h2>
          <p className="text-gray-500 dark:text-gray-400 mb-8">Vous devez d'abord configurer votre profil pour obtenir des recommandations personnalisées.</p>
          <Link to="/profil" className="inline-block px-8 py-4 bg-blue-700 text-white rounded-2xl font-bold shadow-lg shadow-blue-900/20 hover:bg-blue-800 transition-all">
            Configurer mon profil
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-12 px-4 pb-24">
      <header className="mb-12 text-center md:text-left">
        <h1 className="text-4xl font-black text-gray-900 dark:text-white mb-4 tracking-tight">Vos Établissements & Recommandations</h1>
        <p className="text-lg text-gray-600 dark:text-gray-400 font-medium max-w-2xl">
          Basé sur votre niveau (<span className="text-blue-700 font-bold dark:text-blue-400">{profile.education}</span>), 
          voici les filières et écoles au Burkina Faso qui vous correspondent.
        </p>
      </header>

      {isLoading ? (
        <div className="flex flex-col items-center justify-center py-20">
          <div className="w-16 h-16 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mb-4" />
          <p className="text-blue-700 font-bold animate-pulse text-lg">Analyse en cours...</p>
        </div>
      ) : error ? (
        <div className="p-8 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-3xl border border-red-100 dark:border-red-800 text-center font-bold">
          {error}
        </div>
      ) : (
        <div className="space-y-12">
          {/* AI Analysis Card */}
          {analysis && (
            <div className="bg-blue-800 rounded-[2.5rem] p-8 md:p-12 text-white relative overflow-hidden shadow-2xl animate-in fade-in slide-in-from-top-4 duration-700">
              <div className="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 bg-amber-400/20 rounded-full blur-3xl" />
              <div className="relative z-10">
                <div className="flex items-center gap-4 mb-6">
                  <div className="w-14 h-14 bg-white/10 rounded-2xl flex items-center justify-center text-amber-400">
                    <RobotIcon className="w-8 h-8" />
                  </div>
                  <div>
                    <h2 className="text-2xl font-black">L'analyse du Conseiller IA</h2>
                    <p className="text-blue-200 font-medium tracking-wide">CONSEILS PERSONNALISÉS</p>
                  </div>
                </div>
                <p className="text-lg md:text-xl font-medium leading-relaxed italic text-white/90">
                  "{analysis}"
                </p>
              </div>
            </div>
          )}

          {/* Recommendations Grid */}
          <div>
            <h2 className="text-2xl font-black text-gray-900 dark:text-white mb-6 flex items-center gap-3">
              <span className="w-8 h-8 rounded-lg bg-blue-100 dark:bg-blue-900/40 text-blue-700 dark:text-blue-400 flex items-center justify-center">🏫</span>
              Filières & Établissements
            </h2>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {recommendations.map((career) => (
                <div 
                  key={career.program} 
                  className="bg-white dark:bg-gray-800 rounded-[2rem] border-2 border-transparent hover:border-blue-500 overflow-hidden hover:shadow-2xl transition-all group animate-in fade-in slide-in-from-bottom-8 duration-500 flex flex-col"
                >
                  <div className="p-8 flex-1 flex flex-col">
                    <div className="flex items-center justify-between mb-4">
                      <span className={`px-3 py-1 text-xs font-black rounded-lg uppercase tracking-widest
                        ${career.type === 'Serie' ? 'bg-purple-100 text-purple-700 dark:bg-purple-900/40 dark:text-purple-300' : ''}
                        ${career.type === 'CAP/BEP' ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-300' : ''}
                        ${career.type === 'Universite' ? 'bg-amber-100 text-amber-700 dark:bg-amber-900/40 dark:text-amber-300' : ''}
                        ${career.type === 'Institut' ? 'bg-pink-100 text-pink-700 dark:bg-pink-900/40 dark:text-pink-300' : ''}
                      `}>
                        {career.type}
                      </span>
                      <span className="px-3 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 text-xs font-black rounded-lg">
                        {Math.round(career.score * 100)}% Match
                      </span>
                    </div>
                    <h3 className="text-xl font-black text-gray-900 dark:text-white mb-4 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                      {career.program}
                    </h3>
                    
                    <div className="mt-auto pt-4 border-t border-gray-100 dark:border-gray-700">
                      <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-3">Établissements :</p>
                      <ul className="space-y-2">
                        {career.schools.map(school => (
                          <li key={school.name} className="flex items-start gap-2 text-sm text-gray-700 dark:text-gray-300 font-medium">
                            <span className="text-blue-500 mt-0.5">•</span>
                            <span>{school.name} <span className="text-gray-400 text-xs">({school.city})</span></span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Scholarships Section */}
          <div className="mt-16">
            <h2 className="text-2xl font-black text-gray-900 dark:text-white mb-6 flex items-center gap-3">
              <span className="w-8 h-8 rounded-lg bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-400 flex items-center justify-center">🎓</span>
              Bourses d'Études (Burkina Faso)
            </h2>
            <div className="grid md:grid-cols-3 gap-6">
              {scholarships.map((scholarship, idx) => (
                <a 
                  key={idx}
                  href={scholarship.link}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="bg-gradient-to-br from-gray-50 to-white dark:from-gray-800 dark:to-gray-900 p-6 rounded-[2rem] border border-gray-200 dark:border-gray-700 hover:border-amber-400 hover:shadow-xl transition-all group"
                >
                  <h3 className="text-xl font-black text-gray-900 dark:text-white mb-2 group-hover:text-amber-600 dark:group-hover:text-amber-400 transition-colors">{scholarship.name}</h3>
                  <p className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-4">{scholarship.provider}</p>
                  <p className="text-sm text-gray-600 dark:text-gray-400 mb-6 leading-relaxed">
                    {scholarship.description}
                  </p>
                  <div className="flex items-center text-amber-600 dark:text-amber-500 text-sm font-bold group-hover:gap-2 transition-all">
                    En savoir plus
                    <svg className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                    </svg>
                  </div>
                </a>
              ))}
            </div>
          </div>

          {/* Chat Link */}
          <div className="mt-12 flex justify-center">
            <Link
              to="/chat"
              className="inline-flex items-center gap-3 px-10 py-5 bg-blue-50 dark:bg-blue-900/20 text-blue-800 dark:text-blue-300 font-black rounded-full hover:bg-blue-100 dark:hover:bg-blue-900/40 transition-all ring-1 ring-blue-200 dark:ring-blue-800"
            >
              <RobotIcon className="w-6 h-6" />
              Discuter de ces choix avec l'IA
            </Link>
          </div>

        </div>
      )}
    </div>
  );
}
