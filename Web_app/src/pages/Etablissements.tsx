import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import { getAllSchools, searchAIInfo } from '../services/localCareerBackend';
import type { School } from '../services/localCareerBackend';
import { ProfileUserIcon } from '../components/Icons';

export default function Etablissements() {
  const { profile } = useOfflineStore();
  const initialLevel = profile?.education === '3ème' ? '3ème' :
                     (profile?.education === 'Université' || profile?.education === 'Supérieur' ? 'Supérieur' : (profile?.education ? 'Terminale' : 'all'));
  const [selectedLevel, setSelectedLevel] = useState<'3ème' | 'Terminale' | 'Supérieur' | 'all'>(initialLevel);
  const [selectedType, setSelectedType] = useState<School['type'] | 'all'>('all');
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [aiResult, setAiResult] = useState<string | null>(null);
  const [isSearchingAI, setIsSearchingAI] = useState(false);

  const schools = getAllSchools();
  
  const filtered = schools.filter(school => {
    const levelMatch = selectedLevel === 'all' || school.level === selectedLevel || (selectedLevel === 'Supérieur' && school.level === 'Terminale');
    const typeMatch = selectedType === 'all' || school.type === selectedType;
    const nameMatch = school.name.toLowerCase().includes(searchQuery.toLowerCase());
    return levelMatch && typeMatch && nameMatch;
  });

  const handleAISearch = async () => {
    if (!searchQuery.trim()) return;
    setIsSearchingAI(true);
    setAiResult(null);
    try {
      const result = await searchAIInfo(searchQuery, 'établissement');
      setAiResult(result);
    } catch (e) {
      setAiResult("Erreur lors de la recherche IA.");
    }
    setIsSearchingAI(false);
  };

  let schoolTypes: School['type'][] = [];
  if (selectedLevel === '3ème') {
    schoolTypes = ['Lycée', 'Collège', 'Lycée Technique', 'Lycée Professionnel', 'Centre de Formation'];
  } else if (selectedLevel === 'Terminale' || selectedLevel === 'Supérieur') {
    schoolTypes = ['Université', 'Institut', 'Centre de Formation', 'Lycée Technique', 'Lycée Professionnel'];
  } else {
    schoolTypes = [
      'Lycée', 'Collège', 'Lycée Technique', 'Lycée Professionnel', 
      'Université', 'Institut', 'Centre de Formation'
    ];
  }

  if (!profile || !profile.name) {
    return (
      <div className="container mx-auto py-20 px-4 text-center">
        <div className="max-w-md mx-auto bg-white dark:bg-gray-800 p-10 rounded-[3rem] shadow-xl border border-gray-100 dark:border-gray-700">
          <div className="text-blue-600 dark:text-blue-400 mb-6 flex justify-center">
            <ProfileUserIcon className="w-14 h-14" />
          </div>
          <h2 className="text-2xl font-black mb-4">Profil incomplet</h2>
          <p className="text-gray-500 dark:text-gray-400 mb-8">Configurez votre profil pour voir les établissements.</p>
          <Link to="/profil" className="inline-block px-8 py-4 bg-blue-700 text-white rounded-2xl font-bold shadow-lg shadow-blue-900/20 hover:bg-blue-800 transition-all">
            Configurer mon profil
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-12 px-4 pb-24">
      <header className="mb-12">
        <h1 className="text-4xl font-black text-gray-900 dark:text-white mb-4 tracking-tight">
          Catalogue des Établissements
        </h1>
        <p className="text-lg text-gray-600 dark:text-gray-400 max-w-3xl">
          Découvrez tous les établissements disponibles au Burkina Faso, filtrez par niveau et type d'établissement.
        </p>
      </header>

      {/* Filtres */}
      <div className="mb-12 space-y-4">
        {/* Filtres Niveau */}
        <div>
          <p className="text-sm font-black text-gray-600 dark:text-gray-400 uppercase tracking-wider mb-3">Niveau</p>
          <div className="flex flex-wrap gap-2">
            {(['all', '3ème', 'Terminale', 'Supérieur'] as const).map(level => (
              <button
                key={level}
                onClick={() => setSelectedLevel(level)}
                className={`px-4 py-2 rounded-lg font-bold transition-all ${
                  selectedLevel === level
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
                }`}
              >
                {level === 'all' ? 'Tous' : `Niveau ${level}`}
              </button>
            ))}
          </div>
        </div>

        {/* Filtres Type */}
        <div>
          <p className="text-sm font-black text-gray-600 dark:text-gray-400 uppercase tracking-wider mb-3">Type d'établissement</p>
          <div className="flex flex-wrap gap-2">
            <button
              onClick={() => setSelectedType('all')}
              className={`px-4 py-2 rounded-lg font-bold transition-all ${
                selectedType === 'all'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200'
              }`}
            >
              Tous
            </button>
            {schoolTypes.map(type => (
              <button
                key={type}
                onClick={() => setSelectedType(type)}
                className={`px-4 py-2 rounded-lg font-bold transition-all text-sm ${
                  selectedType === type
                    ? 'bg-amber-600 text-white'
                    : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200'
                }`}
              >
                {type}
              </button>
            ))}
          </div>
        </div>

        {/* Barre de recherche IA */}
        <div className="mt-8 bg-blue-50 dark:bg-blue-900/20 p-6 rounded-[2rem] border-2 border-blue-100 dark:border-blue-800/50">
          <p className="text-sm font-black text-blue-700 dark:text-blue-400 uppercase tracking-wider mb-3">Recherche IA & Filtrage</p>
          <div className="flex flex-col sm:flex-row gap-3">
            <input 
              type="text" 
              placeholder="Ex: Prytanée Militaire, Université Zinda..." 
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
      </div>

      {/* Liste des établissements */}
      <div className="space-y-4">
        {filtered.length > 0 ? (
          filtered.map((school) => (
            <div
              key={school.name}
              className="bg-white dark:bg-gray-800 rounded-[2rem] border-2 border-gray-100 dark:border-gray-700 overflow-hidden hover:border-blue-500 hover:shadow-xl transition-all cursor-pointer"
              onClick={() => setExpandedId(expandedId === school.name ? null : school.name)}
            >
              <div className="p-6 md:p-8">
                {/* En-tête */}
                <div className="flex items-start justify-between mb-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-3 flex-wrap">
                      <span className="px-3 py-1 text-xs font-black rounded-lg uppercase tracking-wider bg-blue-100 dark:bg-blue-900/40 text-blue-700 dark:text-blue-300">
                        {school.type}
                      </span>
                      <span className="px-3 py-1 text-xs font-black rounded-lg uppercase tracking-wider bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-300">
                        Niveau {school.level}
                      </span>
                      <span className="px-3 py-1 text-xs font-black rounded-lg uppercase tracking-wider bg-green-100 dark:bg-green-900/40 text-green-700 dark:text-green-300">
                        📍 {school.city}
                      </span>
                    </div>
                    <h3 className="text-2xl font-black text-gray-900 dark:text-white">
                      {school.name}
                    </h3>
                  </div>
                  <div className="text-2xl text-gray-400 transition-transform">
                    {expandedId === school.name ? '▼' : '▶'}
                  </div>
                </div>

                {/* Description brève */}
                {school.description && (
                  <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                    {school.description}
                  </p>
                )}

                {/* Programmes */}
                {school.programs && school.programs.length > 0 && (
                  <div className="mb-4">
                    <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Programmes disponibles</p>
                    <div className="flex flex-wrap gap-2">
                      {school.programs.map(prog => (
                        <span key={prog} className="px-3 py-1 text-sm bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 rounded-lg">
                          {prog}
                        </span>
                      ))}
                    </div>
                  </div>
                )}

                {/* Section détails (expanded) */}
                {expandedId === school.name && (
                  <div className="mt-6 pt-6 border-t border-gray-100 dark:border-gray-700 space-y-4 animate-in fade-in slide-in-from-top-2">
                    <div className="grid md:grid-cols-2 gap-4">
                      {school.email && (
                        <div>
                          <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-1">Email</p>
                          <a href={`mailto:${school.email}`} className="text-blue-600 dark:text-blue-400 font-medium hover:underline break-all">
                            {school.email}
                          </a>
                        </div>
                      )}
                      {school.phone && (
                        <div>
                          <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-1">Téléphone</p>
                          <a href={`tel:${school.phone}`} className="text-blue-600 dark:text-blue-400 font-medium hover:underline">
                            {school.phone}
                          </a>
                        </div>
                      )}
                      {school.website && (
                        <div>
                          <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-1">Site web</p>
                          <a href={school.website} target="_blank" rel="noopener noreferrer" className="text-blue-600 dark:text-blue-400 font-medium hover:underline break-all">
                            Visiter le site →
                          </a>
                        </div>
                      )}
                      <div className="md:col-span-2 mt-2">
                        <a 
                          href={school.maps || `https://maps.google.com/?q=${encodeURIComponent(school.name + ' ' + school.city)}`} 
                          target="_blank" 
                          rel="noopener noreferrer" 
                          className="inline-flex items-center gap-2 px-5 py-2.5 bg-green-100 hover:bg-green-200 text-green-800 dark:bg-green-900/40 dark:hover:bg-green-900/60 dark:text-green-300 font-bold rounded-xl transition-all"
                        >
                          <span>📍</span> Voir sur Google Maps
                        </a>
                      </div>
                    </div>

                    {school.programs && school.programs.length > 0 && (
                      <div>
                        <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Tous les programmes</p>
                        <ul className="space-y-2">
                          {school.programs.map(prog => (
                            <li key={prog} className="flex items-start gap-3 text-sm">
                              <span className="text-blue-600 font-bold mt-0.5">✓</span>
                              <span className="text-gray-700 dark:text-gray-300 font-medium">{prog}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          ))
        ) : (
          <div className="text-center py-12">
            <p className="text-gray-500 dark:text-gray-400 text-lg font-medium">
              Aucun établissement ne correspond à vos critères de filtrage.
            </p>
          </div>
        )}
      </div>

      {/* Résumé */}
      <div className="mt-12 p-6 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-[2rem] text-center">
        <p className="text-gray-700 dark:text-gray-300 font-medium">
          <strong className="text-blue-700 dark:text-blue-400">{filtered.length}</strong> établissement(s) trouvé(s)
        </p>
      </div>
    </div>
  );
}
