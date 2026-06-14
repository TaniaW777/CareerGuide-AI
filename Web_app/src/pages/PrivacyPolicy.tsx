

export default function PrivacyPolicy() {
  return (
    <div className="container mx-auto py-12 px-4 pb-24">
      <div className="max-w-4xl mx-auto bg-white dark:bg-gray-800 rounded-[2rem] p-8 md:p-12 shadow-sm border border-gray-100 dark:border-gray-700">
        <h1 className="text-4xl font-black text-gray-900 dark:text-white mb-6">Politique de Confidentialité</h1>
        
        <div className="space-y-6 text-gray-700 dark:text-gray-300">
          <section>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-3">1. Introduction</h2>
            <p>
              Bienvenue sur CareerGuide. La confidentialité de vos données personnelles est notre priorité. 
              Cette politique explique comment nous collectons, utilisons et protégeons vos informations.
              L'application CareerGuide est conçue selon le principe "Offline-First", ce qui signifie que vos données restent principalement sur votre appareil.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-3">2. Collecte et Stockage des Données</h2>
            <p>
              Les informations que vous saisissez (âge, niveau, centres d'intérêt, etc.) lors du test de profil 
              sont stockées <strong>exclusivement et localement sur votre navigateur</strong> via le stockage local (LocalStorage). 
              Nous ne possédons pas de base de données centralisée collectant ces profils.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-3">3. Mode Hors-Ligne vs En Ligne</h2>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li>
                <strong>Mode Hors-Ligne (Défaut) :</strong> L'analyse de votre profil et vos discussions avec le Conseiller IA 
                sont générées soit par des règles mathématiques locales, soit par une intelligence artificielle exécutée directement sur votre machine (Transformers.js / Ollama). Aucune donnée n'est envoyée sur Internet.
              </li>
              <li>
                <strong>Mode En Ligne :</strong> Si vous activez le mode "En Ligne" pour des réponses plus riches, vos questions 
                au Conseiller IA ainsi que les éléments de votre profil (uniquement ceux nécessaires au contexte) sont temporairement 
                envoyés à notre partenaire cloud (Groq). Ces données ne sont pas utilisées pour entraîner leurs modèles.
              </li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-3">4. Suppression de vos Données</h2>
            <p>
              Vous avez le contrôle total sur vos données. À tout moment, vous pouvez utiliser le bouton 
              <span className="font-bold text-red-500"> "Supprimer le profil" </span> 
              disponible sur la page de votre profil. Cela effacera instantanément et définitivement toutes vos données 
              de votre appareil.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-3">5. Licence et Authenticité</h2>
            <p>
              L'application CareerGuide est proposée sous la licence libre MIT. Le code source est transparent et vérifiable. 
              Pour toute question concernant la confidentialité ou la licence, veuillez consulter notre dépôt de code source.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
