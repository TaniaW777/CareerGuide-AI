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

  const systemPrompt = `Tu es un conseiller d'orientation scolaire professionnel, chaleureux et attentif, basé au Burkina Faso. Tu parles uniquement en français. Tu dois TOUJOURS lire tout l'historique de la conversation avant de répondre et tenir compte du contexte complet de la discussion.

CONNAISSANCE DU SYSTÈME ÉDUCATIF DU BURKINA FASO :
- Collège : 6ème, 5ème, 4ème, 3ème → diplôme BEPC
- Lycée : 2nde, 1ère, Terminale → diplôme BAC
- Série A : Lettres, Langues et Communication
- Série C : Mathématiques et Physique-Chimie (scientifique pur)
- Série D : Sciences de la Vie et de la Terre / Biologie
- Série E : Mathématiques et Technique
- Série F : Technologies industrielles
- Série G : Gestion, Commerce, Comptabilité
- CAP / BEP : Formations professionnelles courtes (Comptabilité, Mécanique, Menuiserie, Informatique, etc.)
- Bac Pro : Continuation du CAP/BEP
- Universités principales : Joseph Ki-Zerbo (Ouaga), Nazi Boni (Bobo), Thomas Sankara (Ouaga), BIT (Koudougou)
- Bourses : CIOSPB, FONER, AUF

RÈGLES DE COMPORTEMENT :
1. Lis toujours l'historique de la conversation avant de répondre.
2. Si l'élève a déjà posé des questions sur un sujet, fais référence à ce qui a été dit.
3. Sois concis mais complet. Donne des conseils concrets adaptés au Burkina Faso.
4. Ne génère JAMAIS de markdown dans tes réponses (pas de **, pas de #, pas de *). Écris en texte plat naturel.
5. Réponds toujours à la question précise posée.

Profil de l'élève : ${profileContext}`;

  // Build full conversation history for Ollama
  const conversationMessages = [
    { role: 'system', content: systemPrompt },
    // Include previous chat history (skip the first AI greeting, keep last 10 exchanges max)
    ...history.slice(-20).map(msg => ({
      role: msg.sender === 'user' ? 'user' : 'assistant',
      content: msg.text
    })),
    // Add the new user message
    { role: 'user', content: message }
  ];

  try {
    const response = await fetch('http://127.0.0.1:11434/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'gemma:2b',
        messages: conversationMessages,
        stream: false,
        options: {
          temperature: 0.7,
          top_p: 0.9,
          num_predict: 300,
        }
      }),
    });

    if (response.ok) {
      const data = await response.json();
      const reply = data.message?.content?.trim();
      if (reply) return reply;
    }
  } catch (error) {
    console.error('Erreur connexion Ollama:', error);

    // Fallback to FastAPI backend
    try {
      const fallbackResponse = await fetch(`${BACKEND_URL}/chat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          message: message, 
          profile: profile ? {
            name: profile.name,
            education: profile.education,
            interests: profile.interests,
            skills: profile.skills,
            goals: profile.goals
          } : {}
        }),
      });

      if (fallbackResponse.ok) {
        const json = await fallbackResponse.json();
        if (json.reply) return json.reply;
      }
    } catch (backendError) {
      console.error('Erreur fallback backend:', backendError);
    }
  }

  return "Je rencontre un problème de connexion avec Ollama. Vérifiez qu'Ollama est bien lancé sur votre ordinateur (ollama serve).";
}


