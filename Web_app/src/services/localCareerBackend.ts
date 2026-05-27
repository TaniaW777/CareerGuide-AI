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

export async function getChatReply(
  message: string,
  profile: UserProfile | null,
  history: { sender: string; text: string }[] = []
): Promise<string> {
  const profileContext = profile 
    ? `Prénom: ${profile.name} | Niveau: ${profile.education} | Intérêts: ${profile.interests.join(', ')} | Compétences: ${profile.skills} | Objectif: ${profile.goals}` 
    : 'Profil non renseigné';

  // Smart Offline Fallback (Rules-based bot) when Ollama is not available
  const getFallbackReply = (msg: string) => {
    const lower = msg.toLowerCase();
    const name = profile?.name || "toi";
    const level = profile?.education || "ton niveau";

    if (lower.includes('salut') || lower.includes('bonjour') || lower.includes('hello')) {
      return `Bonjour ${name} ! Je suis ton Conseiller IA CareerGuide. Comment puis-je t'aider dans ton orientation aujourd'hui ?`;
    }
    if (lower.includes('bourse') || lower.includes('ciospb') || lower.includes('foner') || lower.includes('auf')) {
      return "Au Burkina Faso, tu peux demander des aides financières (bourses) via le CIOSPB pour les études universitaires, ou le FONER pour un prêt ou une aide. L'AUF propose aussi des bourses pour la francophonie. As-tu déjà ton BAC ?";
    }
    if (lower.includes('série c') || lower.includes('serie c')) {
      return "La Série C est une filière très scientifique axée sur les Mathématiques et la Physique-Chimie. C'est parfait si tu veux faire de l'ingénierie, de l'informatique ou de la recherche.";
    }
    if (lower.includes('série d') || lower.includes('serie d') || lower.includes('biologie') || lower.includes('médecine')) {
      return "La Série D est orientée vers les Sciences de la Vie et de la Terre. C'est la voie privilégiée pour faire médecine, pharmacie, agronomie ou biologie à l'université.";
    }
    if (lower.includes('grh') || lower.includes('gestion') || lower.includes('commerce') || lower.includes('série g')) {
      return "La Série G et les filières GRH (Gestion des Ressources Humaines) sont axées sur le management, le secrétariat et la comptabilité. Cela n'a rien à voir avec la biologie !";
    }
    if (lower.includes('cap') || lower.includes('bep')) {
      return "Les CAP et BEP sont d'excellentes formations professionnelles courtes (Menuiserie, Comptabilité, Mécanique, etc.) idéales si tu veux apprendre un métier concret rapidement après la 3ème.";
    }
    if (lower.includes('université') || lower.includes('fac')) {
      return "Après le BAC, tu peux t'inscrire dans des universités publiques comme Joseph Ki-Zerbo (Ouaga) ou Nazi Boni (Bobo-Dioulasso), ou dans des instituts privés comme le BIT à Koudougou.";
    }
    
    return `C'est une excellente question pour ton orientation. En tant qu'élève de ${level}, je te conseille de bien analyser tes matières fortes. Veux-tu explorer les filières scientifiques, littéraires ou professionnelles ?`;
  };

  const systemContext = `Tu es un conseiller d'orientation scolaire expert, strict et concis, basé au Burkina Faso. 
RÈGLES STRICTES : Ne génère JAMAIS de markdown (pas de *, pas de #). Réponds en 2 ou 3 phrases simples et directes. N'invente rien. 
Rappel: Série G/GRH = Gestion/Commerce (PAS Biologie). CIOSPB = Bourse (PAS une école). Série C = Maths/Physique.
Profil de l'élève : ${profileContext}.`;

  // Gemma models struggle with separate 'system' roles. We merge it into the user prompt or use a single user prompt for context.
  const recentHistory = history.slice(-6).map(msg => `${msg.sender === 'user' ? 'Élève' : 'Conseiller'}: ${msg.text}`).join('\n');
  
  const finalPrompt = `${systemContext}\n\nHistorique récent:\n${recentHistory}\n\nÉlève: ${message}\nConseiller:`;

  try {
    const response = await fetch('http://127.0.0.1:11434/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'gemma:2b',
        prompt: finalPrompt,
        stream: false,
        options: {
          temperature: 0.3, // Lower temperature to stop hallucinations
          top_p: 0.8,
          num_predict: 150,
        }
      }),
    });

    if (response.ok) {
      const data = await response.json();
      let reply = data.response?.trim();
      
      // Cleanup common gemma hallucinations if it mimics the user
      if (reply.startsWith('Conseiller:')) reply = reply.replace('Conseiller:', '').trim();
      if (reply.includes('Élève:')) reply = reply.split('Élève:')[0].trim();
      
      if (reply && reply.length > 5) return reply;
    }
  } catch (error) {
    console.error('Erreur connexion Ollama. Utilisation du fallback intégré:', error);
  }

  // Fallback if Ollama is not installed or fails (Zero-install offline mode)
  return getFallbackReply(message);
}


