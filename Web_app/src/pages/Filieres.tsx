import { useState } from 'react';
import { useOfflineStore } from '../store/useOfflineStore';
import { getAllPrograms } from '../services/localCareerBackend';
import type { Program } from '../services/localCareerBackend';
import { ProfileUserIcon } from '../components/Icons';

export default function Filieres() {
  const { profile } = useOfflineStore();
  const [selectedLevel, setSelectedLevel] = useState<'3ème' | 'Terminale' | 'Supérieur' | 'all'>('all');
  const [expandedId, setExpandedId] = useState<string | null>(null);

  const programs = getAllPrograms();
  const filteredPrograms = selectedLevel === 'all' 
    ? programs 
    : programs.filter(p => {
        if (selectedLevel === 'Supérieur') return p.level === 'Terminale' || p.level === 'Supérieur';
        return p.level === selectedLevel;
      });

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
