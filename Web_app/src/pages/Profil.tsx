import { useState } from 'react';
import { useOfflineStore } from '../store/useOfflineStore';
import { getInterestIcon } from '../components/Icons';

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

type EditField = 'personal' | 'interests' | 'education' | 'skills' | 'goals' | null;

export default function Profil() {
  const { profile, setProfile, clearStorage } = useOfflineStore();
  const [activeEditField, setActiveEditField] = useState<EditField>(!profile ? 'personal' : null);
  const [showConfirm, setShowConfirm] = useState(false);

  // Temporary edit state
  const [tempData, setTempData] = useState(
    profile || {
      name: '',
      age: '',
      education: '3ème',
      interests: [] as string[],
      skills: '',
      goals: ''
    }
  );

  const saveChanges = () => {
    setProfile(tempData);
    setActiveEditField(null);
  };

  const cancelChanges = () => {
    if (profile) setTempData(profile);
    if (profile && profile.name) {
      setActiveEditField(null);
    }
  };

  // Extract initials if name exists
  const initials = (profile?.name || tempData.name || '?')
    .split(' ')
    .map(n => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);

  return (
    <div className="min-h-screen py-10 px-4 bg-gray-50/50 dark:bg-transparent">
      <div className="max-w-5xl mx-auto space-y-6">

        {/* --- PERSONAL INFO CARD --- */}
        <div className="bg-gradient-to-r from-blue-900 via-blue-800 to-indigo-900 rounded-[2.5rem] p-8 md:p-12 text-white shadow-2xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-64 h-64 bg-amber-400/10 rounded-full -mr-20 -mt-20 blur-3xl" />
          
          {activeEditField === 'personal' ? (
            <div className="relative z-10 animate-in fade-in zoom-in-95">
              <h2 className="text-2xl font-black mb-6 flex items-center gap-2">
                <span className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center">1</span>
                Informations Personnelles
              </h2>
              <div className="grid md:grid-cols-2 gap-6 mb-6">
                <div>
                  <label className="block text-sm font-bold text-blue-200 mb-2">Nom complet</label>
                  <input 
                    type="text" 
                    className="w-full px-4 py-3 rounded-xl bg-white/10 border-2 border-white/20 focus:border-white focus:ring-4 focus:ring-white/10 outline-none transition-all placeholder-white/50 text-white"
                    placeholder="Ex: Jean Dupont"
                    value={tempData.name}
                    onChange={(e) => setTempData({...tempData, name: e.target.value})}
                  />
                </div>
                <div>
                  <label className="block text-sm font-bold text-blue-200 mb-2">Âge (Optionnel)</label>
                  <input 
                    type="number" 
                    className="w-full px-4 py-3 rounded-xl bg-white/10 border-2 border-white/20 focus:border-white focus:ring-4 focus:ring-white/10 outline-none transition-all placeholder-white/50 text-white"
                    placeholder="Ex: 15"
                    value={tempData.age}
                    onChange={(e) => setTempData({...tempData, age: e.target.value})}
                  />
                </div>
              </div>
              <div className="flex gap-4">
                <button onClick={saveChanges} disabled={!tempData.name} className="px-6 py-3 bg-amber-500 text-blue-950 font-black rounded-xl hover:bg-amber-400 transition-all disabled:opacity-50">
                  {profile ? 'Enregistrer' : 'Suivant'}
                </button>
                {profile && profile.name && (
                  <button onClick={cancelChanges} className="px-6 py-3 bg-white/10 text-white font-bold rounded-xl hover:bg-white/20 transition-all">
                    Annuler
                  </button>
                )}
              </div>
            </div>
          ) : (
            <div className="relative z-10 flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
              <div className="flex items-center gap-6">
                <div className="w-24 h-24 bg-amber-400 text-blue-900 rounded-3xl flex items-center justify-center text-4xl font-black ring-4 ring-white/20 shadow-xl">
                  {initials}
                </div>
                <div>
                  <p className="text-blue-200 font-bold tracking-widest text-sm uppercase mb-1">Élève Burkinabè</p>
                  <h1 className="text-4xl font-black">{profile?.name}</h1>
                  <div className="flex items-center gap-3 mt-3">
                    <span className="px-4 py-1.5 bg-white/20 rounded-full text-sm font-bold">{profile?.education}</span>
                    {profile?.age && <span className="px-4 py-1.5 bg-white/10 rounded-full text-sm font-bold">{profile?.age} ans</span>}
                  </div>
                </div>
              </div>
              <button 
                onClick={() => setActiveEditField('personal')}
                className="px-5 py-2.5 bg-white/10 hover:bg-white/20 rounded-xl font-bold transition-all border border-white/20 flex items-center gap-2"
              >
                <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg>
                Modifier le profil
              </button>
            </div>
          )}
        </div>

        {/* --- OTHER INFO GRID --- */}
        {profile && profile.name && (
          <div className="grid md:grid-cols-2 gap-6">
            
            {/* EDUCATION */}
            <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 border border-gray-100 dark:border-gray-700 shadow-sm relative group overflow-hidden">
              {activeEditField === 'education' ? (
                <div className="animate-in fade-in zoom-in-95">
                  <h3 className="text-xl font-black mb-4 dark:text-white">Niveau Scolaire (Burkina Faso)</h3>
                  <select 
                    className="w-full px-4 py-3 rounded-xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 mb-4 font-bold outline-none focus:border-blue-500"
                    value={tempData.education}
                    onChange={(e) => setTempData({...tempData, education: e.target.value})}
                  >
                    <option value="6ème">6ème</option>
                    <option value="5ème">5ème</option>
                    <option value="4ème">4ème</option>
                    <option value="3ème">3ème</option>
                    <option value="2nde">2nde</option>
                    <option value="1ère">1ère</option>
                    <option value="Terminale A">Terminale A</option>
                    <option value="Terminale D">Terminale D</option>
                    <option value="Terminale C">Terminale C</option>
                    <option value="Terminale E">Terminale E</option>
                    <option value="Terminale F">Terminale F</option>
                    <option value="Terminale G">Terminale G</option>
                    <option value="CAP / BEP">CAP / BEP</option>
                    <option value="Université">Université</option>
                  </select>
                  <div className="flex gap-2">
                    <button onClick={saveChanges} className="flex-1 py-2 bg-blue-600 text-white rounded-lg font-bold">Sauvegarder</button>
                    <button onClick={cancelChanges} className="flex-1 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg font-bold">Annuler</button>
                  </div>
                </div>
              ) : (
                <>
                  <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 rounded-xl flex items-center justify-center">🎓</div>
                      <h2 className="text-lg font-bold dark:text-white">Niveau d'études</h2>
                    </div>
                    <button onClick={() => setActiveEditField('education')} className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-700 flex items-center justify-center hover:bg-blue-100 hover:text-blue-600 transition-colors">
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg>
                    </button>
                  </div>
                  <p className="text-3xl font-black text-blue-700 dark:text-blue-400">{profile.education}</p>
                </>
              )}
            </div>

            {/* INTERESTS */}
            <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 border border-gray-100 dark:border-gray-700 shadow-sm relative group overflow-hidden">
              {activeEditField === 'interests' ? (
                <div className="animate-in fade-in zoom-in-95">
                  <h3 className="text-xl font-black mb-4 dark:text-white">Centres d'intérêt</h3>
                  <div className="flex flex-wrap gap-2 mb-6">
                    {['Technologie', 'Art & Design', 'Science', 'Business', 'Santé', 'Social', 'Écologie', 'Sport', 'Médias'].map(i => (
                      <button 
                        key={i} 
                        onClick={() => {
                          const newI = tempData.interests.includes(i) ? tempData.interests.filter(x => x !== i) : [...tempData.interests, i];
                          setTempData({...tempData, interests: newI});
                        }}
                        className={`px-3 py-1.5 rounded-lg text-sm font-bold border-2 transition-all ${tempData.interests.includes(i) ? 'border-blue-500 bg-blue-50 text-blue-700 dark:bg-blue-900/30' : 'border-gray-100 dark:border-gray-700 text-gray-500'}`}
                      >
                        {i}
                      </button>
                    ))}
                  </div>
                  <div className="flex gap-2">
                    <button onClick={saveChanges} className="flex-1 py-2 bg-blue-600 text-white rounded-lg font-bold">Sauvegarder</button>
                    <button onClick={cancelChanges} className="flex-1 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg font-bold">Annuler</button>
                  </div>
                </div>
              ) : (
                <>
                  <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-amber-100 dark:bg-amber-900/30 text-amber-600 dark:text-amber-400 rounded-xl flex items-center justify-center">🎯</div>
                      <h2 className="text-lg font-bold dark:text-white">Centres d'intérêt</h2>
                    </div>
                    <button onClick={() => setActiveEditField('interests')} className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-700 flex items-center justify-center hover:bg-amber-100 hover:text-amber-600 transition-colors">
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg>
                    </button>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    {profile.interests.length > 0 ? profile.interests.map(i => (
                      <span key={i} className={`px-3 py-1.5 rounded-xl text-sm font-semibold ${interestColors[i] || 'bg-gray-100'}`}>{i}</span>
                    )) : <span className="text-gray-400 italic">Aucun renseigné</span>}
                  </div>
                </>
              )}
            </div>

            {/* SKILLS */}
            <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 border border-gray-100 dark:border-gray-700 shadow-sm relative group overflow-hidden">
              {activeEditField === 'skills' ? (
                <div className="animate-in fade-in zoom-in-95">
                  <h3 className="text-xl font-black mb-4 dark:text-white">Compétences / Atouts</h3>
                  <textarea 
                    className="w-full h-24 px-4 py-3 rounded-xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 mb-4 font-medium outline-none focus:border-blue-500 resize-none"
                    value={tempData.skills}
                    placeholder="Ex: Je suis bon en mathématiques..."
                    onChange={(e) => setTempData({...tempData, skills: e.target.value})}
                  />
                  <div className="flex gap-2">
                    <button onClick={saveChanges} className="flex-1 py-2 bg-blue-600 text-white rounded-lg font-bold">Sauvegarder</button>
                    <button onClick={cancelChanges} className="flex-1 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg font-bold">Annuler</button>
                  </div>
                </div>
              ) : (
                <>
                  <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 text-emerald-600 dark:text-emerald-400 rounded-xl flex items-center justify-center">💡</div>
                      <h2 className="text-lg font-bold dark:text-white">Compétences clés</h2>
                    </div>
                    <button onClick={() => setActiveEditField('skills')} className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-700 flex items-center justify-center hover:bg-emerald-100 hover:text-emerald-600 transition-colors">
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg>
                    </button>
                  </div>
                  <p className="text-gray-600 dark:text-gray-300 font-medium whitespace-pre-line">{profile.skills || <span className="italic text-gray-400">Non renseigné</span>}</p>
                </>
              )}
            </div>

            {/* GOALS */}
            <div className="bg-white dark:bg-gray-800 rounded-3xl p-8 border border-gray-100 dark:border-gray-700 shadow-sm relative group overflow-hidden">
              {activeEditField === 'goals' ? (
                <div className="animate-in fade-in zoom-in-95">
                  <h3 className="text-xl font-black mb-4 dark:text-white">Vision à 5 ans</h3>
                  <textarea 
                    className="w-full h-24 px-4 py-3 rounded-xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 mb-4 font-medium outline-none focus:border-blue-500 resize-none"
                    value={tempData.goals}
                    placeholder="Ex: J'aimerais devenir ingénieur..."
                    onChange={(e) => setTempData({...tempData, goals: e.target.value})}
                  />
                  <div className="flex gap-2">
                    <button onClick={saveChanges} className="flex-1 py-2 bg-blue-600 text-white rounded-lg font-bold">Sauvegarder</button>
                    <button onClick={cancelChanges} className="flex-1 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg font-bold">Annuler</button>
                  </div>
                </div>
              ) : (
                <>
                  <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-violet-100 dark:bg-violet-900/30 text-violet-600 dark:text-violet-400 rounded-xl flex items-center justify-center">🚀</div>
                      <h2 className="text-lg font-bold dark:text-white">Objectifs</h2>
                    </div>
                    <button onClick={() => setActiveEditField('goals')} className="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-700 flex items-center justify-center hover:bg-violet-100 hover:text-violet-600 transition-colors">
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg>
                    </button>
                  </div>
                  <p className="text-gray-600 dark:text-gray-300 font-medium whitespace-pre-line">{profile.goals || <span className="italic text-gray-400">Non renseigné</span>}</p>
                </>
              )}
            </div>
            
          </div>
        )}

        {/* Global actions */}
        {profile && profile.name && (
          <div className="flex justify-end mt-8">
            {!showConfirm ? (
              <button onClick={() => setShowConfirm(true)} className="px-6 py-3 border-2 border-red-100 dark:border-red-900/30 text-red-600 dark:text-red-400 font-bold rounded-2xl hover:bg-red-50 dark:hover:bg-red-900/10 transition-all">
                Supprimer le profil
              </button>
            ) : (
              <div className="flex items-center gap-3">
                <span className="text-gray-500 font-bold">Êtes-vous sûr ?</span>
                <button onClick={() => { clearStorage(); setActiveEditField('personal'); setShowConfirm(false); setTempData({name:'', age:'', education:'3ème', interests:[], skills:'', goals:''}); }} className="px-6 py-2 bg-red-600 text-white font-bold rounded-xl hover:bg-red-700">Oui</button>
                <button onClick={() => setShowConfirm(false)} className="px-6 py-2 bg-gray-200 dark:bg-gray-700 font-bold rounded-xl">Non</button>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
