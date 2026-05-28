import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import {
  generateAIRecommendationAnalysis,
  getDynamicRecommendations,
  getScholarships,
  generateDynamicQuestions
} from '../services/localCareerBackend';
import type { Recommendation } from '../services/localCareerBackend';
import { ProfileUserIcon, RobotIcon } from '../components/Icons';

type FlowState = 'idle' | 'generating-questions' | 'questions' | 'calculating' | 'results';

export default function Recommendations() {
  const { profile, analysisHistory, savedRecommendations, savedAnalysis } = useOfflineStore();
  const [step, setStep] = useState<FlowState>('idle');
  const [analysis, setAnalysis] = useState('');
  const [recommendations, setRecommendations] = useState<Recommendation[]>([]);
  const [scholarships, setScholarships] = useState<any[]>([]);
  const [dynamicQuestions, setDynamicQuestions] = useState<string[]>([]);
  const [error, setError] = useState('');

  // Load scholarships on mount
  useEffect(() => {
    setScholarships(getScholarships() || []);
  }, []);

  // Load saved recommendations from store on mount
  useEffect(() => {
    if (savedRecommendations && savedRecommendations.length > 0) {
      setRecommendations(savedRecommendations);
    }
    if (savedAnalysis) {
      setAnalysis(savedAnalysis);
    }
  }, [savedRecommendations, savedAnalysis]);

  const handleStartAnalysis = async () => {
    if (!profile?.education) {
      setError("Veuillez d'abord configurer votre niveau d'études dans votre profil.");
      return;
    }
    setError('');
    setStep('generating-questions');
    try {
      const questions = await generateDynamicQuestions(profile.education);
      setDynamicQuestions(questions);
      setStep('questions');
    } catch (err) {
      console.error(err);
      setError('Impossible de générer les questions. Veuillez réessayer.');
      setStep('idle');
    }
  };

  // --- Profile guard ---
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

  // --- Loading animation component ---
  const CircularProgress = ({ text, subtext, detail }: { text: string; subtext: string; detail?: string }) => (
    <div className="flex flex-col items-center justify-center py-16 animate-in fade-in duration-700">
      <div className="relative w-40 h-40 mb-8 flex items-center justify-center">
        <svg className="absolute w-full h-full -rotate-90 animate-[spin_3s_linear_infinite]" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="2" className="text-blue-100 dark:text-gray-800" />
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="4" strokeDasharray="140 140" className="text-blue-500 drop-shadow-[0_0_12px_rgba(59,130,246,0.6)]" />
        </svg>
        <svg className="absolute w-28 h-28 rotate-90 animate-[spin_2s_linear_infinite_reverse]" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="2" className="text-blue-100 dark:text-gray-800" />
          <circle cx="50" cy="50" r="45" fill="none" stroke="currentColor" strokeWidth="6" strokeDasharray="80 200" className="text-blue-400 drop-shadow-[0_0_10px_rgba(96,165,250,0.6)]" />
        </svg>
        <div className="relative z-10 w-16 h-16 bg-white dark:bg-gray-900 rounded-full shadow-[0_0_20px_rgba(59,130,246,0.2)] flex items-center justify-center">
          <div className="absolute inset-0 bg-blue-500 rounded-full animate-ping opacity-20"></div>
          <span className="text-2xl animate-pulse">✨</span>
        </div>
      </div>
      <h2 className="text-2xl md:text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 mb-3 tracking-tight text-center">
        {text}
      </h2>
      <p className="text-blue-600 dark:text-blue-400 font-bold uppercase tracking-widest text-xs mb-2 animate-pulse text-center">
        {subtext}
      </p>
      {detail && (
        <p className="text-gray-500 dark:text-gray-400 text-sm font-medium mt-2 max-w-md text-center">
          {detail}
        </p>
      )}
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

    const canSubmit = answers.every(a => a.trim().length > 0);

    return (
      <div className="space-y-8">
        {questions.map((q, idx) => (
          <div key={idx} className="animate-in fade-in slide-in-from-right-4" style={{ animationDelay: `${idx * 150}ms` }}>
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

  // Determine display recommendations: from current session or from store
  const displayRecommendations = recommendations.length > 0 ? recommendations : (savedRecommendations || []);

  return (
    <div className="container mx-auto py-12 px-4 pb-24">

      {/* Page Header */}
      <header className="mb-12 text-center animate-in slide-in-from-top-4">
        <h1 className="text-4xl md:text-5xl font-black text-gray-900 dark:text-white mb-4 tracking-tight">
          Recommandation IA
        </h1>
        <p className="text-lg text-gray-600 dark:text-gray-400 font-medium max-w-2xl mx-auto">
          Analyse intelligente, bourses, recommandations et historique — tout au même endroit.
        </p>
      </header>

      {error && (
        <div className="max-w-2xl mx-auto p-6 mb-8 bg-red-50 text-red-600 rounded-2xl border border-red-100 text-center font-bold">
          {error}
        </div>
      )}

      {/* ========================================================= */}
      {/* SECTION 1 : ANALYSE IA                                    */}
      {/* ========================================================= */}
      <section className="max-w-4xl mx-auto mb-16">
        <div className="bg-gradient-to-br from-blue-600 to-indigo-800 rounded-[2.5rem] shadow-2xl overflow-hidden relative">
          <div className="absolute -right-16 -top-16 w-64 h-64 bg-white/10 rounded-full blur-3xl"></div>
          <div className="absolute -left-10 -bottom-10 w-48 h-48 bg-amber-400/10 rounded-full blur-2xl"></div>

          <div className="relative z-10 p-8 md:p-12">
            <div className="flex items-center gap-4 mb-6">
              <div className="w-14 h-14 bg-white/10 rounded-2xl flex items-center justify-center text-amber-400">
                <RobotIcon className="w-8 h-8" />
              </div>
              <div>
                <h2 className="text-2xl md:text-3xl font-black text-white">Analyse IA</h2>
                <span className="text-xs font-bold bg-amber-400/20 text-amber-300 px-3 py-1 rounded-full uppercase tracking-wider">
                  {profile.education || 'Non défini'}
                </span>
              </div>
            </div>

            {/* IDLE state – prompt to start */}
            {step === 'idle' && (
              <div className="animate-in fade-in duration-500">
                <p className="text-blue-100 text-lg leading-relaxed mb-8 max-w-2xl">
                  Répondez à quelques questions personnalisées et laissez l'IA vous recommander les meilleures filières, séries et établissements adaptés à votre profil.
                </p>
                <button
                  onClick={handleStartAnalysis}
                  className="px-8 py-4 bg-white text-blue-700 font-black rounded-2xl hover:bg-blue-50 transition-all shadow-lg hover:shadow-xl hover:scale-105 flex items-center gap-3 text-lg"
                >
                  {savedRecommendations && savedRecommendations.length > 0 ? 'Relancer une analyse' : "Commencer l'analyse"}
                  <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 5l7 7m0 0l-7 7m7-7H3" /></svg>
                </button>
              </div>
            )}

            {/* GENERATING QUESTIONS */}
            {step === 'generating-questions' && (
              <CircularProgress text="Création du questionnaire..." subtext="Préparation de questions adaptées" detail="Environ 15 secondes..." />
            )}

            {/* QUESTIONS */}
            {step === 'questions' && (
              <div className="animate-in fade-in slide-in-from-bottom-8 duration-700">
                <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 mb-8">
                  <p className="text-lg font-medium text-white/90">
                    Répondez rapidement à ces questions pour que l'IA calcule vos recommandations.
                  </p>
                </div>
                <div className="bg-white dark:bg-gray-800 p-8 md:p-10 rounded-[2rem] shadow-xl">
                  <Questionnaire
                    questions={dynamicQuestions}
                    onSubmit={async (combinedAnswers: string) => {
                      const finalLevel = profile!.education;
                      setStep('calculating');
                      setError('');

                      try {
                        const aiAnalysisPromise = generateAIRecommendationAnalysis(profile!, finalLevel, combinedAnswers);
                        const recsPromise = getDynamicRecommendations(profile!, combinedAnswers, finalLevel);
                        
                        const [aiAnalysis, recs] = await Promise.all([
                          aiAnalysisPromise.catch(err => { console.error('Analysis error:', err); return ''; }),
                          recsPromise.catch(err => { console.error('Recommendations error:', err); return [] as any[]; })
                        ]);
                        
                        // Save to offline store
                        const { addAnalysisEntry, saveAIResults } = useOfflineStore.getState();
                        if (aiAnalysis) {
                          addAnalysisEntry({ analysis: aiAnalysis || '', recommendations: recs, timestamp: Date.now() });
                        }
                        saveAIResults(aiAnalysis || '', recs);
                        
                        setAnalysis(aiAnalysis || '');
                        setRecommendations(recs);
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

            {/* CALCULATING */}
            {step === 'calculating' && (
              <CircularProgress text="Analyse en cours..." subtext="Calcul des affinités" detail="Génération de vos recommandations personnalisées..." />
            )}

            {/* RESULTS INLINE */}
            {step === 'results' && (
              <div className="animate-in fade-in duration-500">
                <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 mb-6">
                  <div className="flex items-start gap-4">
                    <div className="text-3xl">🤖</div>
                    <p className="text-white text-lg font-medium italic leading-relaxed">{analysis}</p>
                  </div>
                </div>
                <div className="flex gap-4">
                  <button onClick={() => setStep('idle')} className="px-6 py-3 bg-white/20 text-white font-bold rounded-xl hover:bg-white/30 transition-colors">
                    ✓ Terminé
                  </button>
                  <button onClick={handleStartAnalysis} className="px-6 py-3 bg-amber-500 text-white font-bold rounded-xl hover:bg-amber-600 transition-colors">
                    Relancer une analyse
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      </section>

      {/* ========================================================= */}
      {/* SECTION 2 : RECOMMANDATIONS (from store, always visible)  */}
      {/* ========================================================= */}
      <section className="max-w-4xl mx-auto mb-16 space-y-8">
        <div className="flex items-center gap-4 mb-4">
          <div className="w-12 h-12 bg-purple-100 dark:bg-purple-900/40 text-purple-600 dark:text-purple-400 rounded-2xl flex items-center justify-center text-xl">⭐</div>
          <h2 className="text-3xl font-black text-gray-900 dark:text-white">Recommandations</h2>
          {displayRecommendations.length > 0 && (
            <span className="ml-auto px-4 py-1.5 bg-purple-50 dark:bg-purple-900/20 text-purple-600 dark:text-purple-400 font-bold rounded-full text-sm">
              Top {displayRecommendations.length}
            </span>
          )}
        </div>

        {displayRecommendations.length > 0 ? (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {displayRecommendations.map((career, index) => (
              <div
                key={index}
                className="bg-white dark:bg-gray-800 rounded-[2.5rem] border border-gray-100 dark:border-gray-700 overflow-hidden hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 relative flex flex-col group"
              >
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
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
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
        ) : (
          <div className="p-10 text-center bg-gray-50 dark:bg-gray-800/50 rounded-3xl border border-dashed border-gray-200 dark:border-gray-700">
            <div className="text-4xl mb-4">🎯</div>
            <p className="text-gray-500 dark:text-gray-400 font-medium text-lg">Aucune recommandation pour le moment.</p>
            <p className="text-gray-400 dark:text-gray-500 text-sm mt-2">Lancez une analyse IA ci-dessus pour obtenir vos recommandations personnalisées.</p>
          </div>
        )}
      </section>

      {/* ========================================================= */}
      {/* SECTION 3 : BOURSES D'ÉTUDES (always visible)             */}
      {/* ========================================================= */}
      <section className="max-w-4xl mx-auto mb-16 space-y-8">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-green-100 dark:bg-green-900/40 text-green-600 dark:text-green-400 rounded-2xl flex items-center justify-center text-xl">🎓</div>
            <h2 className="text-3xl font-black text-gray-900 dark:text-white">Bourses d'études</h2>
          </div>
          <span className="px-4 py-1.5 bg-green-50 dark:bg-green-900/20 text-green-600 dark:text-green-400 font-bold rounded-full text-sm">Burkina Faso</span>
        </div>
        <div className="grid md:grid-cols-2 gap-6">
          {scholarships.length > 0 ? (
            scholarships.map((scholarship, idx) => (
              <a
                key={idx}
                href={scholarship.link}
                target="_blank"
                rel="noopener noreferrer"
                className="bg-white dark:bg-gray-800 rounded-3xl p-8 border border-gray-100 dark:border-gray-700 hover:shadow-xl hover:-translate-y-1 transition-all group"
              >
                <h3 className="text-xl font-black text-gray-900 dark:text-white mb-3 group-hover:text-green-600 dark:group-hover:text-green-400 transition-colors">{scholarship.name}</h3>
                <p className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-4">{scholarship.provider}</p>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-6 leading-relaxed line-clamp-3">{scholarship.description}</p>
                <div className="flex items-center text-green-600 dark:text-green-400 text-sm font-bold group-hover:gap-2 transition-all mt-auto">
                  Voir les détails
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
                </div>
              </a>
            ))
          ) : (
            <div className="col-span-2 p-10 text-center bg-gray-50 dark:bg-gray-800/50 rounded-3xl border border-dashed border-gray-200 dark:border-gray-700">
              <p className="text-gray-500 dark:text-gray-400 font-medium">Aucune bourse disponible pour le moment.</p>
            </div>
          )}
        </div>
      </section>

      {/* ========================================================= */}
      {/* SECTION 4 : HISTORIQUE DES RECOMMANDATIONS (always visible)*/}
      {/* ========================================================= */}
      <section className="max-w-4xl mx-auto mb-16 space-y-8">
        <div className="flex items-center gap-4 mb-4">
          <div className="w-12 h-12 bg-indigo-100 dark:bg-indigo-900/40 text-indigo-600 dark:text-indigo-400 rounded-2xl flex items-center justify-center text-xl">🕒</div>
          <h2 className="text-3xl font-black text-gray-900 dark:text-white">Historique des recommandations</h2>
        </div>
        {analysisHistory && analysisHistory.length > 0 ? (
          <div className="space-y-6">
            {analysisHistory.slice().reverse().map((entry, idx) => (
              <div key={idx} className="bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 hover:shadow-lg transition-shadow">
                <div className="flex items-center gap-3 mb-4">
                  <span className="px-3 py-1 bg-indigo-50 dark:bg-indigo-900/20 text-indigo-600 dark:text-indigo-400 text-xs font-bold rounded-full">
                    Analyse #{analysisHistory.length - idx}
                  </span>
                  <p className="text-sm font-bold text-gray-400 dark:text-gray-500">{new Date(entry.timestamp).toLocaleString()}</p>
                </div>
                <p className="text-gray-700 dark:text-gray-300 font-medium leading-relaxed mb-6">{entry.analysis}</p>
                {entry.recommendations && entry.recommendations.length > 0 && (
                  <div className="pt-4 border-t border-gray-50 dark:border-gray-700/50">
                    <p className="text-xs font-black text-gray-400 uppercase tracking-widest mb-3">Filières recommandées :</p>
                    <div className="flex flex-wrap gap-2">
                      {entry.recommendations.map((rec, i) => (
                        <span key={i} className="px-4 py-1.5 bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 rounded-full text-sm font-bold shadow-sm">
                          {rec.program}
                        </span>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        ) : (
          <div className="p-10 text-center bg-gray-50 dark:bg-gray-800/50 rounded-3xl border border-dashed border-gray-200 dark:border-gray-700">
            <div className="text-4xl mb-4">📋</div>
            <p className="text-gray-500 dark:text-gray-400 font-medium text-lg">Aucune analyse précédente enregistrée.</p>
            <p className="text-gray-400 dark:text-gray-500 text-sm mt-2">Vos futures analyses apparaîtront ici automatiquement.</p>
          </div>
        )}
      </section>

    </div>
  );
}
