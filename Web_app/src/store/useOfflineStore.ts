import type { Recommendation } from '../services/localCareerBackend';
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';

interface UserProfile {
  name: string;
  age?: string;
  education: string;
  interests: string[];
  skills: string;
  goals: string;
  questionnaireAnswers?: Record<string, string | string[]>;
  bacSeries?: string;
}

export interface ChatMessage {
  id: number;
  text: string;
  sender: 'user' | 'ai';
  timestamp: number;
}

interface OfflineState {
  profile: UserProfile | null;
  setProfile: (profile: UserProfile) => void;
  isOffline: boolean;
  setOfflineStatus: (status: boolean) => void;
  forcedOffline: boolean;
  setForcedOffline: (status: boolean) => void;
  isOnline: boolean;
  setOnlineStatus: (status: boolean) => void;
  lastSync: string | null;
  setLastSync: (date: string) => void;
  schoolLevel: string;
  setSchoolLevel: (level: string) => void;
  theme: 'light' | 'dark';
  toggleTheme: () => void;
  setTheme: (theme: 'light' | 'dark') => void;
  aiEngineStatus: 'ollama' | 'groq' | 'offline' | 'checking';
  setAIEngineStatus: (status: 'ollama' | 'groq' | 'offline' | 'checking') => void;
  embeddedAIEnabled: boolean;
  setEmbeddedAIEnabled: (status: boolean) => void;
  embeddedAIStatus: 'loading' | 'ready' | 'error' | 'checking';
  setEmbeddedAIStatus: (status: 'loading' | 'ready' | 'error' | 'checking') => void;
  // Persist latest AI analysis and recommendations
  savedAnalysis: string | null;
  savedRecommendations: Recommendation[] | null;
  saveAIResults: (analysis: string, recommendations: Recommendation[]) => void;
  // AI analysis history – each entry stores the analysis text, recommendations and timestamp
  analysisHistory: { analysis: string; recommendations: Recommendation[]; timestamp: number }[];
  addAnalysisEntry: (entry: { analysis: string; recommendations: Recommendation[]; timestamp: number }) => void;
  chatHistory: ChatMessage[];
  addChatMessage: (msg: ChatMessage) => void;
  clearChatHistory: () => void;
  clearStorage: () => void;
}

const DEFAULT_AI_MESSAGE: ChatMessage = {
  id: 1,
  text: "Bonjour ! Je suis votre Conseiller IA CareerGuide. Je suis là pour vous aider dans votre orientation scolaire et professionnelle au Burkina Faso. Que souhaitez-vous savoir ?",
  sender: 'ai',
  timestamp: Date.now(),
};

export const useOfflineStore = create<OfflineState>()(
  persist(
    (set) => ({
      profile: null,
      setProfile: (profile) => set({ profile }),
      isOffline: !navigator.onLine,
      setOfflineStatus: (status) => set({ isOffline: status }),
      forcedOffline: true,
      setForcedOffline: (status) => set({ forcedOffline: status }),
      isOnline: false,
      setOnlineStatus: (status) => set({ isOnline: status }),
      lastSync: null,
      setLastSync: (lastSync) => set({ lastSync }),
      schoolLevel: '',
      setSchoolLevel: (level) => set({ schoolLevel: level }),
      theme: 'light',
      toggleTheme: () => set((state) => ({ theme: state.theme === 'light' ? 'dark' : 'light' })),
      setTheme: (theme) => set({ theme }),
      aiEngineStatus: 'checking',
      setAIEngineStatus: (status) => set({ aiEngineStatus: status }),
      embeddedAIEnabled: true,
      setEmbeddedAIEnabled: (status) => set({ embeddedAIEnabled: status }),
      embeddedAIStatus: 'checking',
      setEmbeddedAIStatus: (status) => set({ embeddedAIStatus: status }),
      // Persist latest AI analysis and recommendations
      savedAnalysis: null,
      savedRecommendations: null,
      saveAIResults: (analysis, recommendations) => set({ savedAnalysis: analysis, savedRecommendations: recommendations }),
      // Initialize analysis history with empty array
      analysisHistory: [],
      // Add a new analysis entry to history (replaces current if needed)
      addAnalysisEntry: (entry) => set((state) => ({
        analysisHistory: [...state.analysisHistory.filter(e => e.timestamp !== entry.timestamp), entry]
      })),
      chatHistory: [DEFAULT_AI_MESSAGE],
      addChatMessage: (msg) => set((state) => ({
        chatHistory: [...state.chatHistory, msg]
      })),
      clearChatHistory: () => set({ chatHistory: [DEFAULT_AI_MESSAGE] }),
      clearStorage: () => {
          localStorage.removeItem('careerguide-storage');
          set({ profile: null, lastSync: null, theme: 'light', isOffline: !navigator.onLine, forcedOffline: false, embeddedAIEnabled: true, embeddedAIStatus: 'checking', schoolLevel: '', chatHistory: [DEFAULT_AI_MESSAGE], analysisHistory: [], aiEngineStatus: 'checking' });
      },
    }),
    {
      name: 'careerguide-storage',
      storage: createJSONStorage(() => localStorage),
    }
  )
);
