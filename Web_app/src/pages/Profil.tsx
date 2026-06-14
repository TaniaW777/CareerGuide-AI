import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import { QUESTIONNAIRE, CATEGORY_LABELS } from '../data/questionnaire';
import { BURKINA_SCHOOLS } from '../data/burkina_data';
import { localAiService } from '../services/localAiService';
import { getRecommendationsForProfile } from '../services/localCareerBackend';
import type { Recommendation } from '../services/localCareerBackend';

export default function Profil() {
  const { profile, setProfile, clearStorage } = useOfflineStore();
  const navigate = useNavigate();
  const [showConfirm, setShowConfirm] = useState(false);

  // Wizard state
  const [isWizard, setIsWizard] = useState(!profile);
  const [currentStep, setCurrentStep] = useState(-1); // -1 = Personal Info, 0 to N-1 = Questions
  const [isSummarizing, setIsSummarizing] = useState(false);
  const [aiSummary, setAiSummary] = useState('');
  const [selectedRec, setSelectedRec] = useState<Recommendation | null>(null);

  // Form state
  const [tempData, setTempData] = useState({
    name: profile?.name || '',
    age: profile?.age || '',
    education: profile?.education || '3ème',
    interests: profile?.interests || [],
    skills: profile?.skills || '',
    goals: profile?.goals || '',
    questionnaireAnswers: profile?.questionnaireAnswers || ({} as Record<string, string | string[]>),
    bacSeries: profile?.bacSeries || ''
  });

  const [customAnswers, setCustomAnswers] = useState<Record<string, string>>({});

  // Filter questions based on selected education level
  const filteredQuestions = QUESTIONNAIRE.filter(q => !q.levels || q.levels.includes(tempData.education));
  const totalSteps = filteredQuestions.length;

  const handleAnswer = (questionId: string, value: string | string[]) => {
    setTempData(prev => ({
      ...prev,
      questionnaireAnswers: {
        ...prev.questionnaireAnswers,
        [questionId]: value
      }
    }));
  };

  const finishWizard = async () => {
    // Extract interests, skills from keywords
    const allAnswers = tempData.questionnaireAnswers;
    const extractedInterests: string[] = [];
    const extractedSkills: string[] = [];
    let extractedBac = tempData.bacSeries;

    filteredQuestions.forEach(q => {
      const answer = allAnswers[q.id];
      if (!answer) return;
      
      if (q.id === 'bac_series' && typeof answer === 'string') {
        extractedBac = answer;
      }

      // Add custom answers as interests
      if (answer === 'autre' || (Array.isArray(answer) && answer.includes('autre'))) {
        if (customAnswers[q.id]) {
          if (q.category === 'interests' || q.category === 'subjects') {
            extractedInterests.push(customAnswers[q.id]);
          } else if (q.category === 'skills') {
            extractedSkills.push(customAnswers[q.id]);
          }
        }
      }

      const options = Array.isArray(answer) 
        ? q.options.filter(o => answer.includes(o.value))
        : q.options.filter(o => o.value === answer);

      options.forEach(opt => {
        if (opt.profile_keywords) {
          opt.profile_keywords.forEach(kw => {
            if (q.category === 'interests') extractedInterests.push(kw);
            if (q.category === 'skills') extractedSkills.push(kw);
          });
        }
      });
    });

    // Remove duplicates
    const finalInterests = [...new Set(extractedInterests)];
    const finalSkills = [...new Set(extractedSkills)].join(', ');

    const finalProfile = {
      name: tempData.name,
      age: tempData.age,
      education: tempData.education,
      interests: finalInterests.length ? finalInterests : tempData.interests,
      skills: finalSkills ? finalSkills : tempData.skills,
      goals: tempData.goals,
      questionnaireAnswers: tempData.questionnaireAnswers,
      bacSeries: extractedBac
    };

    setIsSummarizing(true);
    setProfile(finalProfile);
    
    // Call Local AI (Transformers.js)
    try {
      const summary = await localAiService.summarizeProfile(finalProfile);
      setAiSummary(summary);
    } catch (e) {
      console.log(e);
    }

    setIsSummarizing(false);
    setIsWizard(false);
  };

  const nextStep = () => {
    if (currentStep < totalSteps - 1) {
      setCurrentStep(curr => curr + 1);
    } else {
      finishWizard();
    }
  };

  const prevStep = () => {
    if (currentStep > -1) {
      setCurrentStep(curr => curr - 1);
    }
  };

  if (isSummarizing) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <h2 className="text-xl font-bold dark:text-white">L'IA locale analyse ton profil...</h2>
          <p className="text-gray-500 mt-2">Cela peut prendre quelques secondes la première fois (téléchargement du modèle).</p>
        </div>
      </div>
    );
  }

  if (isWizard) {
    const progress = ((currentStep + 1) / (totalSteps + 1)) * 100;
    const currentQ = currentStep >= 0 ? filteredQuestions[currentStep] : null;

    return (
      <div className="min-h-screen flex flex-col bg-gray-50 dark:bg-gray-900 py-10 px-4">
        <div className="max-w-2xl mx-auto w-full flex-1 flex flex-col">
          {/* Progress bar */}
          <div className="mb-8">
            <div className="flex justify-between text-sm font-bold text-gray-500 mb-2">
              <span>{currentStep === -1 ? 'Informations Personnelles' : CATEGORY_LABELS[currentQ!.category]}</span>
              <span>{currentStep + 2} / {totalSteps + 1}</span>
            </div>
            <div className="w-full h-3 bg-gray-200 dark:bg-gray-800 rounded-full overflow-hidden">
              <div 
                className="h-full bg-blue-600 transition-all duration-300"
                style={{ width: `${progress}%` }}
              ></div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-xl flex-1 flex flex-col">
            {currentStep === -1 ? (
              <div className="flex-1 animate-in fade-in slide-in-from-bottom-4">
                <h2 className="text-2xl font-black mb-2 dark:text-white">Faisons connaissance 👋</h2>
                <p className="text-gray-500 dark:text-gray-400 mb-8">Avant de commencer ton orientation, j'ai besoin de quelques informations.</p>
                
                <div className="space-y-6">
                  <div>
                    <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Quel est ton nom complet ? *</label>
                    <input 
                      type="text" 
                      className="w-full px-4 py-3 rounded-xl bg-gray-50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-700 focus:border-blue-500 outline-none transition-all dark:text-white font-medium"
                      placeholder="Ex: Jean Dupont"
                      value={tempData.name}
                      onChange={(e) => setTempData({...tempData, name: e.target.value})}
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Âge</label>
                      <input 
                        type="number" 
                        className="w-full px-4 py-3 rounded-xl bg-gray-50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-700 focus:border-blue-500 outline-none transition-all dark:text-white font-medium"
                        placeholder="Ex: 15"
                        value={tempData.age}
                        onChange={(e) => setTempData({...tempData, age: e.target.value})}
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Niveau *</label>
                      <select 
                        className="w-full px-4 py-3 rounded-xl bg-gray-50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-700 focus:border-blue-500 outline-none transition-all dark:text-white font-medium"
                        value={tempData.education}
                        onChange={(e) => setTempData({...tempData, education: e.target.value})}
                      >
                        <option value="3ème">3ème</option>
                        <option value="2nde">2nde</option>
                        <option value="1ère">1ère</option>
                        <option value="Terminale">Terminale</option>
                        <option value="Université">Université</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
            ) : currentQ ? (
              <div className="flex-1 animate-in fade-in slide-in-from-right-4" key={currentStep}>
                <h2 className="text-2xl font-black mb-6 dark:text-white">{currentQ.question}</h2>
                <div className="space-y-3">
                  {[...currentQ.options, ...(currentQ.allowOther ? [{label: 'Autre (préciser)', value: 'autre'}] : [])].map((opt) => {
                    const isSelected = currentQ.type === 'checkbox'
                      ? (Array.isArray(tempData.questionnaireAnswers[currentQ.id]) && (tempData.questionnaireAnswers[currentQ.id] as string[]).includes(opt.value))
                      : tempData.questionnaireAnswers[currentQ.id] === opt.value;

                    return (
                      <div key={opt.value}>
                        <label 
                          className={`flex items-center gap-4 p-4 rounded-2xl border-2 cursor-pointer transition-all ${
                            isSelected 
                              ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/30' 
                              : 'border-gray-100 dark:border-gray-700 hover:border-blue-200 dark:hover:border-gray-600'
                          }`}
                        >
                          <input 
                            type={currentQ.type === 'checkbox' ? 'checkbox' : 'radio'}
                            name={currentQ.id}
                            className="w-5 h-5 text-blue-600 focus:ring-blue-500"
                            checked={isSelected}
                            onChange={(e) => {
                              if (currentQ.type === 'checkbox') {
                                const curr = Array.isArray(tempData.questionnaireAnswers[currentQ.id]) ? [...(tempData.questionnaireAnswers[currentQ.id] as string[])] : [];
                                if (e.target.checked) curr.push(opt.value);
                                else curr.splice(curr.indexOf(opt.value), 1);
                                handleAnswer(currentQ.id, curr);
                              } else {
                                handleAnswer(currentQ.id, opt.value);
                              }
                            }}
                          />
                          <span className="font-bold text-gray-800 dark:text-gray-200">{opt.label}</span>
                        </label>
                        {opt.value === 'autre' && isSelected && (
                           <input 
                             type="text" 
                             className="w-full mt-2 px-4 py-3 rounded-xl bg-gray-50 dark:bg-gray-900 border-2 border-blue-200 dark:border-blue-800 focus:border-blue-500 outline-none transition-all dark:text-white font-medium"
                             placeholder="Précisez votre réponse..."
                             value={customAnswers[currentQ.id] || ''}
                             onChange={(e) => setCustomAnswers({...customAnswers, [currentQ.id]: e.target.value})}
                           />
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            ) : null}

            <div className="flex justify-between mt-8 pt-6 border-t border-gray-100 dark:border-gray-700">
              <button 
                onClick={prevStep}
                disabled={currentStep === -1}
                className="px-6 py-3 font-bold text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-xl transition-all disabled:opacity-30"
              >
                Retour
              </button>
              <button 
                onClick={nextStep}
                disabled={currentStep === -1 && !tempData.name}
                className="px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-black rounded-xl transition-all disabled:opacity-50"
              >
                {currentStep === totalSteps - 1 ? 'Terminer & Analyser' : 'Suivant'}
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // View Mode (When Profile is Complete)
  const initials = (profile?.name || '?').split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  
  let recs: ReturnType<typeof getRecommendationsForProfile> | null = null;
  if (profile) {
    recs = getRecommendationsForProfile(profile);
  }

  return (
    <div className="min-h-screen py-10 px-4 bg-gray-50/50 dark:bg-transparent">
      <div className="max-w-5xl mx-auto space-y-6">
        <div className="bg-gradient-to-r from-blue-900 via-blue-800 to-indigo-900 rounded-[2.5rem] p-8 md:p-12 text-white shadow-2xl relative overflow-hidden">
          <div className="relative z-10 flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
            <div className="flex items-center gap-6">
              <div className="w-24 h-24 bg-amber-400 text-blue-900 rounded-3xl flex items-center justify-center text-4xl font-black shadow-xl">
                {initials}
              </div>
              <div>
                <p className="text-blue-200 font-bold tracking-widest text-sm uppercase mb-1">Élève Burkinabè</p>
                <h1 className="text-4xl font-black">{profile?.name}</h1>
                <div className="flex items-center gap-3 mt-3">
                  <span className="px-4 py-1.5 bg-white/20 rounded-full text-sm font-bold">{profile?.education}</span>
                  {profile?.age && <span className="px-4 py-1.5 bg-white/10 rounded-full text-sm font-bold">{profile?.age} ans</span>}
                  {profile?.bacSeries && <span className="px-4 py-1.5 bg-amber-500/80 rounded-full text-sm font-bold">Série {profile?.bacSeries}</span>}
                </div>
              </div>
            </div>
            <div className="flex flex-col gap-3">
              <button onClick={() => navigate('/chat')} className="px-5 py-2.5 bg-amber-500 hover:bg-amber-400 text-blue-950 rounded-xl font-bold transition-all shadow-lg">
                Consulter l'IA
              </button>
              <button onClick={() => setIsWizard(true)} className="px-5 py-2.5 bg-white/10 hover:bg-white/20 rounded-xl font-bold transition-all">
                Refaire le test
              </button>
            </div>
          </div>
        </div>

        <div className="max-w-3xl">
          <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-sm">
            <h3 className="text-xl font-black mb-4 dark:text-white">Profil Psychologique (Moteur Déterministe)</h3>
            <div className="space-y-4">
              <div>
                <p className="text-sm font-bold text-gray-500 mb-1">Mots-clés extraits</p>
                <div className="flex flex-wrap gap-2">
                  {profile?.interests?.map(i => (
                    <span key={i} className="px-3 py-1 bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 rounded-lg text-sm font-bold">{i}</span>
                  ))}
                  {(!profile?.interests || profile.interests.length === 0) && <span className="text-gray-400 italic">Aucun mot-clé</span>}
                </div>
              </div>
              <div>
                <p className="text-sm font-bold text-gray-500 mb-1">Compétences déduites</p>
                <p className="font-medium dark:text-gray-200">{profile?.skills || 'Non défini'}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Section Recommandations basées sur le Profil */}
        {recs && recs.recommendations.length > 0 && (
          <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 shadow-sm mt-6">
             <h3 className="text-2xl font-black mb-6 flex items-center gap-2 dark:text-white">
              🎯 Top Recommandations pour Toi
            </h3>
            <p className="text-gray-600 dark:text-gray-400 mb-6">{recs.analysis}</p>
            <div className="grid md:grid-cols-2 gap-4">
              {recs.recommendations.map((rec, i) => (
                 <div key={i} 
                      onClick={() => setSelectedRec(rec)}
                      className="border border-gray-100 dark:border-gray-700 rounded-2xl p-5 hover:border-blue-300 dark:hover:border-blue-700 transition-colors bg-gray-50/50 dark:bg-gray-900/50 cursor-pointer flex flex-col justify-between">
                    <div>
                      <div className="flex justify-between items-start mb-2">
                         <h4 className="font-bold text-lg dark:text-white">{rec.program}</h4>
                         <span className="px-2 py-1 bg-blue-100 dark:bg-blue-900/40 text-blue-800 dark:text-blue-300 text-xs font-bold rounded-lg">{rec.type}</span>
                      </div>
                      <div className="flex items-center gap-2 mb-3">
                         <div className="flex-1 bg-gray-200 dark:bg-gray-700 rounded-full h-2 overflow-hidden">
                           <div className="bg-green-500 h-2 transition-all" style={{ width: `${rec.score}%` }}></div>
                         </div>
                         <span className="text-sm font-bold text-green-600 dark:text-green-400">{rec.score}%</span>
                      </div>
                    </div>
                    {rec.schools && rec.schools.length > 0 && (
                      <div className="mt-3">
                         <p className="text-xs text-gray-500 font-bold mb-1">Établissements :</p>
                         <p className="text-sm dark:text-gray-300">{rec.schools.map(s => s.name).join(', ')}</p>
                      </div>
                    )}
                 </div>
              ))}
            </div>
          </div>
        )}

        <div className="flex justify-end mt-8">
          {!showConfirm ? (
            <button onClick={() => setShowConfirm(true)} className="px-6 py-3 text-red-600 font-bold rounded-2xl hover:bg-red-50 dark:hover:bg-red-900/10 transition-colors">
              Supprimer le profil
            </button>
          ) : (
            <div className="flex items-center gap-3">
              <span className="text-gray-500 font-bold">Êtes-vous sûr ?</span>
              <button onClick={() => { clearStorage(); setIsWizard(true); setShowConfirm(false); }} className="px-6 py-2 bg-red-600 text-white font-bold rounded-xl transition-transform active:scale-95">Oui, supprimer</button>
              <button onClick={() => setShowConfirm(false)} className="px-6 py-2 bg-gray-200 text-gray-800 font-bold rounded-xl">Annuler</button>
            </div>
          )}
        </div>

        {selectedRec && (
          <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
            <div className="bg-white dark:bg-gray-800 rounded-3xl max-w-2xl w-full p-8 shadow-2xl relative max-h-[90vh] overflow-y-auto">
              <button onClick={() => setSelectedRec(null)} className="absolute top-4 right-4 text-gray-500 hover:text-gray-800 dark:hover:text-white font-bold text-xl">&times;</button>
              <div className="flex items-center gap-4 mb-4">
                 <h2 className="text-2xl font-black dark:text-white">{selectedRec.program}</h2>
                 <span className="px-3 py-1 bg-green-100 text-green-800 text-sm font-bold rounded-xl">{selectedRec.score}% compatible</span>
              </div>
              
              {selectedRec.programDetails && (
                <div className="space-y-4">
                  <p className="text-gray-600 dark:text-gray-400">{selectedRec.programDetails.description}</p>
                  
                  <div>
                    <h4 className="font-bold text-sm text-gray-500 uppercase mb-2">Compétences</h4>
                    <div className="flex flex-wrap gap-2">
                      {selectedRec.programDetails.competences.map(c => (
                        <span key={c} className="px-2 py-1 bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 rounded-md text-xs font-bold">{c}</span>
                      ))}
                    </div>
                  </div>

                  <div>
                    <h4 className="font-bold text-sm text-gray-500 uppercase mb-2">Débouchés</h4>
                    <ul className="list-disc pl-5 text-sm dark:text-gray-300">
                      {selectedRec.programDetails.debouches.map(d => <li key={d}>{d}</li>)}
                    </ul>
                  </div>
                </div>
              )}
              
              {selectedRec.schools && selectedRec.schools.length > 0 && (
                <div className="mt-6 pt-4 border-t border-gray-100 dark:border-gray-700">
                  <h4 className="font-bold text-sm text-gray-500 uppercase mb-3">Établissements</h4>
                  <div className="space-y-2">
                     {selectedRec.schools.map((s, idx) => {
                       const schoolData = BURKINA_SCHOOLS.find(bs => bs.name === s.name);
                       return (
                         <div key={idx} className="flex justify-between items-center p-3 bg-gray-50 dark:bg-gray-900 rounded-xl">
                            <span className="font-medium dark:text-white">{s.name}</span>
                            {schoolData?.website && (
                               <a href={schoolData.website} target="_blank" rel="noopener noreferrer" className="text-sm text-blue-600 hover:underline font-bold">Visiter →</a>
                            )}
                         </div>
                       )
                     })}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
