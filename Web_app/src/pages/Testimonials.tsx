

const testimonials = [
  {
    name: 'Sarah M.',
    role: 'Étudiante en Terminale',
    text: "CareerGuide m'a aidée à découvrir le métier de Data Scientist, auquel je n'avais jamais pensé. L'IA a vraiment compris mes intérêts pour les maths et l'art.",
    avatar: '👩‍🎓',
    rating: 5
  },
  {
    name: 'Marc L.',
    role: 'En reconversion',
    text: "Le mode hors-ligne est un vrai plus ! J'ai pu explorer les recommandations pendant mes trajets. L'interface est intuitive et très fluide.",
    avatar: '👨‍💼',
    rating: 5
  },
  {
    name: 'Julie D.',
    role: 'Étudiante L3',
    text: "L'assistant IA est bluffant. On a l'impression de discuter avec un vrai conseiller qui prend le temps de comprendre nos besoins.",
    avatar: '👩‍💻',
    rating: 4
  }
];

export default function Testimonials() {
  return (
    <div className="container mx-auto py-12 px-4">
      <div className="text-center mb-16">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-4">Ils ont trouvé leur voie</h1>
        <p className="text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
          Découvrez comment CareerGuide a aidé des milliers d'étudiants et professionnels à s'orienter.
        </p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        {testimonials.map((t, i) => (
          <div key={i} className="bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-center gap-4 mb-6">
              <div className="w-12 h-12 bg-indigo-100 dark:bg-indigo-900/30 rounded-full flex items-center justify-center text-2xl">
                {t.avatar}
              </div>
              <div>
                <h3 className="font-bold text-gray-900 dark:text-white">{t.name}</h3>
                <p className="text-sm text-gray-500 dark:text-gray-400">{t.role}</p>
              </div>
            </div>
            <div className="flex mb-4">
              {[...Array(5)].map((_, i) => (
                <svg key={i} className={`w-5 h-5 ${i < t.rating ? 'text-yellow-400' : 'text-gray-300'}`} fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                </svg>
              ))}
            </div>
            <p className="text-gray-600 dark:text-gray-400 italic leading-relaxed">
              "{t.text}"
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}

