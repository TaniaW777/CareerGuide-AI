import { Link } from 'react-router-dom';
import type { ReactNode } from 'react';
import heroImg from '../assets/hero.png';
import { SparkleIcon, CheckBadgeIcon, BrainIcon, TargetIcon, RobotIcon, GraduationIcon } from '../components/Icons';

export default function Landing() {
  return (
    <div className="flex flex-col w-full pb-20 overflow-x-hidden">
      {/* Hero Section */}
      <section className="relative pt-12 pb-24 lg:pt-32 lg:pb-40 bg-gradient-to-b from-white to-blue-50 dark:from-gray-950 dark:to-blue-950/20">
        <div className="container mx-auto px-4 relative z-10">
          <div className="flex flex-col lg:flex-row items-center gap-16">
            <div className="flex-1 text-center lg:text-left animate-in fade-in slide-in-from-left-8 duration-700">
              <div className="inline-flex items-center gap-2 px-4 py-2 rounded-2xl bg-blue-50 dark:bg-blue-900/30 text-blue-800 dark:text-blue-300 text-xs font-black mb-8 uppercase tracking-widest border border-blue-100 dark:border-blue-800">
                <SparkleIcon className="w-4 h-4 text-amber-500" />
                Conseiller d'Orientation IA
              </div>
              <h1 className="text-5xl md:text-7xl font-black tracking-tight text-gray-900 dark:text-white mb-8 leading-[1.1]">
                Trouvez le parcours <br />
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-700 to-blue-500 dark:from-blue-400 dark:to-blue-200">qui vous correspond.</span>
              </h1>
              <p className="text-xl md:text-2xl text-gray-600 dark:text-gray-400 mb-10 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-medium">
                Notre intelligence artificielle analyse vos talents pour vous proposer des filières, universités et bourses au Burkina Faso. 
                Utilisable sans internet.
              </p>
              <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-6">
                <Link
                  to="/profil"
                  className="w-full sm:w-auto px-10 py-5 bg-blue-700 text-white rounded-[2rem] font-black text-lg hover:bg-blue-800 transition-all shadow-2xl shadow-blue-900/20 flex items-center justify-center gap-3 group active:scale-95"
                >
                  Démarrer l'aventure
                  <svg className="w-6 h-6 group-hover:translate-x-2 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                  </svg>
                </Link>
                <Link
                  to="/chat"
                  className="w-full sm:w-auto px-10 py-5 bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-2 border-gray-100 dark:border-gray-700 rounded-[2rem] font-black text-lg hover:border-blue-500 transition-all flex items-center justify-center gap-2 active:scale-95 shadow-xl shadow-gray-200/50 dark:shadow-none"
                >
                  Conseiller IA
                </Link>
              </div>
            </div>
            
            <div className="flex-1 relative animate-in fade-in slide-in-from-right-8 duration-1000">
              <div className="absolute -z-10 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-blue-200/30 dark:bg-blue-900/10 rounded-full blur-3xl" />
              <div className="relative group">
                <div className="absolute -inset-4 bg-gradient-to-r from-blue-500 to-amber-500 rounded-[3rem] opacity-20 blur-2xl group-hover:opacity-30 transition-opacity" />
                <img 
                  src={heroImg} 
                  alt="CareerGuide AI" 
                  className="relative w-full max-w-lg mx-auto rounded-[2.5rem] shadow-2xl transform rotate-1 group-hover:rotate-0 transition-transform duration-500"
                />
                
                {/* Floating UI elements - Now Clickable */}
                <Link 
                  to="/chat"
                  className="absolute top-1/4 -left-8 bg-white dark:bg-gray-800 p-4 rounded-2xl shadow-2xl border border-gray-100 dark:border-gray-700 animate-float hover:scale-105 transition-transform"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 bg-amber-100 dark:bg-amber-900/30 rounded-lg flex items-center justify-center text-amber-600 dark:text-amber-400">
                      <RobotIcon className="w-5 h-5" />
                    </div>
                    <p className="font-bold text-sm text-gray-800 dark:text-gray-200">Conseiller IA</p>
                  </div>
                </Link>
                
                <Link 
                  to="/recommendations"
                  className="absolute bottom-12 -right-6 bg-white dark:bg-gray-800 p-5 rounded-3xl shadow-2xl border border-gray-100 dark:border-gray-700 animate-float animation-delay-1000 hover:scale-105 transition-transform"
                >
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-emerald-500 rounded-full flex items-center justify-center text-white">
                      <CheckBadgeIcon className="w-6 h-6" />
                    </div>
                    <div>
                      <p className="text-xs text-gray-500 font-black">RECOMMANDÉ</p>
                      <p className="font-bold text-gray-900 dark:text-white">Designer UX/UI</p>
                    </div>
                  </div>
                </Link>
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
              to="/profil"
              icon={<BrainIcon className="w-8 h-8 text-white" />}
              title="Mon Profil"
              description="Analysez votre personnalité et vos compétences."
              color="bg-blue-600"
              delay="delay-0"
            />
            <NavCard 
              to="/recommendations"
              icon={<TargetIcon className="w-8 h-8 text-white" />}
              title="Établissements"
              description="Explorez les séries, filières et universités."
              color="bg-purple-600"
              delay="delay-75"
            />
            <NavCard 
              to="/chat"
              icon={<RobotIcon className="w-8 h-8 text-white" />}
              title="Conseiller IA"
              description="Posez toutes vos questions en temps réel."
              color="bg-amber-500"
              delay="delay-150"
            />
            <NavCard 
              to="/testimonials"
              icon={<GraduationIcon className="w-8 h-8 text-white" />}
              title="Succès"
              description="Inspirez-vous des parcours de nos membres."
              color="bg-emerald-600"
              delay="delay-300"
            />
          </div>
        </div>
      </section>

      {/* LA SOLUTION (Image 3) */}
      <section className="py-24 bg-gray-50 dark:bg-gray-900 border-t border-b border-gray-100 dark:border-gray-800">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <span className="text-blue-600 dark:text-blue-400 font-black uppercase tracking-widest text-sm mb-4 block">LA SOLUTION</span>
            <h2 className="text-4xl font-black text-gray-900 dark:text-white mb-6">
              CareerGuide AI : Le conseiller d'orientation nouvelle génération
            </h2>
            <p className="text-lg text-gray-600 dark:text-gray-400 max-w-3xl mx-auto font-medium">
              Le premier assistant intelligent conçu spécifiquement pour le contexte éducatif du Burkina Faso, brisant les barrières de la connectivité.
            </p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl shadow-xl border border-gray-100 dark:border-gray-700 hover:-translate-y-2 transition-transform">
              <div className="w-14 h-14 bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 rounded-2xl flex items-center justify-center text-2xl mb-6">📶</div>
              <h3 className="text-xl font-black text-gray-900 dark:text-white mb-3">100% Offline</h3>
              <p className="text-gray-600 dark:text-gray-400 font-medium">Fonctionne sur smartphone <strong className="text-blue-600 dark:text-blue-400">sans connexion internet</strong>, idéal pour les zones rurales.</p>
            </div>
            <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl shadow-xl border border-gray-100 dark:border-gray-700 hover:-translate-y-2 transition-transform">
              <div className="w-14 h-14 bg-amber-100 dark:bg-amber-900/30 text-amber-600 dark:text-amber-400 rounded-2xl flex items-center justify-center text-2xl mb-6">🇧🇫</div>
              <h3 className="text-xl font-black text-gray-900 dark:text-white mb-3">Adapté au pays</h3>
              <p className="text-gray-600 dark:text-gray-400 font-medium">Intègre parfaitement le système éducatif du Burkina : <strong className="text-amber-600 dark:text-amber-400">Séries BAC, Bourses et Universités locales</strong>.</p>
            </div>
            <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl shadow-xl border border-gray-100 dark:border-gray-700 hover:-translate-y-2 transition-transform">
              <div className="w-14 h-14 bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400 rounded-2xl flex items-center justify-center text-2xl mb-6">🤝</div>
              <h3 className="text-xl font-black text-gray-900 dark:text-white mb-3">Gratuit & Inclusif</h3>
              <p className="text-gray-600 dark:text-gray-400 font-medium">Briser les barrières de l'orientation avec un accès <strong className="text-green-600 dark:text-green-400">gratuit pour tous</strong>, pour plus d'égalité des chances.</p>
            </div>
          </div>
        </div>
      </section>

      {/* INNOVATION TECHNIQUE (Image 4) */}
      <section className="py-24 bg-white dark:bg-gray-950">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <span className="text-blue-600 dark:text-blue-400 font-black uppercase tracking-widest text-sm mb-4 block">INNOVATION TECHNIQUE</span>
            <h2 className="text-4xl font-black text-gray-900 dark:text-white mb-6">
              Une technologie de pointe à votre service
            </h2>
          </div>
          
          <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            <div className="p-8 border-2 border-gray-100 dark:border-gray-800 rounded-3xl relative overflow-hidden group hover:border-blue-500 transition-colors">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-10 h-10 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-lg flex items-center justify-center">⚡</div>
                <h3 className="text-xl font-black text-gray-900 dark:text-white">Moteur d'inférence locale</h3>
              </div>
              <p className="text-gray-600 dark:text-gray-400">L'application utilise <strong className="text-blue-600 dark:text-blue-400">llama.cpp / WebLLM</strong> pour exécuter des réseaux de neurones directement sur le téléphone.</p>
            </div>
            
            <div className="p-8 border-2 border-gray-100 dark:border-gray-800 rounded-3xl relative overflow-hidden group hover:border-amber-500 transition-colors">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-10 h-10 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-lg flex items-center justify-center">🧠</div>
                <h3 className="text-xl font-black text-gray-900 dark:text-white">IA Locale Gemma</h3>
              </div>
              <p className="text-gray-600 dark:text-gray-400">Modèle de langage <strong className="text-amber-600 dark:text-amber-400">Gemma (Google)</strong> optimisé pour fonctionner de manière autonome sans envoi de données.</p>
            </div>
            
            <div className="p-8 border-2 border-gray-100 dark:border-gray-800 rounded-3xl relative overflow-hidden group hover:border-purple-500 transition-colors">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-10 h-10 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-lg flex items-center justify-center">📊</div>
                <h3 className="text-xl font-black text-gray-900 dark:text-white">Analyse des intérêts</h3>
              </div>
              <p className="text-gray-600 dark:text-gray-400">Traitement intelligent combinant un système de <strong className="text-purple-600 dark:text-purple-400">recommandation local</strong> et les calculs académiques.</p>
            </div>
            
            <div className="p-8 border-2 border-gray-100 dark:border-gray-800 rounded-3xl relative overflow-hidden group hover:border-green-500 transition-colors">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-10 h-10 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-lg flex items-center justify-center">📍</div>
                <h3 className="text-xl font-black text-gray-900 dark:text-white">Ancrage local</h3>
              </div>
              <p className="text-gray-600 dark:text-gray-400">Suggestions basées sur les filières et universités locales du Burkina Faso : <strong className="text-green-600 dark:text-green-400">Série C, D, A, G, etc.</strong></p>
            </div>
          </div>
          <div className="text-center mt-12">
            <span className="inline-block px-4 py-2 bg-blue-900 text-blue-100 text-xs font-black uppercase tracking-wider rounded-lg">Traitement localisé, sans serveurs cloud externes, 100% autonome.</span>
          </div>
        </div>
      </section>

      {/* TESTIMONIALS (Image 1) */}
      <section className="py-24 bg-white dark:bg-gray-950">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-black text-gray-900 dark:text-white mb-6 tracking-tight">
              Ils ont trouvé leur voie
            </h2>
            <p className="text-lg text-gray-500 dark:text-gray-400 max-w-2xl mx-auto font-medium">
              Découvrez comment CareerGuide a aidé des milliers d'étudiants et professionnels à s'orienter.
            </p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8 max-w-6xl mx-auto">
            {/* Testimonial 1 */}
            <div className="bg-white dark:bg-gray-900 p-8 rounded-3xl border-2 border-gray-100 dark:border-gray-800 shadow-xl hover:-translate-y-1 transition-transform">
              <div className="flex items-center gap-4 mb-6">
                <div className="w-12 h-12 rounded-full bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center text-purple-600 dark:text-purple-400 font-bold text-xl">
                  SM
                </div>
                <div>
                  <h4 className="font-black text-gray-900 dark:text-white">Sarah M.</h4>
                  <p className="text-sm text-gray-500 dark:text-gray-400 font-medium">Étudiante en Terminale</p>
                </div>
              </div>
              <div className="flex gap-1 text-amber-400 mb-6">
                {"★★★★★".split("").map((star, i) => <span key={i} className="text-xl">{star}</span>)}
              </div>
              <p className="text-gray-600 dark:text-gray-400 font-medium italic leading-relaxed">
                "CareerGuide m'a aidée à découvrir le métier de Data Scientist, auquel je n'avais jamais pensé. L'IA a vraiment compris mes intérêts pour les maths et l'art."
              </p>
            </div>

            {/* Testimonial 2 */}
            <div className="bg-white dark:bg-gray-900 p-8 rounded-3xl border-2 border-gray-100 dark:border-gray-800 shadow-xl hover:-translate-y-1 transition-transform">
              <div className="flex items-center gap-4 mb-6">
                <div className="w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-bold text-xl">
                  <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M14 5l7 7m0 0l-7 7m7-7H3" /></svg>
                </div>
                <div>
                  <h4 className="font-black text-gray-900 dark:text-white">Marc L.</h4>
                  <p className="text-sm text-gray-500 dark:text-gray-400 font-medium">En reconversion</p>
                </div>
              </div>
              <div className="flex gap-1 text-amber-400 mb-6">
                {"★★★★★".split("").map((star, i) => <span key={i} className="text-xl">{star}</span>)}
              </div>
              <p className="text-gray-600 dark:text-gray-400 font-medium italic leading-relaxed">
                "Le mode hors-ligne est un vrai plus ! J'ai pu explorer les recommandations pendant mes trajets. L'interface est intuitive et très fluide."
              </p>
            </div>

            {/* Testimonial 3 */}
            <div className="bg-white dark:bg-gray-900 p-8 rounded-3xl border-2 border-gray-100 dark:border-gray-800 shadow-xl hover:-translate-y-1 transition-transform">
              <div className="flex items-center gap-4 mb-6">
                <div className="w-12 h-12 rounded-full bg-indigo-100 dark:bg-indigo-900/30 flex items-center justify-center text-indigo-600 dark:text-indigo-400 font-bold text-xl">
                  <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                </div>
                <div>
                  <h4 className="font-black text-gray-900 dark:text-white">Julie D.</h4>
                  <p className="text-sm text-gray-500 dark:text-gray-400 font-medium">Étudiante L3</p>
                </div>
              </div>
              <div className="flex gap-1 text-amber-400 mb-6">
                {"★★★★".split("").map((star, i) => <span key={i} className="text-xl">{star}</span>)}
                <span className="text-xl text-gray-300 dark:text-gray-700">★</span>
              </div>
              <p className="text-gray-600 dark:text-gray-400 font-medium italic leading-relaxed">
                "L'assistant IA est bluffant. On a l'impression de discuter avec un vrai conseiller qui prend le temps de comprendre nos besoins."
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Call to Action */}
      <section className="py-20 px-4">
        <div className="container mx-auto max-w-6xl bg-blue-800 rounded-[3rem] p-12 md:p-20 relative overflow-hidden text-center shadow-3xl">
          <div className="absolute top-0 left-0 w-full h-full bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] opacity-10" />
          <div className="relative z-10">
            <h2 className="text-4xl md:text-6xl font-black text-white mb-8 leading-tight">
              Prêt à découvrir <br className="hidden md:block" /> votre futur métier ?
            </h2>
            <Link
              to="/profil"
              className="inline-flex px-12 py-6 bg-amber-400 text-blue-900 rounded-[2rem] font-black text-xl hover:bg-amber-300 transition-all shadow-2xl active:scale-95 hover:px-16"
            >
              C'est parti !
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}

function NavCard({ to, icon, title, description, color, delay }: { to: string, icon: ReactNode, title: string, description: string, color: string, delay: string }) {
  return (
    <Link to={to} className={`group p-8 bg-gray-50 dark:bg-gray-900/50 rounded-[2.5rem] border-2 border-transparent hover:border-blue-500 transition-all hover:shadow-2xl hover:-translate-y-2 animate-in fade-in slide-in-from-bottom-8 duration-700 ${delay}`}>
      <div className={`w-16 h-16 ${color} rounded-2xl flex items-center justify-center text-4xl mb-6 shadow-lg group-hover:scale-110 transition-transform group-hover:rotate-3`}>
        {icon}
      </div>
      <h3 className="text-2xl font-black text-gray-900 dark:text-white mb-3 tracking-tight">{title}</h3>
      <p className="text-gray-500 dark:text-gray-400 font-medium leading-relaxed mb-6">
        {description}
      </p>
      <div className="flex items-center text-blue-600 dark:text-blue-400 font-black text-sm group-hover:gap-2 transition-all">
        DÉCOUVRIR 
        <svg className="w-5 h-5 opacity-0 group-hover:opacity-100 transition-opacity" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M13 7l5 5m0 0l-5 5m5-5H6" />
        </svg>
      </div>
    </Link>
  );
}
