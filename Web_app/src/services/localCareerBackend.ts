export interface UserProfile {
  name: string;
  age?: string;
  education: string;
  interests: string[];
  skills: string;
  goals: string;
}

export interface School {
  name: string;
  city: string;
  type: 'Lycée' | 'Collège' | 'Lycée Technique' | 'Lycée Professionnel' | 'Université' | 'Institut' | 'Centre de Formation';
  level: '3ème' | 'Terminale' | 'Supérieur';
  email?: string;
  phone?: string;
  website?: string;
  description?: string;
  programs?: string[];
}

export interface Program {
  id: string;
  name: string;
  level: '3ème' | 'Terminale' | 'Supérieur';
  type: 'Série' | 'CAP/BEP' | 'Licence' | 'Master' | 'Diplôme';
  debouches: string[];
  competences: string[];
  description?: string;
}

export interface Scholarship {
  name: string;
  provider: string;
  description: string;
  link: string;
}

export interface Recommendation {
  program: string;
  score: number;
  schools: { name: string; city: string }[];
  type: 'Serie' | 'CAP/BEP' | 'Universite' | 'Institut';
  tags?: string[];
}

// const BACKEND_URL = 'http://127.0.0.1:8000';

function normalizeEducation(education: string) {
  if (!education) return '3ème';
  if (education.toLowerCase().includes('3ème') || education.toLowerCase().includes('3eme') || education.toLowerCase().includes('collège')) {
    return '3ème';
  }
  return 'Terminale';
}

// Données adaptées au Burkina Faso
const collegePrograms: Recommendation[] = [
  { program: 'Série C (Maths/Physique)', type: 'Serie', tags: ['science', 'technologie', 'math'], schools: [{ name: 'Lycée Philippe Zinda Kaboré', city: 'Ouagadougou' }, { name: 'Prytanée Militaire du Kadiogo', city: 'Kadiogo' }], score: 0 },
  { program: 'Série D (SVT)', type: 'Serie', tags: ['science', 'santé', 'écologie', 'biologie'], schools: [{ name: 'Lycée Bogodogo', city: 'Ouagadougou' }, { name: 'Lycée Ouezzin Coulibaly', city: 'Bobo-Dioulasso' }], score: 0 },
  { program: 'Série A (Lettres/Langues)', type: 'Serie', tags: ['art & design', 'social', 'médias', 'lettres'], schools: [{ name: 'Lycée Nelson Mandela', city: 'Ouagadougou' }, { name: 'Lycée Provincial', city: 'Koudougou' }], score: 0 },
  { program: 'Série G (Gestion/Commerce)', type: 'Serie', tags: ['business', 'gestion'], schools: [{ name: 'Lycée Technique de Ouagadougou', city: 'Ouagadougou' }], score: 0 },
  { program: 'CAP / BEP Dessin Bâtiment', type: 'CAP/BEP', tags: ['art & design', 'technologie', 'bâtiment'], schools: [{ name: 'Lycée Professionnel Régional', city: 'Bobo-Dioulasso' }, { name: 'Centre de Formation Professionnelle', city: 'Ouagadougou' }], score: 0 },
  { program: 'CAP / BEP Comptabilité', type: 'CAP/BEP', tags: ['business', 'gestion'], schools: [{ name: 'Lycée Professionnel National', city: 'Ouagadougou' }], score: 0 },
  { program: 'CAP / BEP Mécanique Auto', type: 'CAP/BEP', tags: ['technologie', 'mécanique'], schools: [{ name: 'Centre de Formation Professionnelle', city: 'Koudougou' }], score: 0 },
  { program: 'CAP / BEP Menuiserie', type: 'CAP/BEP', tags: ['art & design', 'bois'], schools: [{ name: 'Lycée Professionnel', city: 'Fada N\'Gourma' }], score: 0 },
];

const lyceePrograms: Recommendation[] = [
  { program: 'Licence en Informatique / Génie Logiciel', type: 'Universite', tags: ['technologie', 'informatique', 'code'], schools: [{ name: 'Burkina Institute of Technology (BIT)', city: 'Koudougou' }, { name: 'Université Joseph Ki-Zerbo', city: 'Ouagadougou' }], score: 0 },
  { program: 'Médecine & Sciences de la Santé', type: 'Universite', tags: ['santé', 'science', 'médical'], schools: [{ name: 'Université Joseph Ki-Zerbo', city: 'Ouagadougou' }, { name: 'Université Nazi Boni', city: 'Bobo-Dioulasso' }], score: 0 },
  { program: 'Licence en Économie et Gestion', type: 'Universite', tags: ['business', 'économie', 'gestion'], schools: [{ name: 'Université Thomas Sankara', city: 'Ouagadougou' }], score: 0 },
  { program: 'Génie Civil & Bâtiment', type: 'Institut', tags: ['technologie', 'bâtiment'], schools: [{ name: 'Institut Supérieur d\'Ingénierie', city: 'Ouagadougou' }, { name: 'École Supérieure Polytechnique', city: 'Dédougou' }], score: 0 },
  { program: 'Licence en Communication et Journalisme', type: 'Universite', tags: ['médias', 'art & design', 'communication'], schools: [{ name: 'Université Joseph Ki-Zerbo', city: 'Ouagadougou' }, { name: 'ISTIC', city: 'Ouagadougou' }], score: 0 },
  { program: 'Sciences Agronomiques', type: 'Universite', tags: ['écologie', 'science', 'nature'], schools: [{ name: 'Université Nazi Boni', city: 'Bobo-Dioulasso' }, { name: 'Institut du Développement Rural', city: 'Bobo-Dioulasso' }], score: 0 },
];

const scholarships: Scholarship[] = [
  {
    name: 'Bourses d\'études CIOSPB',
    provider: 'Gouvernement du Burkina Faso (CIOSPB)',
    description: 'Bourses nationales et internationales pour les bacheliers et étudiants méritants du Burkina Faso. Couvre les frais de scolarité et de subsistance.',
    link: 'https://www.ciospb.gov.bf/'
  },
  {
    name: 'Bourses FONER',
    provider: 'Fonds National pour l\'Éducation et la Recherche',
    description: 'Aides financières et prêts pour les étudiants inscrits dans les universités publiques et privées reconnues au Burkina Faso.',
    link: 'https://www.foner.bf/'
  },
  {
    name: 'Bourses de l\'AUF',
    provider: 'Agence Universitaire de la Francophonie',
    description: 'Bourses de mobilité pour les étudiants souhaitant poursuivre des études ou faire des recherches dans l\'espace francophone.',
    link: 'https://www.auf.org/'
  }
];

// Catalogue complet des établissements par niveau et type
const schools: School[] = [
  // === NIVEAU 3ème - Lycées & Collèges ===
  { name: 'Lycée Philippe Zinda Kaboré', city: 'Ouagadougou', type: 'Lycée', level: '3ème', programs: ['Série C', 'Série D', 'Série A'], description: 'Établissement prestigieux, excellent pour sciences et lettres' },
  { name: 'Prytanée Militaire du Kadiogo', city: 'Kadiogo', type: 'Lycée', level: '3ème', programs: ['Série C', 'Série D'], description: 'Lycée militaire réputé, discipline rigoureuse, excellents résultats' },
  { name: 'Lycée Bogodogo', city: 'Ouagadougou', type: 'Lycée', level: '3ème', programs: ['Série D', 'Série A'], description: 'Lycée généraliste avec bons programmes en sciences' },
  { name: 'Lycée Ouezzin Coulibaly', city: 'Bobo-Dioulasso', type: 'Lycée', level: '3ème', programs: ['Série C', 'Série D'], description: 'Lycée de référence dans le sud du Burkina' },
  { name: 'Lycée Nelson Mandela', city: 'Ouagadougou', type: 'Lycée', level: '3ème', programs: ['Série A', 'Série G'], description: 'Fort en littérature et sciences humaines' },
  { name: 'Lycée Technique de Ouagadougou', city: 'Ouagadougou', type: 'Lycée Technique', level: '3ème', programs: ['Série F', 'Série E'], description: 'Spécialisé en filières techniques et technologiques' },
  { name: 'Lycée Provincial', city: 'Koudougou', type: 'Lycée', level: '3ème', programs: ['Série A', 'Série C', 'Série G'], description: 'Établissement régional bien équipé' },
  { name: 'Lycée Professionnel National', city: 'Ouagadougou', type: 'Lycée Professionnel', level: '3ème', programs: ['CAP Comptabilité', 'CAP Mécanique'], description: 'Formation professionnelle de qualité' },
  { name: 'Lycée Professionnel Régional', city: 'Bobo-Dioulasso', type: 'Lycée Professionnel', level: '3ème', programs: ['CAP Dessin', 'CAP Bâtiment'], description: 'Excellente réputation en métiers du bâtiment' },
  { name: 'Centre de Formation Professionnelle du Plateau', city: 'Ouagadougou', type: 'Centre de Formation', level: '3ème', programs: ['CAP Mécanique Auto', 'CAP Électricité'], description: 'Formation pratique directe au marché' },
  { name: 'Centre de Formation Métiers Bois', city: 'Bobo-Dioulasso', type: 'Centre de Formation', level: '3ème', programs: ['CAP Menuiserie', 'BEP Ébénisterie'], description: 'Spécialisé dans les métiers du bois et artisanat' },
  { name: 'Lycée Privé de la Jeunesse (Internat)', city: 'Ouagadougou', type: 'Lycée', level: '3ème', programs: ['Série D', 'Série A'], description: 'Lycée avec internat offrant un encadrement strict' },
  { name: 'Collège Privé Elite', city: 'Koudougou', type: 'Collège', level: '3ème', programs: ['Général'], description: 'Collège de proximité avec de bons résultats' },
  
  // === NIVEAU TERMINALE - Universités & Instituts ===
  { name: 'Université Joseph Ki-Zerbo', city: 'Ouagadougou', type: 'Université', level: 'Terminale', programs: ['Informatique', 'Médecine', 'Droit', 'Communication'], description: 'Université publique principale, très complète' },
  { name: 'Université Nazi Boni', city: 'Bobo-Dioulasso', type: 'Université', level: 'Terminale', programs: ['Agronomie', 'Médecine', 'Sciences'], description: 'Université de référence du sud, forte en sciences' },
  { name: 'Université Thomas Sankara', city: 'Ouagadougou', type: 'Université', level: 'Terminale', programs: ['Économie', 'Gestion', 'Commerce'], description: 'Spécialisée en sciences économiques et gestion' },
  { name: 'Burkina Institute of Technology (BIT)', city: 'Koudougou', type: 'Institut', level: 'Terminale', programs: ['Génie Informatique', 'Génie Civil'], description: 'Institut technologique privé réputé' },
  { name: 'Institut Supérieur d\'Ingénierie', city: 'Ouagadougou', type: 'Institut', level: 'Terminale', programs: ['Génie Civil', 'Génie Électrique'], description: 'Formation d\'ingénieurs de haut niveau' },
  { name: 'École Supérieure Polytechnique', city: 'Dédougou', type: 'Institut', level: 'Terminale', programs: ['Génie Civil', 'Génie Mécanique'], description: 'École polytechnique prestigieuse' },
  { name: 'ISTIC (Institut Supérieur des Télécommunications et d\'Informatique)', city: 'Ouagadougou', type: 'Institut', level: 'Terminale', programs: ['Informatique', 'Télécommunications', 'Réseaux'], description: 'Excellence en informatique et télécom' },
  { name: 'Institut du Développement Rural', city: 'Bobo-Dioulasso', type: 'Institut', level: 'Terminale', programs: ['Agronomie', 'Zootechnie', 'Foresterie'], description: 'Référence en sciences agronomiques' },
];

// Catalogue des filières/séries avec débouchés détaillés
const programs: Program[] = [
  // Séries 3ème
  { 
    id: 'serie-c',
    name: 'Série C (Maths/Physique)',
    level: '3ème',
    type: 'Série',
    competences: ['Mathématiques', 'Physique-Chimie', 'Sciences', 'Logique'],
    debouches: ['Ingénieur informatique', 'Ingénieur civil', 'Mathématicien', 'Physicien', 'Chercheur scientifique', 'Professeur sciences'],
    description: 'Filière scientifique exigeante pour les passionnés de maths et sciences exactes.'
  },
  { 
    id: 'serie-d',
    name: 'Série D (Sciences de la Vie)',
    level: '3ème',
    type: 'Série',
    competences: ['Biologie', 'Chimie', 'Sciences Naturelles', 'Écologie'],
    debouches: ['Médecin', 'Pharmacien', 'Biologiste', 'Vétérinaire', 'Agronome', 'Chercheur', 'Infirmier'],
    description: 'Idéale pour les amateurs de biologie et sciences du vivant.'
  },
  { 
    id: 'serie-a',
    name: 'Série A (Littérature/Langues)',
    level: '3ème',
    type: 'Série',
    competences: ['Français', 'Littérature', 'Philosophie', 'Histoire-Géographie', 'Langues'],
    debouches: ['Journaliste', 'Écrivain', 'Professeur', 'Traducteur', 'Critique', 'Historien', 'Animateur'],
    description: 'Pour les passionnés de lettres, langues et sciences humaines.'
  },
  { 
    id: 'serie-g',
    name: 'Série G (Gestion/Commerce)',
    level: '3ème',
    type: 'Série',
    competences: ['Comptabilité', 'Économie', 'Gestion', 'Commerce'],
    debouches: ['Comptable', 'Gestionnaire', 'Chef d\'entreprise', 'Commerçant', 'Secrétaire direction', 'Agent douane'],
    description: 'Débouche vers métiers de gestion, commerce et administration.'
  },
  
  // CAP/BEP
  { 
    id: 'cap-mecanique',
    name: 'CAP/BEP Mécanique Auto',
    level: '3ème',
    type: 'CAP/BEP',
    competences: ['Mécanique', 'Diagnostic', 'Réparation', 'Électricité auto'],
    debouches: ['Mécanicien automobile', 'Carrossier', 'Électricien auto', 'Responsable atelier', 'Entrepreneur'],
    description: 'Formation pratique directe aux métiers de l\'automobile.'
  },
  { 
    id: 'cap-dessin-batiment',
    name: 'CAP Dessin Bâtiment',
    level: '3ème',
    type: 'CAP/BEP',
    competences: ['Dessin technique', 'Bâtiment', 'CAO', 'Construction'],
    debouches: ['Dessinateur bâtiment', 'Technicien BTP', 'Chef de chantier', 'Architecte', 'Constructeur'],
    description: 'Formation en dessin technique et bâtiment.'
  },
  { 
    id: 'cap-comptabilite',
    name: 'CAP Comptabilité',
    level: '3ème',
    type: 'CAP/BEP',
    competences: ['Comptabilité', 'Gestion', 'Informatique', 'Fiscalité'],
    debouches: ['Comptable', 'Aide-comptable', 'Gestionnaire', 'Expert-comptable', 'Auditeur'],
    description: 'Formation en comptabilité générale et gestion.'
  },
  
  // Licences Université
  { 
    id: 'licence-informatique',
    name: 'Licence Informatique/Génie Logiciel',
    level: 'Terminale',
    type: 'Licence',
    competences: ['Programmation', 'Bases données', 'Réseaux', 'Conception logicielle'],
    debouches: ['Développeur', 'Ingénieur informatique', 'Chef projet IT', 'Data scientist', 'Administrateur systèmes'],
    description: 'Formation complète en informatique et développement logiciel.'
  },
  { 
    id: 'licence-medecine',
    name: 'Médecine & Sciences Santé',
    level: 'Terminale',
    type: 'Licence',
    competences: ['Biologie', 'Chimie', 'Anatomie', 'Physiologie'],
    debouches: ['Médecin', 'Pharmacien', 'Infirmier', 'Biologiste médical', 'Chercheur santé'],
    description: 'Programmes rigoureux en sciences médicales.'
  },
  { 
    id: 'licence-agronomie',
    name: 'Sciences Agronomiques',
    level: 'Terminale',
    type: 'Licence',
    competences: ['Agronomie', 'Écologie', 'Élevage', 'Gestion exploitation'],
    debouches: ['Agronome', 'Chercheur agricole', 'Gestionnaire exploitation', 'Conseiller agricole', 'Entrepreneur agricole'],
    description: 'Formation en agriculture moderne et développement rural.'
  },
];

export function getAllSchools(level?: '3ème' | 'Terminale' | 'Supérieur'): School[] {
  if (!level) return schools;
  return schools.filter(s => s.level === level || (level === 'Supérieur' && s.level === 'Terminale'));
}

export function getSchoolsByType(type: School['type']): School[] {
  return schools.filter(s => s.type === type);
}

export function getAllPrograms(level?: '3ème' | 'Terminale' | 'Supérieur'): Program[] {
  if (!level) return programs;
  return programs.filter(p => p.level === level || (level === 'Supérieur' && p.level === 'Terminale'));
}


function scoreProgram(profile: UserProfile, tags: string[]) {
  const interestMatch = tags.filter(tag => profile.interests.map(i => i.toLowerCase()).includes(tag.toLowerCase())).length;
  const skillMatch = tags.filter(tag => profile.skills.toLowerCase().includes(tag.toLowerCase())).length;
  return Math.min(0.95, 0.35 + interestMatch * 0.2 + skillMatch * 0.1 + 0.1);
}

export function getRecommendationsForProfile(profile: UserProfile): { recommendations: Recommendation[]; scholarships: Scholarship[]; analysis: string } {
  const level = normalizeEducation(profile.education);
  let basePrograms = level === '3ème' ? collegePrograms : lyceePrograms;

  const scoredPrograms = basePrograms.map(program => ({
    ...program,
    score: scoreProgram(profile, program.tags as string[])
  }))
  .sort((a, b) => b.score - a.score)
  .slice(0, 6);

  const interestsText = profile.interests.length ? profile.interests.join(', ') : 'tes matières préférées';
  const analysis = level === '3ème'
    ? `D'après ton niveau collège (3ème) et ton intérêt pour ${interestsText}, je te suggère d'explorer ces séries du lycée ou ces formations professionnelles (CAP/BEP) au Burkina Faso.`
    : `En tant qu'élève de lycée ou futur bachelier intéressé par ${interestsText}, voici les meilleures filières universitaires et instituts au Burkina Faso pour ton avenir. N'oublie pas de consulter les opportunités du CIOSPB et du FONER.`;

  return { recommendations: scoredPrograms, scholarships, analysis };
}

// ===================================================================
// SMART OFFLINE FALLBACK (works without Ollama installed)
// ===================================================================
function getSmartFallback(msg: string, profile: UserProfile | null): string {
  const lower = msg.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  const name = profile?.name || 'toi';
  const level = profile?.education || 'ton niveau';
  const interests = profile?.interests?.join(', ') || '';

  // Greetings
  if (/\b(salut|bonjour|hello|hey|bonsoir|coucou|slt)\b/.test(lower)) {
    return `Bonjour ${name} ! Je suis ton Conseiller IA CareerGuide, specialise dans l'orientation scolaire au Burkina Faso. Comment puis-je t'aider aujourd'hui ? Tu peux me poser des questions sur les series du BAC, les universites, les bourses, ou les formations professionnelles.`;
  }
  // Thanks
  if (/\b(merci|thanks|ok merci)\b/.test(lower)) {
    return `De rien ${name} ! N'hesite pas si tu as d'autres questions sur ton orientation. Je suis la pour t'aider.`;
  }
  // Who are you
  if (/\b(qui es[- ]tu|tu es qui|c.*quoi|comment tu t.*appel)\b/.test(lower)) {
    return `Je suis ton Conseiller IA CareerGuide ! Je suis specialise dans le systeme educatif du Burkina Faso. Je peux t'aider a choisir ta serie au lycee, trouver une universite, decouvrir les bourses disponibles (CIOSPB, FONER, AUF) ou explorer des formations professionnelles (CAP/BEP).`;
  }
  // Series
  if (/\bserie\s*c\b/.test(lower)) {
    return `La Serie C au Burkina Faso est la filiere scientifique la plus exigeante, axee sur les Mathematiques et la Physique-Chimie. Elle est ideale si tu veux poursuivre en ingenierie, informatique, mathematiques pures ou physique a l'universite. Les lycees de reference sont le Lycee Philippe Zinda Kabore et le Prytanee Militaire du Kadiogo.`;
  }
  if (/\bserie\s*d\b/.test(lower)) {
    return `La Serie D est une filiere scientifique orientee vers les Sciences de la Vie et de la Terre. C'est la voie privilegiee pour faire medecine, pharmacie, agronomie ou biologie a l'universite. Si tu aimes la nature et les sciences du vivant, c'est la serie qu'il te faut !`;
  }
  if (/\bserie\s*a\b/.test(lower)) {
    return `La Serie A est la filiere litteraire du lycee au Burkina. Elle est axee sur les Langues, la Philosophie et la Litterature. Elle ouvre les portes vers le Droit, la Communication, le Journalisme, l'Enseignement ou les Relations Internationales a l'universite.`;
  }
  if (/\bserie\s*(g|grh)\b/.test(lower) || /\bgrh\b/.test(lower)) {
    return `La Serie G (aussi appelee GRH - Gestion des Ressources Humaines) est axee sur la Gestion, le Commerce, la Comptabilite et le Secretariat. Attention, cela n'a rien a voir avec la biologie ! C'est une voie ideale pour les carrieres en entreprise, banque ou administration.`;
  }
  if (/\bserie\s*e\b/.test(lower)) {
    return `La Serie E est axee sur les Mathematiques et la Technique. Elle combine les sciences exactes avec les applications techniques et technologiques. C'est une bonne voie pour l'ingenierie technique.`;
  }
  if (/\bserie\s*f\b/.test(lower)) {
    return `La Serie F est la filiere technologique du lycee. Elle couvre les technologies industrielles et prepare aux metiers techniques avances. Elle ouvre les portes vers les BTS et les ecoles d'ingenieur.`;
  }
  if (/\b(serie|quelle serie|choisir|orientation|filiere)\b/.test(lower) && !/\b[a-g]\b/.test(lower)) {
    return `Au Burkina Faso, apres la 3eme, tu peux choisir parmi les series suivantes au lycee : Serie A (Lettres), Serie C (Maths/Physique), Serie D (Biologie/SVT), Serie E (Maths/Technique), Serie F (Technologie), Serie G (Gestion/Commerce). Tu peux aussi opter pour un CAP ou BEP si tu preferes une formation professionnelle courte. Quelle matiere aimes-tu le plus ?`;
  }
  // Bourses
  if (/\b(bourse|ciospb|foner|auf|aide financ|financement)\b/.test(lower)) {
    return `Au Burkina Faso, voici les principales bourses disponibles :\n- CIOSPB : Bourses gouvernementales nationales et internationales pour les bacheliers meritants.\n- FONER : Fonds National pour l'Education et la Recherche, offre des prets et aides financieres aux etudiants.\n- AUF : Bourses de mobilite dans l'espace francophone.\nCes bourses sont des aides financieres, pas des formations. Tu peux visiter ciospb.gov.bf pour postuler.`;
  }
  // CAP/BEP
  if (/\b(cap|bep|formation pro|professionnel)\b/.test(lower)) {
    return `Les CAP et BEP sont des formations professionnelles courtes accessibles apres la 3eme au Burkina Faso. Tu peux te former en Comptabilite, Mecanique Auto, Menuiserie, Dessin Batiment, Informatique et bien d'autres. C'est un excellent choix si tu veux apprendre un metier concret et entrer rapidement dans la vie active.`;
  }
  // University
  if (/\b(universit|fac|etude sup|apres le bac|licence|master)\b/.test(lower)) {
    return `Apres le BAC au Burkina Faso, tu peux t'inscrire dans plusieurs universites publiques : Universite Joseph Ki-Zerbo (Ouagadougou), Universite Nazi Boni (Bobo-Dioulasso), Universite Thomas Sankara (Ouagadougou), ou au Burkina Institute of Technology (Koudougou). Les filieres vont de la Medecine a l'Informatique en passant par le Droit et l'Agronomie.`;
  }
  // BEPC
  if (/\b(bepc|brevet|college|3eme|troisieme)\b/.test(lower)) {
    return `Apres le BEPC (fin de 3eme), tu as deux grandes options au Burkina : aller au lycee general (Series A, C, D, E, F, G) pour passer le BAC, ou choisir une formation professionnelle (CAP/BEP) pour apprendre un metier. Le choix depend de tes matieres fortes et de tes objectifs.`;
  }
  // Help / generic
  if (/\b(aide|help|comment|quoi faire|que faire|conseil)\b/.test(lower)) {
    return `Je peux t'aider avec plusieurs choses, ${name} :\n- Choisir ta serie au lycee (A, C, D, E, F, G)\n- Decouvrir les universites du Burkina Faso\n- Explorer les formations professionnelles (CAP/BEP)\n- Trouver des bourses d'etudes (CIOSPB, FONER, AUF)\n- Comprendre le systeme educatif burkinabe\nPose-moi ta question !`;
  }
  // Default with personalization
  if (interests) {
    return `Bonne question ! En tant qu'eleve de ${level} avec un interet pour ${interests}, je te recommande d'explorer les filieres correspondantes. Veux-tu que je t'explique les series du BAC, les universites ou les formations professionnelles au Burkina Faso ?`;
  }
  return `Je suis la pour t'aider dans ton orientation scolaire au Burkina Faso, ${name}. Tu peux me poser des questions sur les series du BAC (A, C, D, E, F, G), les universites, les bourses (CIOSPB, FONER) ou les formations professionnelles. Que souhaites-tu savoir ?`;
}

// ===================================================================
// MAIN CHAT FUNCTION
// ===================================================================
export async function getChatReply(
  message: string,
  profile: UserProfile | null,
  history: { sender: string; text: string }[] = []
): Promise<string> {
  const name = profile?.name || 'ami(e)';
  const level = profile?.education || 'ton niveau';
  const interests = profile?.interests?.slice(0, 2)?.join(', ') || 'tes centres d\'intérêt';
  
  // More human-like system prompt with conversational tone
  const systemContext = `Tu es le Conseiller IA de CareerGuide, un expert bienveillant, humain et amical en orientation scolaire au Burkina Faso.
L'utilisateur s'appelle ${name} (niveau: ${level}, intérêts: ${interests}).

Règles strictes :
- Sois très chaleureux, empathique et naturel (comme un humain qui discute et donne des conseils).
- Fournis exactement les informations demandées par l'utilisateur (ex: liste d'établissements, bourses disponibles, filières).
- Utilise le tutoiement ("tu").
- Sois concis et direct (maximum 3 à 4 phrases).
- Ne fais pas de longues listes, privilégie des réponses sous forme de paragraphes naturels.
- N'ajoute pas de salutations répétitives si la conversation est déjà en cours.`;

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000); // 5s max pour éviter trop d'attente

    const response = await fetch('http://127.0.0.1:11434/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'gemma:2b',
        messages: [
          { role: 'system', content: systemContext },
          // Include only last 8 exchanges for context (max 16 entries)
          ...history.slice(-16).map(msg => ({ 
            role: msg.sender === 'user' ? 'user' : 'assistant', 
            content: msg.text 
          })),
          { role: 'user', content: message }
        ],
        stream: false,
        options: {
          temperature: 0.5,  // Slightly higher for more natural conversation
          top_p: 0.9,
          num_predict: 150,  // Shorter responses for speed
          repeat_penalty: 1.15
        }
      }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (response.ok) {
      const data = await response.json();
      let reply = data.response?.trim();

      if (reply && reply.length > 8) {
        // Clean up potential model artifacts
        reply = reply.replace(/^(Conseiller|Assistant|AI|[*#]+)\s*:\s*/gi, '').trim();
        reply = reply.replace(/^\n+/, '').replace(/\n+$/, '').trim();
        
        // If response is too short after cleanup, use fallback
        if (reply.length > 10) {
          return reply;
        }
      }
    }
  } catch (error) {
    // Ollama timeout or error - use fallback silently
    console.log('Ollama non disponible ou timeout.');
  }

  // Fallback: Smart rules-based response (works offline)
  return getSmartFallback(message, profile);
}

// Cache for Wikipedia summaries
// const wikiCache = new Map<string, string>();

// Helper to fetch Wikipedia summary (Unused, commented out)
/*
async function fetchWikiSummary(query: string): Promise<string> {
  const key = query.toLowerCase().trim();
  if (wikiCache.has(key)) return wikiCache.get(key) as string;
  try {
    const resp = await fetch(`https://fr.wikipedia.org/api/rest_v1/page/summary/${encodeURIComponent(key)}`);
    if (!resp.ok) return '';
    const data = await resp.json();
    const summary = data.extract || '';
    if (summary) wikiCache.set(key, summary.substring(0, 200));
    return wikiCache.get(key) || '';
  } catch {
    return '';
  }
}
*/

// ===================================================================
// AI RECOMMENDATION ANALYSIS & DYNAMIC QUESTIONS
// ===================================================================
export async function generateDynamicQuestions(level: string): Promise<string[]> {
  const systemContext = `Tu es un conseiller d'orientation au Burkina Faso. Génère exactement 3 questions courtes et pertinentes pour aider un élève de niveau "${level}" à trouver sa voie. Renvoie UNIQUEMENT les 3 questions, une par ligne, sans introduction ni conclusion.`;
  
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8s max

    const response = await fetch('http://127.0.0.1:11434/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'gemma:2b',
        messages: [{ role: 'user', content: systemContext }],
        stream: false,
        options: { temperature: 0.6, num_predict: 150 }
      }),
      signal: controller.signal,
    });
    clearTimeout(timeoutId);

    if (response.ok) {
      const data = await response.json();
      const reply = data.message?.content?.trim() || data.response?.trim();
      if (reply) {
        const questions = reply.split('\n')
          .map((q: string) => q.replace(/^[\d\-\.\*]+\s*/, '').trim())
          .filter((q: string) => q.length > 5);
        if (questions.length >= 2) return questions.slice(0, 3);
      }
    }
  } catch (error) {
    console.log('Erreur génération questions dynamiques:', error);
  }

  // Fallback sensible to the level
  if (level.includes('3ème') || level.includes('3eme')) {
    return [
      "Quelles sont tes matières préférées au collège ?",
      "Préfères-tu la théorie ou la pratique ?",
      "Quel métier te fait rêver pour plus tard ?"
    ];
  } else {
    return [
      "Quelles sont tes matières fortes au lycée ?",
      "Préfères-tu les études longues (Université) ou courtes (Institut) ?",
      "Dans quel domaine aimerais-tu travailler ?"
    ];
  }
}

export async function generateAIRecommendationAnalysis(profile: UserProfile, specificLevel?: string, questionnaireAnswers?: string): Promise<string> {
  const name = profile.name || 'Élève';
  const level = specificLevel || profile.education || 'Non précisé';
  const interests = profile.interests.length ? profile.interests.join(', ') : 'Aucun renseigné';
  const skills = profile.skills || 'Non précisées';
  const goals = profile.goals || 'Non précisés';

  const systemContext = `Tu es un expert amical en orientation scolaire au Burkina Faso.`;
  // If questionnaireAnswers is provided, use it as the primary input and produce a concise analysis
  const prompt = questionnaireAnswers
    ? `Analyse de manière synthétique et chaleureuse (3-4 phrases) les réponses suivantes de l'élève (${level}) et fournis un texte d'analyse pour des recommandations de filières au Burkina Faso. Ne pose PAS de questions supplémentaires.
Réponses de l'élève: ${questionnaireAnswers}
Profil stocké: passions(${interests}), compétences(${skills}).` 
    : `Analyse le profil de ${name} pour lui faire des recommandations d'orientation méticuleuses.
Niveau: ${level}
Passions/Intérêts: ${interests}
Compétences: ${skills}
Vœux/Objectifs: ${goals}
Fais une analyse personnalisée d'environ 3 phrases.`;

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 15000); // 15s max for analysis

    const response = await fetch('http://127.0.0.1:11434/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'gemma:2b',
        messages: [
          { role: 'system', content: systemContext },
          { role: 'user', content: prompt }
        ],
        stream: false,
        options: {
          temperature: 0.5,
          top_p: 0.9,
          num_predict: 250
        }
      }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (response.ok) {
      const data = await response.json();
      let reply = data.message?.content?.trim() || data.response?.trim();

      if (reply) {
        reply = reply.replace(/^(Conseiller|Expert|Analyse)\s*:\s*/i, '').trim();
        reply = reply.replace(/[*#]/g, '').trim();
        if (reply.length > 20) return reply;
      }
    }
  } catch (error) {
    console.log('Erreur lors de la génération de l\'analyse IA:', error);
  }

  // Fallback si l'IA échoue
  return `D'après ton niveau (${level}) et tes passions (${interests}), je te conseille d'explorer les filières qui correspondent le mieux à tes compétences. Prends le temps de te renseigner sur les établissements adaptés à tes objectifs au Burkina Faso.`;
}

export function getDynamicRecommendations(profile: UserProfile, answer: string, specificLevel?: string): Recommendation[] {
  const level = normalizeEducation(specificLevel || profile.education);
  let basePrograms = level === '3ème' ? collegePrograms : lyceePrograms;
  const answerLower = answer.toLowerCase();

  const scoredPrograms = basePrograms.map(program => {
    let score = scoreProgram(profile, program.tags as string[]);
    // Boost score based on user's answer to the AI's questions
    const matchCount = (program.tags as string[]).filter(tag => answerLower.includes(tag.toLowerCase())).length;
    score += matchCount * 0.15; // +15% per matching keyword in their answer
    
    // Cap score at 99%
    score = Math.min(0.99, score);
    
    return {
      ...program,
      score
    };
  })
  .sort((a, b) => b.score - a.score);

  // Return top 3 or 5 depending on the highest score
  const topScore = scoredPrograms[0]?.score || 0;
  const count = topScore > 0.8 ? 5 : 3;
  return scoredPrograms.slice(0, count);
}

export function getScholarships(): Scholarship[] {
  return scholarships;
}
