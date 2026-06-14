import { useState } from 'react';
import { useOfflineStore } from '../store/useOfflineStore';
import { getAllPrograms, searchAIInfo } from '../services/localCareerBackend';
// import type { Program } from '../services/localCareerBackend';
import { ProfileUserIcon } from '../components/Icons';

export default function Filieres() {
  const { profile } = useOfflineStore();
  const initialLevel = profile?.education === '3ème' ? '3ème' :
                     (profile?.education === 'Université' || profile?.education === 'Supérieur' ? 'Supérieur' : (profile?.education ? 'Terminale' : 'all'));
  const [selectedLevel, setSelectedLevel] = useState<'3ème' | 'Terminale' | 'Supérieur' | 'all'>(initialLevel);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [aiResult, setAiResult] = useState<string | null>(null);
  const [isSearchingAI, setIsSearchingAI] = useState(false);

  const programs = getAllPrograms();
  const filteredPrograms = programs.filter(p => {
    const levelMatch = selectedLevel === 'all' 
      ? true 
      : (selectedLevel === 'Supérieur' ? (p.level === 'Terminale' || p.level === 'Supérieur') : p.level === selectedLevel);
    const nameMatch = p.name.toLowerCase().includes(searchQuery.toLowerCase());
    return levelMatch && nameMatch;
  });

  const handleAISearch = async () => {
    if (!searchQuery.trim()) return;
    setIsSearchingAI(true);
    setAiResult(null);
    try {
      const result = await searchAIInfo(searchQuery, 'filière');
      setAiResult(result);
    } catch (e) {
      setAiResult("Erreur lors de la recherche IA.");
    }
    setIsSearchingAI(false);
  };

  if (!profile || !profile.name) {
    return (
      <div className="container mx-auto py-20 px-4 text-center">
        <div className="max-w-md mx-auto bg-white dark:bg-gray-800 p-10 rounded-[3rem] shadow-xl border border-gray-100 dark:border-gray-700">
          <div className="text-blue-600 dark:text-blue-400 mb-6 flex justify-center">
            <ProfileUserIcon className="w-14 h-14" />
          </div>
          <h2 className="text-2xl font-black mb-4">Profil incomplet</h2>
          <p className="text-gray-500 dark:text-gray-400 mb-8">Configurez votre profil pour explorer les filières.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-12 px-4 pb-24">
      <header className="mb-12">
        <h1 className="text-4xl font-black text-gray-900 dark:text-white mb-4 tracking-tight">
          Filières & Séries au Burkina Faso
        </h1>
        <p className="text-lg text-gray-600 dark:text-gray-400 max-w-3xl">
          Découvrez toutes les filières disponibles, leurs débouchés professionnels et les compétences requises.
        </p>
      </header>

      {/* Filtres par niveau */}
      <div className="mb-12 flex flex-wrap gap-3">
        {(['all', '3ème', 'Terminale', 'Supérieur'] as const).map(level => (
          <button
            key={level}
            onClick={() => setSelectedLevel(level)}
            className={`px-6 py-3 rounded-full font-bold transition-all ${
              selectedLevel === level
                ? 'bg-blue-600 text-white shadow-lg'
                : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
            }`}
          >
            {level === 'all' ? 'Toutes les filières' : `Niveau ${level}`}
          </button>
        ))}
      </div>

      {/* Barre de recherche IA */}
      <div className="mb-12 bg-blue-50 dark:bg-blue-900/20 p-6 rounded-[2rem] border-2 border-blue-100 dark:border-blue-800/50">
        <p className="text-sm font-black text-blue-700 dark:text-blue-400 uppercase tracking-wider mb-3">Recherche IA & Filtrage</p>
        <div className="flex flex-col sm:flex-row gap-3">
          <input 
            type="text" 
            placeholder="Ex: Informatique, Médecine, Droit..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="flex-1 px-4 py-3 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 outline-none"
          />
          <button 
            onClick={handleAISearch}
            disabled={isSearchingAI || !searchQuery.trim()}
            className="px-6 py-3 bg-blue-600 text-white font-bold rounded-xl hover:bg-blue-700 transition-colors disabled:opacity-50"
          >
            {isSearchingAI ? 'Recherche IA...' : 'Chercher avec l\'IA'}
          </button>
        </div>
        {aiResult && (
          <div className="mt-4 p-4 bg-white dark:bg-gray-800 rounded-xl border border-blue-200 dark:border-blue-700 text-gray-700 dark:text-gray-300 text-sm">
            <strong className="text-blue-600 dark:text-blue-400 block mb-1">Résultat de l'IA :</strong>
            {aiResult}
          </div>
        )}
      </div>

      {/* Grille des filières */}
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredPrograms.map(program => (
          <div
            key={program.id}
            className="bg-white dark:bg-gray-800 rounded-[2rem] border-2 border-gray-100 dark:border-gray-700 overflow-hidden hover:border-blue-500 hover:shadow-xl transition-all group cursor-pointer"
            onClick={() => setExpandedId(expandedId === program.id ? null : program.id)}
          >
            <div className="p-6">
              {/* En-tête */}
              <div className="flex items-start justify-between mb-4">
                <div className="flex-1">
                  <span className="inline-block px-3 py-1 text-xs font-black rounded-lg uppercase tracking-wider mb-3
                    ${program.type === 'Série' ? 'bg-purple-100 text-purple-700 dark:bg-purple-900/40' : ''}
                    ${program.type === 'CAP/BEP' ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40' : ''}
                    ${program.type === 'Licence' ? 'bg-amber-100 text-amber-700 dark:bg-amber-900/40' : ''}
                  ">
                    {program.type} - Niveau {program.level}
                  </span>
                  <h3 className="text-xl font-black text-gray-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                    {program.name}
                  </h3>
                </div>
                <div className="text-2xl group-hover:scale-110 transition-transform">
                  {expandedId === program.id ? '▼' : '▶'}
                </div>
              </div>

              {/* Description */}
              {program.description && (
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  {program.description}
                </p>
              )}

              {/* Compétences */}
              <div className="mb-4">
                <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Compétences</p>
                <div className="flex flex-wrap gap-2">
                  {program.competences.slice(0, 3).map(comp => (
                    <span
                      key={comp}
                      className="px-2 py-1 text-xs bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 rounded-lg"
                    >
                      {comp}
                    </span>
                  ))}
                  {program.competences.length > 3 && (
                    <span className="px-2 py-1 text-xs text-gray-500">+{program.competences.length - 3}</span>
                  )}
                </div>
              </div>

              {/* Section détaillée (expansion) */}
              {expandedId === program.id && (
                <div className="mt-6 pt-6 border-t border-gray-100 dark:border-gray-700 space-y-4 animate-in fade-in slide-in-from-top-2">
                  <div>
                    <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Toutes les compétences</p>
                    <div className="flex flex-wrap gap-2">
                      {program.competences.map(comp => (
                        <span
                          key={comp}
                          className="px-3 py-1.5 text-sm bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 rounded-lg font-medium"
                        >
                          {comp}
                        </span>
                      ))}
                    </div>
                  </div>

                  <div>
                    <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Débouchés professionnels</p>
                    <ul className="space-y-2">
                      {program.debouches.map(job => (
                        <li key={job} className="flex items-start gap-3 text-sm">
                          <span className="text-green-500 font-bold mt-0.5">✓</span>
                          <span className="text-gray-700 dark:text-gray-300 font-medium">{job}</span>
                        </li>
                      ))}
                    </ul>
                  </div>

                  {program.universites && program.universites.length > 0 && (
                    <div className="pt-4 border-t border-gray-100 dark:border-gray-700">
                      <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Où se former ?</p>
                      <div className="flex flex-wrap gap-2">
                        {program.universites.map(uni => (
                          <span key={uni} className="px-2 py-1 text-xs font-medium bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-300 rounded-lg">
                            {uni}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        ))}
      </div>

      {filteredPrograms.length === 0 && (
        <div className="text-center py-12">
          <p className="text-gray-500 dark:text-gray-400 text-lg font-medium">Aucune filière disponible pour ce niveau.</p>
        </div>
      )}
    </div>
  );
}
