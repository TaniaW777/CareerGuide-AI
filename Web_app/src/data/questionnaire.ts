// Questionnaire psychologique complet pour l'orientation scolaire

export interface QuestionnaireQuestion {
  id: string;
  category: 'interests' | 'values' | 'subjects' | 'work_style' | 'skills' | 'goals' | 'family' | 'financial' | 'bac_series';
  question: string;
  description?: string;
  type: 'radio' | 'checkbox' | 'select';
  options: {
    label: string;
    value: string;
    profile_keywords?: string[]; // Keywords associated with this answer
  }[];
  weight?: number; // Importance weight for scoring (default 1)
  levels?: string[]; // Array of levels this question applies to (e.g. ['Terminale', 'Université'])
  allowOther?: boolean; // If true, allow user to enter a custom response
}

export const QUESTIONNAIRE: QuestionnaireQuestion[] = [
  // CENTRES D'INTÉRÊT
  {
    id: 'interest_1',
    category: 'interests',
    question: 'Avec quoi préfères-tu travailler principalement ?',
    type: 'radio',
    weight: 2,
    allowOther: true,
    options: [
      { label: 'Les personnes', value: 'people', profile_keywords: ['communication', 'social', 'gestion', 'ressources humaines'] },
      { label: 'Les machines et équipements', value: 'machines', profile_keywords: ['mécanique', 'ingénierie', 'électronique', 'maintenance'] },
      { label: 'Les données et chiffres', value: 'data', profile_keywords: ['mathématiques', 'informatique', 'analyse', 'statistiques'] },
      { label: 'La nature et l\'environnement', value: 'nature', profile_keywords: ['agronomie', 'écologie', 'foresterie', 'environnement'] }
    ]
  },
  {
    id: 'interest_2',
    category: 'interests',
    question: 'Qu\'aimes-tu faire au quotidien ?',
    type: 'checkbox',
    allowOther: true,
    options: [
      { label: 'Créer et concevoir', value: 'create', profile_keywords: ['architecture', 'design', 'ingénierie', 'innovation'] },
      { label: 'Réparer et maintenir', value: 'maintain', profile_keywords: ['maintenance', 'service', 'électricité', 'plomberie'] },
      { label: 'Vendre et convaincre', value: 'sell', profile_keywords: ['marketing', 'vente', 'commerce', 'entrepreneuriat'] },
      { label: 'Analyser et résoudre', value: 'analyze', profile_keywords: ['recherche', 'informatique', 'mathématiques', 'science'] },
      { label: 'Aider et soigner', value: 'help', profile_keywords: ['médecine', 'infirmerie', 'psychologie', 'travail social'] },
      { label: 'Enseigner et former', value: 'teach', profile_keywords: ['enseignement', 'formation', 'coaching', 'animation'] }
    ]
  },
  
  // VALEURS PERSONNELLES
  {
    id: 'values_1',
    category: 'values',
    question: 'Quel est ton objectif professionnel principal ?',
    type: 'radio',
    weight: 2,
    options: [
      { label: 'Gagner un bon salaire', value: 'money', profile_keywords: ['finance', 'commerce', 'gestion', 'affaires'] },
      { label: 'Aider les autres', value: 'help', profile_keywords: ['médecine', 'infirmerie', 'travail social', 'psychologie'] },
      { label: 'Être créatif', value: 'creative', profile_keywords: ['art', 'design', 'architecture', 'musique'] },
      { label: 'Avoir une sécurité d\'emploi', value: 'security', profile_keywords: ['fonction publique', 'enseignement', 'administration'] },
      { label: 'Diriger des projets', value: 'lead', profile_keywords: ['management', 'entrepreneuriat', 'gestion de projets'] }
    ]
  },
  {
    id: 'values_2',
    category: 'values',
    question: 'Qu\'est-ce qui est important dans le travail pour toi ?',
    type: 'checkbox',
    options: [
      { label: 'Autonomie et liberté', value: 'autonomy', profile_keywords: ['entrepreneuriat', 'recherche', 'indépendance'] },
      { label: 'Travail en équipe', value: 'teamwork', profile_keywords: ['gestion', 'ressources humaines', 'communication'] },
      { label: 'Stabilité et routine', value: 'stability', profile_keywords: ['fonction publique', 'enseignement', 'administration'] },
      { label: 'Innovation et changement', value: 'innovation', profile_keywords: ['technologie', 'recherche', 'startup'] },
      { label: 'Impact social', value: 'impact', profile_keywords: ['santé publique', 'développement', 'environnement'] }
    ]
  },

  // MATIÈRES PRÉFÉRÉES
  {
    id: 'subjects_1',
    category: 'subjects',
    question: 'Quelles sont tes meilleures matières ?',
    type: 'checkbox',
    allowOther: true,
    options: [
      { label: 'Mathématiques', value: 'math', profile_keywords: ['informatique', 'ingénierie', 'physique', 'actuariat'] },
      { label: 'Français / Littérature', value: 'french', profile_keywords: ['droit', 'communication', 'journalisme', 'histoire'] },
      { label: 'Sciences de la Vie', value: 'biology', profile_keywords: ['médecine', 'pharmacie', 'agronomie', 'santé'] },
      { label: 'Physique-Chimie', value: 'physics', profile_keywords: ['ingénierie', 'chimie', 'énergie', 'chimie industrielle'] },
      { label: 'Géographie', value: 'geography', profile_keywords: ['géologie', 'environnement', 'urbanisme', 'géomatique'] },
      { label: 'Histoire', value: 'history', profile_keywords: ['droit', 'histoire', 'archéologie', 'politique'] },
      { label: 'Anglais / Langues', value: 'languages', profile_keywords: ['traduction', 'tourisme', 'diplomatie', 'communication'] }
    ]
  },

  // STYLE DE TRAVAIL
  {
    id: 'work_style_1',
    category: 'work_style',
    question: 'Quel environnement de travail te plaît ?',
    type: 'radio',
    options: [
      { label: 'Bureau / travail à l\'intérieur', value: 'indoor', profile_keywords: ['informatique', 'administration', 'droit', 'finance'] },
      { label: 'Chantier / travail extérieur', value: 'outdoor', profile_keywords: ['génie civil', 'agriculture', 'construction', 'maintenance'] },
      { label: 'Laboratoire / Recherche', value: 'lab', profile_keywords: ['recherche', 'science', 'médecine', 'pharmacie'] },
      { label: 'Terrain / Déplacements', value: 'travel', profile_keywords: ['vente', 'conseil', 'tourisme', 'géologie'] }
    ]
  },
  {
    id: 'work_style_2',
    category: 'work_style',
    question: 'Préfères-tu travailler seul ou en équipe ?',
    type: 'radio',
    options: [
      { label: 'Seul / Autonome', value: 'solo', profile_keywords: ['recherche', 'entrepreneuriat', 'art', 'développement'] },
      { label: 'Petite équipe', value: 'small_team', profile_keywords: ['startup', 'consulting', 'projet'] },
      { label: 'Grande équipe', value: 'large_team', profile_keywords: ['gestion', 'management', 'ressources humaines'] }
    ]
  },

  // COMPÉTENCES NATURELLES
  {
    id: 'skills_1',
    category: 'skills',
    question: 'Tes forces naturelles ?',
    type: 'checkbox',
    options: [
      { label: 'Communication et éloquence', value: 'communication', profile_keywords: ['journalisme', 'communication', 'droit', 'politique'] },
      { label: 'Logique et résolution de problèmes', value: 'logic', profile_keywords: ['informatique', 'mathématiques', 'ingénierie'] },
      { label: 'Créativité', value: 'creativity', profile_keywords: ['design', 'architecture', 'art', 'marketing'] },
      { label: 'Leadership', value: 'leadership', profile_keywords: ['management', 'gestion', 'entrepreneuriat', 'politique'] },
      { label: 'Empathie et écoute', value: 'empathy', profile_keywords: ['psychologie', 'travail social', 'ressources humaines', 'santé'] },
      { label: 'Attention aux détails', value: 'detail', profile_keywords: ['audit', 'qualité', 'laboratoire', 'recherche'] }
    ]
  },

  // OBJECTIFS DE VIE
  {
    id: 'goals_1',
    category: 'goals',
    question: 'Où te vois-tu dans 10 ans ?',
    type: 'radio',
    options: [
      { label: 'Entrepreneur indépendant', value: 'entrepreneur', profile_keywords: ['entrepreneuriat', 'commerce', 'marketing'] },
      { label: 'Cadre dans une grande entreprise', value: 'executive', profile_keywords: ['management', 'gestion', 'ingénierie'] },
      { label: 'Expert reconnu dans mon domaine', value: 'expert', profile_keywords: ['recherche', 'consulting', 'science'] },
      { label: 'Au service public / Fonction publique', value: 'civil_service', profile_keywords: ['fonction publique', 'enseignement', 'administration'] },
      { label: 'Avec un bon équilibre travail-vie', value: 'balance', profile_keywords: ['enseignement', 'travail social', 'médecine'] }
    ]
  },

  // SITUATION FAMILIALE
  {
    id: 'family_1',
    category: 'family',
    question: 'Situation familiale et obligations',
    type: 'checkbox',
    options: [
      { label: 'Je dois contribuer financièrement à la famille', value: 'support_family', profile_keywords: ['professions bien rémunérées'] },
      { label: 'Je dois rester dans la région/ville', value: 'local', profile_keywords: ['local opportunities'] },
      { label: 'Je peux me permettre des études longues', value: 'long_studies', profile_keywords: ['médecine', 'doctorat', 'recherche'] },
      { label: 'Libre de mes choix', value: 'free_choice' }
    ]
  },

  // CONTRAINTES FINANCIÈRES
  {
    id: 'financial_1',
    category: 'financial',
    question: 'Capacités financières pour les études',
    type: 'radio',
    weight: 1.5,
    options: [
      { label: 'Études publiques uniquement', value: 'public_only', profile_keywords: ['universités publiques', 'bourses'] },
      { label: 'Accès aux universités privées', value: 'private_possible', profile_keywords: ['écoles privées', 'instituts réputés'] },
      { label: 'Formation courte (BEP, CAP, PMK)', value: 'short_term', profile_keywords: ['formation professionnelle', 'apprentissage'] },
      { label: 'Flexibilité complète', value: 'flexible', profile_keywords: ['tous domaines'] }
    ]
  },

  // SÉRIE DU BAC
  {
    id: 'bac_series',
    category: 'bac_series',
    question: 'Quelle série de BAC as-tu choisie ou comptes-tu choisir ?',
    type: 'select',
    weight: 2,
    levels: ['2nde', '1ère', 'Terminale', 'Université'],
    options: [
      { label: 'Série A (Littéraire)', value: 'A', profile_keywords: ['droit', 'communication', 'journalisme', 'psychologie', 'histoire'] },
      { label: 'Série C (Scientifique)', value: 'C', profile_keywords: ['informatique', 'ingénierie', 'mathématiques', 'physique'] },
      { label: 'Série D (Sciences Naturelles)', value: 'D', profile_keywords: ['médecine', 'pharmacie', 'agronomie', 'santé'] },
      { label: 'Série E (Économique)', value: 'E', profile_keywords: ['gestion', 'comptabilité', 'marketing', 'commerce'] },
      { label: 'Série F (Technique)', value: 'F', profile_keywords: ['électricité', 'mécanique', 'génie civil', 'menuiserie'] },
      { label: 'Série H (Hôtellerie)', value: 'H', profile_keywords: ['hôtellerie', 'tourisme', 'restauration', 'gestion hôtelière'] }
    ]
  }
];

// Category labels for display
export const CATEGORY_LABELS: Record<string, string> = {
  'interests': 'Centres d\'intérêt',
  'values': 'Valeurs personnelles',
  'subjects': 'Matières préférées',
  'work_style': 'Style de travail',
  'skills': 'Compétences naturelles',
  'goals': 'Objectifs de vie',
  'family': 'Situation familiale',
  'financial': 'Contraintes financières',
  'bac_series': 'Série du BAC'
};

// Progress bar colors
export const PROGRESS_COLORS: Record<string, string> = {
  'interests': 'bg-blue-500',
  'values': 'bg-purple-500',
  'subjects': 'bg-green-500',
  'work_style': 'bg-orange-500',
  'skills': 'bg-pink-500',
  'goals': 'bg-cyan-500',
  'family': 'bg-yellow-500',
  'financial': 'bg-red-500',
  'bac_series': 'bg-indigo-500'
};
