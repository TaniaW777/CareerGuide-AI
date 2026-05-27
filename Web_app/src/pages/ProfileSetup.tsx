import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useOfflineStore } from '../store/useOfflineStore';
import { getInterestIcon } from '../components/Icons';

export default function ProfileSetup() {
  const navigate = useNavigate();
  const { profile, setProfile } = useOfflineStore();
  const [step, setStep] = useState(1);
  const [educationMode, setEducationMode] = useState<'3ème' | 'Terminale' | 'Autre'>('3ème');
  const [termSeries, setTermSeries] = useState('A');
  const [customEducation, setCustomEducation] = useState('');
  const [formData, setFormData] = useState<{
    name: string;
    age: string;
    education: string;
    interests: string[];
    skills: string;
    goals: string;
  }>({
    name: '',
    age: '',
    education: '3ème',
    interests: [],
    skills: '',
    goals: ''
  });

  useEffect(() => {
    if (profile) {
      let mode: '3ème' | 'Terminale' | 'Autre' = '3ème';
      let serie = 'A';
      let custom = '';

      if (profile.education.startsWith('Terminale')) {
        mode = 'Terminale';
        const parts = profile.education.split(' ');
        if (parts[1]) {
          serie = parts[1];
        }
      } else if (profile.education.toLowerCase().startsWith('autre')) {
        mode = 'Autre';
        custom = profile.education.replace(/^Autre[: -]?\s*/i, '');
      }

      setEducationMode(mode);
      setTermSeries(serie);
      setCustomEducation(custom);
      setFormData((prev) => ({
        ...prev,
        ...profile,
        age: profile.age || '',
        education: profile.education || '3ème',
      }));
    }
  }, [profile]);

  const handleNext = () => setStep(step + 1);
  const handlePrev = () => setStep(step - 1);
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setProfile(formData);
    navigate('/recommendations');
  };

  return (
    <div className="max-w-3xl mx-auto py-8 md:py-12 px-4">
      <div className="bg-white dark:bg-gray-800 rounded-[2.5rem] shadow-2xl overflow-hidden border border-gray-100 dark:border-gray-700">
        <div className="bg-indigo-600 px-8 py-10 text-white relative overflow-hidden">
          <div className="absolute top-0 right-0 -mr-16 -mt-16 w-48 h-48 bg-white/10 rounded-full blur-3xl" />
          <div className="relative z-10 text-center md:text-left">
            <h1 className="text-3xl font-black tracking-tight mb-2">Configurez votre profil</h1>
            <p className="text-indigo-100 font-medium opacity-90">Étape {step} sur 3 • {step === 1 ? 'Identité' : step === 2 ? 'Passions' : 'Objectifs'}</p>
            <div className="mt-6 flex gap-2">
              {[1, 2, 3].map(i => (
                <div 
                  key={i}
                  className={`h-2 flex-1 rounded-full transition-all duration-500 ${i <= step ? 'bg-white' : 'bg-indigo-400/30'}`}
                />
              ))}
            </div>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="p-8 md:p-12">
          {step === 1 && (
            <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
              <div>
                <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-3 uppercase tracking-wider">Nom complet</label>
                <input 
                  type="text" 
                  required
                  className="w-full px-6 py-4 rounded-2xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 outline-none transition-all text-lg font-medium"
                  placeholder="Jean Dupont"
                  value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-3 uppercase tracking-wider">Niveau d'études</label>
                <div className="grid grid-cols-3 gap-4">
                  {['3ème', 'Terminale', 'Autre'].map((level) => (
                    <button
                      key={level}
                      type="button"
                      onClick={() => {
                        setEducationMode(level as '3ème' | 'Terminale' | 'Autre');
                        if (level === '3ème') {
                          setFormData({ ...formData, education: '3ème' });
                        } else if (level === 'Terminale') {
                          setFormData({ ...formData, education: `Terminale ${termSeries}` });
                        } else {
                          setFormData({ ...formData, education: 'Autre' });
                        }
                      }}
                      className={`p-4 rounded-2xl border-2 text-left font-bold transition-all
                        ${educationMode === level
                          ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-900/40 text-indigo-700 dark:text-indigo-400 shadow-md shadow-indigo-500/10'
                          : 'border-gray-100 dark:border-gray-700 hover:border-indigo-200 dark:hover:border-indigo-800'}
                      `}
                    >
                      {level}
                    </button>
                  ))}
                </div>

                {educationMode === 'Terminale' && (
                  <div className="mt-6">
                    <p className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3">Choisissez votre série</p>
                    <div className="grid grid-cols-4 gap-3">
                      {['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map((serie) => (
                        <button
                          key={serie}
                          type="button"
                          onClick={() => {
                            setTermSeries(serie);
                            setFormData({ ...formData, education: `Terminale ${serie}` });
                          }}
                          className={`px-3 py-2 rounded-2xl text-sm font-bold transition-all ${termSeries === serie ? 'bg-indigo-600 text-white' : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-indigo-50 dark:hover:bg-gray-600'}`}
                        >
                          {serie}
                        </button>
                      ))}
                    </div>
                  </div>
                )}

                {educationMode === 'Autre' && (
                  <div className="mt-6">
                    <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-3 uppercase tracking-wider">Précisez votre niveau</label>
                    <input
                      type="text"
                      value={customEducation}
                      onChange={(e) => {
                        const value = e.target.value;
                        setCustomEducation(value);
                        setFormData({ ...formData, education: value ? `Autre: ${value}` : 'Autre' });
                      }}
                      placeholder="Ex: CAP, Bac Pro, classe prépa, autre formation"
                      className="w-full px-6 py-4 rounded-2xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 outline-none transition-all text-lg font-medium"
                    />
                  </div>
                )}
              </div>
            </div>
          )}

          {step === 2 && (
            <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
              <div className="text-center mb-4">
                <h2 className="text-2xl font-black text-gray-900 dark:text-white">Qu'est-ce qui vous passionne ?</h2>
                <p className="text-gray-500 dark:text-gray-400">Sélectionnez plusieurs centres d'intérêt.</p>
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
                {['Technologie', 'Art & Design', 'Science', 'Business', 'Santé', 'Social', 'Écologie', 'Sport', 'Médias'].map((interest) => (
                  <button
                    key={interest}
                    type="button"
                    onClick={() => {
                      const newInterests = formData.interests.includes(interest)
                        ? formData.interests.filter(i => i !== interest)
                        : [...formData.interests, interest];
                      setFormData({...formData, interests: newInterests});
                    }}
                    className={`p-5 rounded-3xl border-2 transition-all flex flex-col items-center gap-3
                      ${formData.interests.includes(interest)
                        ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-900/40 text-indigo-700 dark:text-indigo-400 shadow-lg scale-105'
                        : 'border-gray-50 dark:border-gray-700 hover:border-indigo-100 dark:hover:border-gray-600'}
                    `}
                  >
                    <div className="w-12 h-12 rounded-2xl flex items-center justify-center text-indigo-600 dark:text-indigo-300">
                      {getInterestIcon(interest, 'w-6 h-6')}
                    </div>
                    <span className="font-bold text-sm text-center">{interest}</span>
                  </button>
                ))}
              </div>
            </div>
          )}

          {step === 3 && (
            <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
              <div>
                <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-3 uppercase tracking-wider">Vos compétences clés</label>
                <textarea 
                  className="w-full px-6 py-4 rounded-2xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 outline-none transition-all h-32 font-medium"
                  placeholder="Ex: Programmation, Communication, Gestion de projet..."
                  value={formData.skills}
                  onChange={(e) => setFormData({...formData, skills: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-3 uppercase tracking-wider">Votre vision (5 ans)</label>
                <textarea 
                  className="w-full px-6 py-4 rounded-2xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 outline-none transition-all h-32 font-medium"
                  placeholder="Où vous voyez-vous dans 5 ans ?"
                  value={formData.goals}
                  onChange={(e) => setFormData({...formData, goals: e.target.value})}
                />
              </div>
            </div>
          )}

          <div className="mt-12 flex items-center justify-between gap-4">
            {step > 1 ? (
              <button
                type="button"
                onClick={handlePrev}
                className="flex-1 px-8 py-4 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 rounded-2xl font-bold hover:bg-gray-200 dark:hover:bg-gray-600 transition-all"
              >
                Retour
              </button>
            ) : (
              <div className="flex-1" />
            )}
            
            {step < 3 ? (
              <button
                type="button"
                disabled={step === 1 && !formData.name}
                onClick={handleNext}
                className="flex-1 px-8 py-4 bg-indigo-600 text-white rounded-2xl font-bold hover:bg-indigo-700 transition-all shadow-xl shadow-indigo-500/20 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Suivant
              </button>
            ) : (
              <button
                type="submit"
                className="flex-1 px-8 py-4 bg-green-600 text-white rounded-2xl font-bold hover:bg-green-700 transition-all shadow-xl shadow-green-500/20"
              >
                Terminer
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
}


