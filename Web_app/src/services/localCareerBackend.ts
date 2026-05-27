export interface UserProfile {
  name: string;
  age?: string;
  education: string;
  interests: string[];
  skills: string;
  goals: string;
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
}

const BACKEND_URL = 'http://127.0.0.1:8000';

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
  const name = profile?.name || '';
  const level = profile?.education || '';

  // Build a SHORT prompt (crucial for gemma:2b)
  const shortPrompt = `Tu es un conseiller scolaire au Burkina Faso. Reponds en francais en 2-3 phrases. L'eleve s'appelle ${name || 'inconnu'} et est en ${level || 'niveau inconnu'}. Un eleve te dit: ${message}. Que reponds-tu?`;

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 15000); // 15s max

    const response = await fetch('http://127.0.0.1:11434/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'gemma:2b',
        prompt: shortPrompt,
        stream: false,
        options: {
          temperature: 0.4,
          top_p: 0.85,
          num_predict: 100,
        }
      }),
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (response.ok) {
      const data = await response.json();
      let reply = data.response?.trim();

      // Basic cleanup
      if (reply) {
        // Remove role prefixes if model hallucinates them
        reply = reply.replace(/^(Conseiller|Assistant|Réponse)\s*:\s*/i, '').trim();
        // Stop if model starts role-playing as the student
        if (reply.includes('Élève:') || reply.includes('Eleve:')) {
          reply = reply.split(/[EÉ]l[eè]ve\s*:/i)[0].trim();
        }
        // Remove markdown artifacts
        reply = reply.replace(/[*#]/g, '').trim();

        if (reply.length > 10) return reply;
      }
    }
  } catch (error) {
    console.log('Ollama non disponible, utilisation du bot integre.');
  }

  // Fallback: Smart rules-based bot (works without Ollama)
  return getSmartFallback(message, profile);
}
