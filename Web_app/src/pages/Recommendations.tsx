import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import { 
  generateAIRecommendationAnalysis, 
  getDynamicRecommendations,
  getAllPrograms,
  getAllSchools,
  getScholarships,
  generateDynamicQuestions
} from '../services/localCareerBackend';
import type { Recommendation, Program, School } from '../services/localCareerBackend';
import { ProfileUserIcon, RobotIcon } from '../components/Icons';

type FlowState = 'start' | 'level-select' | 'generating-questions' | 'questions' | 'calculating' | 'results';

export default function Recommendations() {
  const { profile } = useOfflineStore();
  const [step, setStep] = useState<FlowState>('start');
  const [selectedLevel, setSelectedLevel] = useState('');
  const [customLevel, setCustomLevel] = useState('');
  const [analysis, setAnalysis] = useState('');
  const [recommendations, setRecommendations] = useState<Recommendation[]>([]);
  const [scholarships, setScholarships] = useState<any[]>([]);
  const [matchingPrograms, setMatchingPrograms] = useState<Program[]>([]);
  const [matchingSchools, setMatchingSchools] = useState<School[]>([]);
  const [dynamicQuestions, setDynamicQuestions] = useState<string[]>([]);
  const [error, setError] = useState('');

  const handleStartAnalysis = () => {
    setStep('level-select');
  };

  const handleLevelSubmit = async () => {
    const finalLevel = selectedLevel === 'Autre' ? customLevel : selectedLevel;
    if (!finalLevel) return;
    
    setError('');
    setStep('generating-questions');
    
    try {
      const questions = await generateDynamicQuestions(finalLevel);
      setDynamicQuestions(questions);
      setStep('questions');
    } catch (err) {
      console.error(err);
      setError('Impossible de générer les questions. Veuillez réessayer.');
      setStep('level-select');
    }
  };

  

  if (!profile || !profile.name) {
    return (
      <div className="container mx-auto py-20 px-4 text-center">
        <div className="max-w-md mx-auto bg-white dark:bg-gray-800 p-10 rounded-[3rem] shadow-xl border border-gray-100 dark:border-gray-700">
          <div className="text-blue-600 dark:text-blue-400 mb-6 flex justify-center">
            <ProfileUserIcon className="w-14 h-14" />
          </div>
          <h2 className="text-2xl font-black mb-4">Profil incomplet</h2>
          <p className="text-gray-500 dark:text-gray-400 mb-8">Vous devez d'abord configurer votre profil pour obtenir des recommandations.</p>
          <Link to="/profil" className="inline-block px-8 py-4 bg-blue-700 text-white rounded-2xl font-bold shadow-lg shadow-blue-900/20 hover:bg-blue-800 transition-all">
            Configurer mon profil
          </Link>
        </div>
      </div>
    );
  }

  // --- Circular Progress Animation Component (replaces Radar) ---
  const CircularProgress = ({ text, subtext }: { text: string; subtext: string }) => (
    <div className="flex flex-col items-center justify-center py-20 animate-in fade-in duration-1000">
      <div className="relative w-64 h-64 mb-12 flex items-center justify-center">
        {/* Outer Ring */}
        <svg className="absolute w-full h-full -rotate-90 animate-[spin_4s_linear_infinite]" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="2" className="text-blue-100 dark:text-gray-800" />
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="4" strokeDasharray="100 180" className="text-blue-500 drop-shadow-[0_0_8px_rgba(59,130,246,0.5)]" />
        </svg>
        
        {/* Middle Ring */}
        <svg className="absolute w-48 h-48 rotate-90 animate-[spin_3s_linear_infinite_reverse]" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="2" className="text-amber-100 dark:text-gray-800" />
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="6" strokeDasharray="80 200" className="text-amber-400 drop-shadow-[0_0_8px_rgba(251,191,36,0.5)]" />
        </svg>

        {/* Inner Ring */}
        <svg className="absolute w-32 h-32 animate-[spin_2s_linear_infinite]" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="2" className="text-purple-100 dark:text-gray-800" />
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="4" strokeDasharray="150 130" className="text-purple-500 drop-shadow-[0_0_8px_rgba(168,85,247,0.5)]" />
        </svg>

        {/* Core Icon */}
        <div className="relative z-10 w-20 h-20 bg-white dark:bg-gray-900 rounded-full shadow-[0_0_30px_rgba(59,130,246,0.3)] flex items-center justify-center">
          <div className="absolute inset-0 bg-blue-500 rounded-full animate-ping opacity-20"></div>
          <RobotIcon className="w-10 h-10 text-blue-500" />
        </div>
      </div>
      <h2 className="text-2xl md:text-3xl font-black text-gray-900 dark:text-white mb-2 tracking-tight">
        {text}
      </h2>
      <p className="text-blue-600 dark:text-blue-400 font-bold uppercase tracking-widest text-sm animate-pulse">
        {subtext}
      </p>
    </div>
  );

  // --- Dynamic Questionnaire Component ---
  const Questionnaire = ({ questions, onSubmit }: { questions: string[], onSubmit: (combined: string) => void }) => {
    const [answers, setAnswers] = useState<string[]>(new Array(questions.length).fill(''));

    const handleAnswerChange = (index: number, value: string) => {
      const newAnswers = [...answers];
      newAnswers[index] = value;
      setAnswers(newAnswers);
    };

    const handleSubmit = () => {
      const combined = questions.map((q, i) => `Q: ${q} | R: ${answers[i]}`).join('\n');
      onSubmit(combined);
    };

    const canSubmit = answers.every(a => a.trim().length > 2);

    return (
      <div className="space-y-8">
        {questions.map((q, idx) => (
          <div key={idx} className="animate-in fade-in slide-in-from-right-4" style={{ animationDelay: \`\${idx * 150}ms\` }}>
            <label className="block font-bold text-gray-800 dark:text-gray-200 mb-3 text-lg">
              {idx + 1}. {q}
            </label>
            <textarea 
              value={answers[idx]} 
              onChange={(e) => handleAnswerChange(idx, e.target.value)} 
              placeholder="Votre réponse..." 
              className="w-full px-5 py-4 rounded-xl border-2 border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 text-gray-900 dark:text-white focus:border-blue-500 outline-none transition-colors resize-none h-24"
            />
          </div>
        ))}

        <div className="pt-4">
          <button disabled={!canSubmit} onClick={handleSubmit} className="w-full py-4 bg-amber-500 hover:bg-amber-600 disabled:opacity-50 text-white font-black rounded-2xl transition-all shadow-[0_10px_20px_rgba(245,158,11,0.3)] text-lg">
            Analyser mes réponses
          </button>
        </div>
      </div>
    );
  };

  return (
    <div className="container mx-auto py-12 px-4 pb-24">
      
      {/* Dynamic Header */}
      {step !== 'start' && step !== 'results' && (
        <header className="mb-12 text-center animate-in slide-in-from-top-4">
          <h1 className="text-4xl font-black text-gray-900 dark:text-white mb-4 tracking-tight">Partie 1 : Analyse IA</h1>
          <p className="text-lg text-gray-600 dark:text-gray-400 font-medium max-w-2xl mx-auto">
            Laissez l'intelligence artificielle guider votre avenir.
          </p>
        </header>
      )}

      {error && (
        <div className="max-w-2xl mx-auto p-6 mb-8 bg-red-50 text-red-600 rounded-2xl border border-red-100 text-center font-bold">
          {error}
        </div>
      )}

      {/* --- START SCREEN --- */}
      {step === 'start' && (
        <div className="max-w-4xl mx-auto animate-in fade-in zoom-in-95 duration-500">
          <div className="text-center mb-16">
            <h1 className="text-5xl font-black text-gray-900 dark:text-white mb-6 tracking-tight">
              Parcours de Recommandation
            </h1>
            <p className="text-xl text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
              Un processus interactif en deux étapes pour trouver la filière idéale.
            </p>
          </div>

          <div className="grid md:grid-cols-2 gap-8">
            {/* Card 1: Analyse IA */}
            <button 
              onClick={handleStartAnalysis}
              className="text-left bg-gradient-to-br from-blue-600 to-indigo-800 p-10 rounded-[3rem] shadow-2xl hover:scale-105 hover:shadow-blue-900/30 transition-all duration-300 relative overflow-hidden group"
            >
              <div className="absolute -right-10 -top-10 w-48 h-48 bg-white/10 rounded-full blur-2xl group-hover:scale-150 transition-transform duration-700"></div>
              <div className="relative z-10">
                <span className="inline-block px-4 py-1.5 bg-white/20 text-white rounded-full text-sm font-black uppercase tracking-wider mb-6">Étape 1</span>
                <h2 className="text-3xl font-black text-white mb-4">Analyse IA</h2>
                <p className="text-blue-100 text-lg leading-relaxed mb-8">
                  Définissez votre niveau et laissez le Conseiller IA vous poser des questions sur-mesure pour affiner vos envies.
                </p>
                <div className="flex items-center text-white font-bold gap-2 group-hover:gap-4 transition-all">
                  Commencer l'analyse
                  <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 5l7 7m0 0l-7 7m7-7H3" /></svg>
                </div>
              </div>
            </button>

            {/* Card 2: Recommendations (Locked) */}
            <div className="bg-gray-100 dark:bg-gray-800 p-10 rounded-[3rem] border-2 border-dashed border-gray-300 dark:border-gray-700 opacity-60 flex flex-col justify-center items-center text-center">
              <div className="w-16 h-16 bg-gray-200 dark:bg-gray-700 rounded-2xl flex items-center justify-center mb-6 text-gray-400 dark:text-gray-500">
                <svg className="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" /></svg>
              </div>
              <h2 className="text-2xl font-black text-gray-500 dark:text-gray-400 mb-2">Partie 2 : Recommandations</h2>
              <p className="text-gray-400 dark:text-gray-500 font-medium">
                Complétez l'analyse IA pour débloquer votre Top 5.
              </p>
            </div>
          </div>
        </div>
      )}

      {/* --- LEVEL SELECT SCREEN --- */}
      {step === 'level-select' && (
        <div className="max-w-2xl mx-auto animate-in fade-in slide-in-from-bottom-8 duration-500">
          <div className="bg-white dark:bg-gray-800 p-10 rounded-[3rem] shadow-xl border border-gray-100 dark:border-gray-700">
            <h2 className="text-2xl font-black text-gray-900 dark:text-white mb-8 text-center">
              Quel est votre niveau actuel ?
            </h2>
            
            <div className="space-y-4 mb-8">
              {['3ème', 'Terminale', 'Autre'].map(level => (
                <button
                  key={level}
                  onClick={() => setSelectedLevel(level)}
                  className={`w-full p-5 rounded-2xl border-2 text-left font-bold text-lg transition-all duration-200 flex items-center justify-between
                    ${selectedLevel === level 
                      ? 'border-blue-600 bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-400' 
                      : 'border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 hover:border-blue-300 dark:hover:border-blue-800'
                    }
                  `}
                >
                  {level === 'Autre' ? 'Autre (à préciser)' : `Classe de ${level}`}
                  {selectedLevel === level && (
                    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7" /></svg>
                  )}
                </button>
              ))}
            </div>

            {selectedLevel === 'Autre' && (
              <div className="mb-8 animate-in fade-in slide-in-from-top-2">
                <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Précisez votre niveau :</label>
                <input 
                  type="text"
                  placeholder="Ex: Bac+2, Licence..."
                  className="w-full px-5 py-4 rounded-xl border-2 border-gray-200 dark:border-gray-700 dark:bg-gray-900 text-gray-900 dark:text-white font-medium focus:border-blue-500 outline-none"
                  value={customLevel}
                  onChange={(e) => setCustomLevel(e.target.value)}
                />
              </div>
            )}

            <button
              onClick={handleLevelSubmit}
              disabled={!selectedLevel || (selectedLevel === 'Autre' && !customLevel)}
              className="w-full py-5 bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white font-black rounded-2xl transition-all shadow-lg text-lg"
            >
              Lancer l'analyse IA
            </button>
          </div>
        </div>
      )}

      {/* --- GENERATING QUESTIONS (Animation) --- */}
      {step === 'generating-questions' && (
        <CircularProgress text="Création de votre questionnaire..." subtext="L'IA prépare des questions adaptées à votre niveau" />
      )}

      {/* --- AI QUESTIONS SCREEN --- */}
      {step === 'questions' && (
            <div className="max-w-3xl mx-auto space-y-8 animate-in fade-in slide-in-from-bottom-8 duration-700">
              <div className="bg-gradient-to-br from-blue-800 to-indigo-900 rounded-[2.5rem] p-8 md:p-12 text-white relative shadow-2xl overflow-hidden">
                <div className="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 bg-amber-400/20 rounded-full blur-3xl" />
                <div className="relative z-10">
                  <div className="flex items-center gap-4 mb-6">
                    <div className="w-14 h-14 bg-white/10 rounded-2xl flex items-center justify-center text-amber-400">
                      <RobotIcon className="w-8 h-8" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-black">Questionnaire instantané</h2>
                      <span className="text-xs font-bold bg-amber-400/20 text-amber-300 px-3 py-1 rounded-full uppercase tracking-wider">Étape 1/2</span>
                    </div>
                  </div>
                  <p className="text-lg md:text-xl font-medium leading-relaxed text-white/90 whitespace-pre-line">
                    {analysis || "Répondez rapidement à ces 4 questions pour que l'IA calcule votre Top 3-5."}
                  </p>
                </div>
              </div>

              <div className="bg-white dark:bg-gray-800 p-8 md:p-10 rounded-[2rem] shadow-xl border border-gray-100 dark:border-gray-700 relative">
                <div className="absolute -top-4 left-10 w-8 h-8 bg-white dark:bg-gray-800 rotate-45 border-l border-t border-gray-100 dark:border-gray-700"></div>
                <label className="block text-gray-700 dark:text-gray-300 font-black mb-4 text-xl">Répondez au Conseiller IA :</label>
                <p className="text-gray-500 dark:text-gray-400 mb-6 font-medium">Répondez le plus naturellement possible pour affiner vos recommandations.</p>

                {/* Questionnaire state */}
                <Questionnaire
                  questions={dynamicQuestions}
                  onSubmit={async (combinedAnswers: string) => {
                    const finalLevel = selectedLevel === 'Autre' ? customLevel : selectedLevel;
                    setStep('calculating');
                    setError('');

                    try {
                      const [aiAnalysis, recs] = await Promise.all([
                        generateAIRecommendationAnalysis(profile!, finalLevel, combinedAnswers),
                        Promise.resolve(getDynamicRecommendations(profile!, combinedAnswers, finalLevel))
                      ]);
                      setAnalysis(aiAnalysis || '');
                      setRecommendations(recs);
                      
                      // Load scholarships, programs, and schools
                      setScholarships(getScholarships() || []);
                      setMatchingPrograms(getAllPrograms(finalLevel).slice(0, 3));
                      setMatchingSchools(getAllSchools(finalLevel).slice(0, 5));
                      
                      setStep('results');
                    } catch (err) {
                      console.error(err);
                      setError('Erreur lors du calcul des recommandations.');
                      setStep('results');
                    }
                  }}
                />
              </div>
            </div>
      )}

      {/* --- CALCULATING RESULTS (Animation) --- */}
      {step === 'calculating' && (
        <CircularProgress text="Analyse en cours..." subtext="Calcul des affinités avec les filières du Burkina Faso" />
      )}

      {/* --- RESULTS SCREEN (Partie 2) --- */}
      {step === 'results' && (
        <div className="animate-in fade-in zoom-in-95 duration-500 space-y-16">
          <div className="text-center mb-16">
            <h1 className="text-4xl md:text-5xl font-black text-gray-900 dark:text-white mb-6 tracking-tight">Partie 2 : Vos Recommandations</h1>
            <p className="text-xl text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
              Voici vos recommandations personnalisées pour votre parcours d'études.
            </p>
          </div>

          {/* Section 1: Filières Recommandées */}
          <section className="space-y-8">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 rounded-2xl flex items-center justify-center text-xl">📚</div>
              <h2 className="text-3xl font-black text-gray-900 dark:text-white">Filières Recommandées</h2>
            </div>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {matchingPrograms.length > 0 ? (
                matchingPrograms.map((prog, idx) => (
                  <div key={idx} className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 hover:shadow-lg transition-all">
                    <div className="flex items-start justify-between mb-3">
                      <span className="text-sm font-black px-3 py-1 bg-blue-100 dark:bg-blue-900/40 text-blue-700 dark:text-blue-300 rounded-lg uppercase tracking-wider">
                        {prog.type}
                      </span>
                      <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Niveau {prog.level}</span>
                    </div>
                    <h3 className="text-xl font-black text-gray-900 dark:text-white mb-2">{prog.name}</h3>
                    <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">{prog.description}</p>
                    <Link to="/filieres" className="text-blue-600 dark:text-blue-400 font-bold text-sm hover:underline">
                      Voir tous les détails →
                    </Link>
                  </div>
                ))
              ) : (
                <p className="text-gray-500 dark:text-gray-400">Aucune filière ne correspond à vos critères.</p>
              )}
            </div>
          </section>

          {/* Section 2: Établissements Recommandés */}
          <section className="space-y-8">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-amber-100 dark:bg-amber-900/40 text-amber-600 dark:text-amber-400 rounded-2xl flex items-center justify-center text-xl">🏫</div>
              <h2 className="text-3xl font-black text-gray-900 dark:text-white">Établissements Recommandés</h2>
            </div>
            <div className="grid md:grid-cols-2 gap-6">
              {matchingSchools.length > 0 ? (
                matchingSchools.map((school, idx) => (
                  <div key={idx} className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 hover:shadow-lg transition-all">
                    <div className="flex items-start justify-between mb-3">
                      <span className="text-sm font-black px-3 py-1 bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-300 rounded-lg uppercase tracking-wider">
                        {school.type}
                      </span>
                      <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">📍 {school.city}</span>
                    </div>
                    <h3 className="text-xl font-black text-gray-900 dark:text-white mb-2">{school.name}</h3>
                    <p className="text-sm text-gray-600 dark:text-gray-400 mb-3">{school.description}</p>
                    {school.email && (
                      <a href={`mailto:${school.email}`} className="text-sm text-blue-600 dark:text-blue-400 hover:underline block mb-2">
                        {school.email}
                      </a>
                    )}
                    <Link to="/etablissements" className="text-blue-600 dark:text-blue-400 font-bold text-sm hover:underline">
                      Voir tous les établissements →
                    </Link>
                  </div>
                ))
              ) : (
                <p className="text-gray-500 dark:text-gray-400">Aucun établissement ne correspond à vos critères.</p>
              )}
            </div>
          </section>

          {/* Section 3: Bourses d'Études */}
          <section className="space-y-8">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-green-100 dark:bg-green-900/40 text-green-600 dark:text-green-400 rounded-2xl flex items-center justify-center text-xl">🎓</div>
              <h2 className="text-3xl font-black text-gray-900 dark:text-white">Bourses d'Études (Burkina Faso)</h2>
            </div>
            <div className="grid md:grid-cols-3 gap-6">
              {scholarships.length > 0 ? (
                scholarships.map((scholarship, idx) => (
                  <a 
                    key={idx}
                    href={scholarship.link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700 hover:shadow-lg hover:border-green-500 transition-all group"
                  >
                    <h3 className="text-lg font-black text-gray-900 dark:text-white mb-2 group-hover:text-green-600 dark:group-hover:text-green-400 transition-colors">
                      {scholarship.name}
                    </h3>
                    <p className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-3">
                      {scholarship.provider}
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400 mb-4 leading-relaxed">
                      {scholarship.description}
                    </p>
                    <div className="flex items-center text-green-600 dark:text-green-400 text-sm font-bold group-hover:gap-2 transition-all">
                      En savoir plus
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                      </svg>
                    </div>
                  </a>
                ))
              ) : (
                <p className="text-gray-500 dark:text-gray-400">Aucune bourse disponible pour le moment.</p>
              )}
            </div>
          </section>

          {/* Section 4: Top 5 Filières (Original recommendations) */}
          <section className="space-y-8 mt-16 pt-16 border-t border-gray-200 dark:border-gray-700">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-purple-100 dark:bg-purple-900/40 text-purple-600 dark:text-purple-400 rounded-2xl flex items-center justify-center text-xl">⭐</div>
              <h2 className="text-3xl font-black text-gray-900 dark:text-white">Votre Top 5</h2>
            </div>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {recommendations.map((career, index) => (
                <div 
                  key={index} 
                  className="bg-white dark:bg-gray-800 rounded-[2.5rem] border border-gray-100 dark:border-gray-700 overflow-hidden hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 relative flex flex-col group"
                >
                  {/* Ranking Badge */}
                  <div className={`absolute top-0 right-0 w-24 h-24 rounded-bl-[100%] flex items-top justify-right pt-5 pr-5 text-2xl font-black transition-colors
                    ${index === 0 ? 'bg-amber-500/10 text-amber-500' : 
                      index === 1 ? 'bg-slate-400/10 text-slate-500' : 
                      index === 2 ? 'bg-orange-700/10 text-orange-700' : 
                      'bg-blue-500/10 text-blue-500'}`}
                  >
                    #{index + 1}
                  </div>
                  
                  <div className="p-8 flex-1 flex flex-col mt-4">
                    <div className="flex items-center justify-between mb-6">
                      <span className="px-4 py-1.5 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-xs font-black rounded-lg uppercase tracking-wider">
                        {career.type}
                      </span>
                      <span className="flex items-center gap-1 text-green-600 dark:text-green-400 font-black bg-green-50 dark:bg-green-900/20 px-3 py-1 rounded-full">
                        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 10V3L4 14h7v7l9-11h-7z" /></svg>
                        {Math.round(career.score * 100)}% Match
                      </span>
                    </div>
                    
                    <h3 className="text-2xl font-black text-gray-900 dark:text-white mb-6 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                      {career.program}
                    </h3>
                    
                    <div className="mt-auto pt-6 border-t border-gray-100 dark:border-gray-700">
                      <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-4">Établissements recommandés :</p>
                      <ul className="space-y-3">
                        {career.schools.map((school, i) => (
                          <li key={i} className="flex items-start gap-3 text-sm text-gray-700 dark:text-gray-300 font-medium">
                            <span className="w-6 h-6 rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 flex items-center justify-center shrink-0 text-xs">🏫</span>
                            <span className="mt-0.5">{school.name} <span className="text-gray-400 text-xs ml-1">({school.city})</span></span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </section>

          <div className="flex justify-center gap-4 mt-16 pt-8 border-t border-gray-200 dark:border-gray-700">
            <button 
              onClick={() => setStep('start')}
              className="px-8 py-4 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 font-bold rounded-2xl hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
            >
              Recommencer l'analyse
            </button>
            <Link 
              to="/filieres"
              className="px-8 py-4 bg-blue-600 text-white font-bold rounded-2xl hover:bg-blue-700 transition-colors shadow-lg shadow-blue-600/20"
            >
              Voir toutes les filières
            </Link>
            <Link 
              to="/etablissements"
              className="px-8 py-4 bg-amber-600 text-white font-bold rounded-2xl hover:bg-amber-700 transition-colors shadow-lg shadow-amber-600/20"
            >
              Voir tous les établissements
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}
