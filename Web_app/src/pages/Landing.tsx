import { Link } from 'react-router-dom';
import heroImg from '../assets/hero.png';

export default function Landing() {
  return (
    <div className="flex flex-col w-full pb-20 overflow-x-hidden">
      {/* Hero Section */}
      <section className="relative pt-12 pb-24 lg:pt-32 lg:pb-40 bg-gradient-to-b from-white to-gray-50 dark:from-gray-950 dark:to-gray-900">
        <div className="container mx-auto px-4 relative z-10">
          <div className="flex flex-col lg:flex-row items-center gap-16">
            <div className="flex-1 text-center lg:text-left animate-in fade-in slide-in-from-left-8 duration-700">
              <div className="inline-flex items-center gap-2 px-4 py-2 rounded-2xl bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 text-xs font-black mb-8 uppercase tracking-widest border border-indigo-100 dark:border-indigo-800">
                🚀 IA d'Orientation Scolaire
              </div>
              <h1 className="text-5xl md:text-7xl font-black tracking-tight text-gray-900 dark:text-white mb-8 leading-[1.1]">
                Trouvez le métier <br />
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-600 to-indigo-400">qui vous anime.</span>
              </h1>
              <p className="text-xl md:text-2xl text-gray-600 dark:text-gray-400 mb-10 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-medium">
                Notre intelligence artificielle analyse vos talents pour vous proposer des parcours personnalisés. 
                Utilisable sans internet.
              </p>
              <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-6">
                <Link
                  to="/profile-setup"
                  className="w-full sm:w-auto px-10 py-5 bg-indigo-600 text-white rounded-[2rem] font-black text-lg hover:bg-indigo-700 transition-all shadow-2xl shadow-indigo-600/30 flex items-center justify-center gap-3 group active:scale-95"
                >
                  Démarrer l'aventure
                  <svg className="w-6 h-6 group-hover:translate-x-2 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                  </svg>
                </Link>
                <Link
                  to="/chat"
                  className="w-full sm:w-auto px-10 py-5 bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-2 border-gray-100 dark:border-gray-700 rounded-[2rem] font-black text-lg hover:border-indigo-500 transition-all flex items-center justify-center gap-2 active:scale-95 shadow-xl shadow-gray-200/50 dark:shadow-none"
                >
                  Parler à l'IA
                </Link>
              </div>
            </div>
            
            <div className="flex-1 relative animate-in fade-in slide-in-from-right-8 duration-1000">
              <div className="absolute -z-10 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-indigo-200/30 dark:bg-indigo-900/10 rounded-full blur-3xl" />
              <div className="relative group">
                <div className="absolute -inset-4 bg-gradient-to-r from-indigo-500 to-purple-500 rounded-[3rem] opacity-20 blur-2xl group-hover:opacity-30 transition-opacity" />
                <img 
                  src={heroImg} 
                  alt="CareerGuide AI" 
                  className="relative w-full max-w-lg mx-auto rounded-[2.5rem] shadow-2xl transform rotate-1 group-hover:rotate-0 transition-transform duration-500"
                />
                
                {/* Floating UI elements */}
                <div className="absolute top-1/4 -left-8 bg-white dark:bg-gray-800 p-4 rounded-2xl shadow-2xl border border-gray-100 dark:border-gray-700 animate-float">
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center text-amber-600 text-xl">✨</div>
                    <p className="font-bold text-sm text-gray-800 dark:text-gray-200">Conseils IA</p>
                  </div>
                </div>
                
                <div className="absolute bottom-12 -right-6 bg-white dark:bg-gray-800 p-5 rounded-3xl shadow-2xl border border-gray-100 dark:border-gray-700 animate-float animation-delay-1000">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center text-white text-xl">✔️</div>
                    <div>
                      <p className="text-xs text-gray-500 font-black">RECOMMANDÉ</p>
                      <p className="font-bold text-gray-900 dark:text-white">Designer UX/UI</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Tools Section */}
      <section className="py-24 bg-white dark:bg-gray-950">
        <div className="container mx-auto px-4">
          <div className="text-center mb-20">
            <h2 className="text-4xl md:text-5xl font-black text-gray-900 dark:text-white mb-6 tracking-tight">
              Tout pour votre réussite
            </h2>
            <p className="text-lg text-gray-500 dark:text-gray-400 max-w-2xl mx-auto font-medium leading-relaxed">
              Une suite complète d'outils conçus pour vous aider à chaque étape de votre réflexion professionnelle.
            </p>
          </div>
          
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
            <NavCard 
              to="/profile-setup"
              icon="🧠"
              title="Bilan IA"
              description="Analysez votre personnalité et vos compétences."
              color="bg-blue-500"
              delay="delay-0"
            />
            <NavCard 
              to="/recommendations"
              icon="🎯"
              title="Métiers"
              description="Explorez les carrières qui vous correspondent."
              color="bg-purple-500"
              delay="delay-75"
            />
            <NavCard 
              to="/chat"
              icon="🤖"
              title="Assistant"
              description="Posez toutes vos questions en temps réel."
              color="bg-green-500"
              delay="delay-150"
            />
            <NavCard 
              to="/testimonials"
              icon="🎓"
              title="Succès"
              description="Inspirez-vous des parcours de nos membres."
              color="bg-orange-500"
              delay="delay-300"
            />
          </div>
        </div>
      </section>

      {/* Call to Action */}
      <section className="py-20 px-4">
        <div className="container mx-auto max-w-6xl bg-indigo-600 rounded-[3rem] p-12 md:p-20 relative overflow-hidden text-center shadow-3xl">
          <div className="absolute top-0 left-0 w-full h-full bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] opacity-10" />
          <div className="relative z-10">
            <h2 className="text-4xl md:text-6xl font-black text-white mb-8 leading-tight">
              Prêt à découvrir <br className="hidden md:block" /> votre futur métier ?
            </h2>
            <Link
              to="/profile-setup"
              className="inline-flex px-12 py-6 bg-white text-indigo-600 rounded-[2rem] font-black text-xl hover:bg-gray-50 transition-all shadow-2xl active:scale-95 hover:px-16"
            >
              C'est parti !
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}

function NavCard({ to, icon, title, description, color, delay }: { to: string, icon: string, title: string, description: string, color: string, delay: string }) {
  return (
    <Link to={to} className={`group p-8 bg-gray-50 dark:bg-gray-900/50 rounded-[2.5rem] border-2 border-transparent hover:border-indigo-500 transition-all hover:shadow-2xl hover:-translate-y-2 animate-in fade-in slide-in-from-bottom-8 duration-700 ${delay}`}>
      <div className={`w-16 h-16 ${color} rounded-2xl flex items-center justify-center text-4xl mb-6 shadow-lg group-hover:scale-110 transition-transform group-hover:rotate-3`}>
        {icon}
      </div>
      <h3 className="text-2xl font-black text-gray-900 dark:text-white mb-3 tracking-tight">{title}</h3>
      <p className="text-gray-500 dark:text-gray-400 font-medium leading-relaxed mb-6">
        {description}
      </p>
      <div className="flex items-center text-indigo-600 dark:text-indigo-400 font-black text-sm group-hover:gap-2 transition-all">
        DÉCOUVRIR 
        <svg className="w-5 h-5 opacity-0 group-hover:opacity-100 transition-opacity" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M13 7l5 5m0 0l-5 5m5-5H6" />
        </svg>
      </div>
    </Link>
  );
}



