import { BURKINA_SCHOOLS, BURKINA_PROGRAMS } from '../data/burkina_data';

export interface UserProfile {
  name: string;
  age?: string;
  education: string;
  interests: string[];
  skills: string;
  goals: string;
  questionnaireAnswers?: Record<string, string | string[]>;
  bacSeries?: string;
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
  maps?: string;
}

export interface Program {
  id: string;
  name: string;
  level: '3ème' | 'Terminale' | 'Supérieur';
  type: 'Série' | 'CAP/BEP' | 'Licence' | 'Master' | 'Diplôme';
  debouches: string[];
  competences: string[];
  description?: string;
  universites?: string[];
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
  programDetails?: Program;
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
const collegePrograms: Recommendation[] = BURKINA_PROGRAMS.filter(p => p.level === '3ème').map(p => ({
  program: p.name,
  type: p.type as any,
  tags: p.competences.map(c => c.toLowerCase()),
  schools: p.universites ? p.universites.map(u => ({ name: u, city: '' })) : [],
  score: 0
}));

const lyceePrograms: Recommendation[] = BURKINA_PROGRAMS.filter(p => p.level === 'Terminale' || p.level === 'Supérieur').map(p => ({
  program: p.name,
  type: p.type as any,
  tags: p.competences.map(c => c.toLowerCase()).concat([p.category.toLowerCase()]),
  schools: p.universites ? p.universites.map(u => ({ name: u, city: '' })) : [],
  score: 0
}));

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

export function getAllSchools(level?: '3ème' | 'Terminale' | 'Supérieur'): School[] {
  const schools = BURKINA_SCHOOLS as School[];
  if (!level) return schools;
  return schools.filter(s => s.level === level || (level === 'Supérieur' && s.level === 'Terminale'));
}

export function getSchoolsByType(type: School['type']): School[] {
  return (BURKINA_SCHOOLS as School[]).filter(s => s.type === type);
}

export function getAllPrograms(level?: '3ème' | 'Terminale' | 'Supérieur'): Program[] {
  const programs = BURKINA_PROGRAMS as Program[];
  if (!level) return programs;
  return programs.filter(p => p.level === level || (level === 'Supérieur' && p.level === 'Terminale'));
}

function scoreProgram(profile: UserProfile, tags: string[]) {
  const interestMatch = tags.filter(tag => profile.interests.map(i => i.toLowerCase()).includes(tag.toLowerCase())).length;
  const skillMatch = tags.filter(tag => profile.skills.toLowerCase().includes(tag.toLowerCase())).length;
  const rawScore = Math.min(0.95, 0.35 + interestMatch * 0.2 + skillMatch * 0.1 + 0.1);
  return Math.round(rawScore * 100);
}

export function getRecommendationsForProfile(profile: UserProfile): { recommendations: Recommendation[]; scholarships: Scholarship[]; analysis: string } {
  const level = normalizeEducation(profile.education);
  let basePrograms = level === '3ème' ? collegePrograms : lyceePrograms;

  const scoredPrograms = basePrograms.map(program => {
    const originalProgram = BURKINA_PROGRAMS.find(p => p.name === program.program);
    return {
      ...program,
      score: scoreProgram(profile, program.tags as string[]),
      programDetails: originalProgram as Program
    };
  })
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


// ===================================================================
// HYBRID AI CALL HELPER (Ollama -> Groq -> Fallback)
// ===================================================================
import { useOfflineStore } from '../store/useOfflineStore';

async function fetchOllama(prompt: string, maxTokens: number = 2000): Promise<string> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 60000); // 60s timeout for local Ollama

  const response = await fetch('http://localhost:11434/api/chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      model: 'qwen2.5:7b',
      messages: [{role: 'user', content: prompt}],
      stream: false,
      options: {
        temperature: 0.8,
        top_p: 0.9,
        num_predict: maxTokens,
        num_ctx: 4096
      }
    }),
    signal: controller.signal,
  });

  clearTimeout(timeoutId);

  if (!response.ok) {
    throw new Error('Erreur API Ollama');
  }

  const data = await response.json();
  return data.message?.content?.trim() || data.response?.trim() || '';
}

async function fetchGroq(messages: { role: string; content: string }[], maxTokens = 150, temperature = 0.5): Promise<string> {
  const apiKey = import.meta.env.VITE_GROQ_API_KEY;
  if (!apiKey) {
    throw new Error("Clé API Groq manquante.");
  }

  const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`
    },
    body: JSON.stringify({
      model: 'llama3-8b-8192',
      messages: messages,
      temperature: temperature,
      max_tokens: maxTokens,
      top_p: 0.9
    })
  });

  if (!response.ok) {
    throw new Error('Erreur API Groq');
  }

  const data = await response.json();
  return data.choices?.[0]?.message?.content || '';
}

export async function fetchAI(messages: { role: string; content: string }[], maxTokens = 150, temperature = 0.5): Promise<string> {
  const store = useOfflineStore.getState();
  
  const useOnlineApi = store.isOnline && !store.isOffline;

  if (useOnlineApi) {
    try {
      const reply = await fetchGroq(messages, maxTokens, temperature);
      store.setAIEngineStatus('groq');
      return reply;
    } catch (err) {
      console.log('Groq API non disponible. Essai avec Ollama...', err);
      // Fallback to local Ollama if Groq fails
    }
  }

  // Try Ollama Local (when offline, or when Groq fails)
  try {
    const reply = await fetchOllama(JSON.stringify(messages), maxTokens);
    store.setAIEngineStatus('ollama');
    return reply;
  } catch (err) {
    console.log('Ollama local non disponible. Mode hors-ligne activé.', err);
    store.setAIEngineStatus('offline');
    throw new Error('All AI engines failed');
  }
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
  const systemContext = `Tu es CareerGuide IA.

Tu es un assistant IA moderne et conversationnel spécialisé dans l’orientation scolaire et professionnelle.

Tu aides les étudiants du Burkina Faso à trouver leur voie.

Tu dois parler naturellement comme ChatGPT ou Meta AI.

IMPORTANT :
- sois humain
- sois fluide
- sois interactif
- sois intelligent
- réponses courtes
- une seule question à la fois
- jamais de réponses robotiques
- jamais de templates
- jamais de placeholders
- jamais de longues listes

Tu dois :
- comprendre le contexte
- mémoriser la discussion
- répondre naturellement
- guider progressivement l’utilisateur

Ton ton :
- chaleureux
- moderne
- motivant
- conversationnel

Exemple :

Utilisateur :
"salut"

Réponse :
"Salut 👋 ! Ravi de discuter avec toi. Tu réfléchis déjà à un métier précis ou tu explores encore les possibilités ?"

Utilisateur :
"je veux devenir médecin"

Réponse :
"Très beau projet 😊
Tu es actuellement en quelle classe ?"

Tu fonctionnes hors ligne avec Ollama.
Profil de l'utilisateur actuel: Nom: ${name}, Niveau: ${level}, Intérêts: ${interests}.`;

  try {
    const messages = [
      { role: 'system', content: systemContext },
      ...history.slice(-16).map(msg => ({ 
        role: msg.sender === 'user' ? 'user' : 'assistant', 
        content: msg.text 
      })),
      { role: 'user', content: message }
    ];

    let reply = await fetchAI(messages, 200, 0.6);
    reply = reply.trim();

    if (reply && reply.length > 8) {
      // Clean up potential model artifacts
      reply = reply.replace(/^(Conseiller|Assistant|AI|[*#]+)\s*:\s*/gi, '').trim();
      reply = reply.replace(/^\n+/, '').replace(/\n+$/, '').trim();
      
      if (reply.length > 10) {
        return reply;
      }
    }
  } catch (error) {
    console.log('API Cloud non disponible et Ollama introuvable.', error);
  }

  // Fallback si l'IA échoue ou si hors-ligne sans modèle local
  return "Désolé, je ne peux pas générer de réponse personnalisée en mode hors-ligne sans le modèle IA (Ollama) installé sur ton appareil. Connecte-toi à internet pour discuter avec moi !";
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
export async function generateDynamicQuestions(profile: UserProfile): Promise<string[]> {
  const education = profile.education || 'Non précisé';
  const interests = profile.interests.length ? profile.interests.join(', ') : 'sans préférence particulière';
  const skills = profile.skills || 'non indiqué';
  const goals = profile.goals || 'non précisé';

  const systemContext = `Tu es un conseiller d'orientation au Burkina Faso. Génère exactement 3 questions courtes, simples et personnalisées pour aider un élève de niveau "${education}" à trouver sa voie. Utilise ses passions (${interests}), ses compétences (${skills}) et ses objectifs (${goals}) pour formuler des questions qui permettent de choisir une série, une filière, ou un établissement. Renvoie UNIQUEMENT les 3 questions, une par ligne, sans introduction ni conclusion.`;
  
  try {
    const reply = await fetchAI([{ role: 'user', content: systemContext }], 150, 0.6);
    if (reply) {
      const questions = reply.split('\n')
        .map((q: string) => q.replace(/^[\d\-\.\*]+\s*/, '').trim())
        .filter((q: string) => q.length > 5);
      if (questions.length >= 2) return questions.slice(0, 3);
    }
  } catch (error) {
    console.log('Erreur génération questions dynamiques:', error);
  }

  // Fallback sensible à l'éducation
  if (education.includes('3ème') || education.includes('3eme')) {
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
    ? `Analyse de manière synthétique et chaleureuse (3-4 phrases) les réponses suivantes de l'élève (${level}) et fournis un texte d'analyse pour des recommandations de filières, séries ou établissements au Burkina Faso. Utilise ses passions (${interests}), ses compétences (${skills}) et ses objectifs (${goals}). Ne parle PAS de bourses et ne pose PAS de questions supplémentaires.
Réponses de l'élève: ${questionnaireAnswers}
Profil stocké: passions(${interests}), compétences(${skills}), objectifs(${goals}).` 
    : `Analyse le profil de ${name} pour lui faire des recommandations d'orientation méticuleuses vers des filières, séries ou établissements. Niveau: ${level}
Passions/Intérêts: ${interests}
Compétences: ${skills}
Vœux/Objectifs: ${goals}
Fais une analyse personnalisée, claire et chaleureuse d'environ 3 phrases. Ne mentionne pas les bourses.`;

  try {
    let reply = await fetchAI([
      { role: 'system', content: systemContext },
      { role: 'user', content: prompt }
    ], 250, 0.5);

    if (reply) {
      reply = reply.replace(/^(Conseiller|Expert|Analyse)\s*:\s*/i, '').trim();
      reply = reply.replace(/[*#]/g, '').trim();
      if (reply.length > 20) return reply;
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
  const interestsLower = profile.interests.map(i => i.toLowerCase()).join(' ');
  const goalsLower = profile.goals.toLowerCase();

  const scoredPrograms = basePrograms.map(program => {
    let score = scoreProgram(profile, program.tags as string[]);
    const matchCount = (program.tags as string[]).filter(tag => answerLower.includes(tag.toLowerCase())).length;
    const interestMatch = (program.tags as string[]).filter(tag => interestsLower.includes(tag.toLowerCase())).length;
    const goalMatch = (program.tags as string[]).filter(tag => goalsLower.includes(tag.toLowerCase())).length;

    score += matchCount * 0.12;
    score += interestMatch * 0.1;
    score += goalMatch * 0.08;

    // Add a small boost if the program name or description contains one of the user's custom interests
    const customMatch = profile.interests.filter(interest => !['technologie','art & design','science','business','santé','social','écologie','sport','médias'].includes(interest.toLowerCase()))
      .filter(interest => program.program.toLowerCase().includes(interest.toLowerCase()) || (program.tags as string[]).some(tag => tag.toLowerCase().includes(interest.toLowerCase()))).length;
    score += customMatch * 0.12;

    score = Math.min(0.99, score);
    return {
      ...program,
      score
    };
  })
  .sort((a, b) => b.score - a.score);

  return scoredPrograms.slice(0, 5);
}

export function getScholarships(): Scholarship[] {
  return scholarships;
}

// ===================================================================
// AI SEARCH FUNCTION
// ===================================================================
export async function searchAIInfo(query: string, context: 'établissement' | 'filière'): Promise<string> {
  const systemContext = `Tu es un expert du système éducatif au Burkina Faso. 
L'utilisateur recherche des informations sur un(e) ${context} : "${query}".
Règles :
- Réponds avec précision, véracité et concision (3 à 4 phrases).
- Ne dis pas "je ne sais pas". Si tu ne connais pas cet(te) ${context} spécifique, donne des informations générales utiles sur ce type de ${context} au Burkina Faso.`;

  try {
    const reply = await fetchAI([{ role: 'system', content: systemContext }, { role: 'user', content: query }], 250, 0.4);
    if (reply) return reply;
  } catch (error) {
    console.log('AI search failed', error);
  }

  return `Aucune information détaillée n'a pu être trouvée en mode hors-ligne pour "${query}". Veuillez vérifier l'orthographe ou vous connecter à internet.`;
}
