import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';

interface UserProfile {
  name: string;
  age?: string;
  education: string;
  interests: string[];
  skills: string;
  goals: string;
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
  lastSync: string | null;
  setLastSync: (date: string) => void;
  theme: 'light' | 'dark';
  toggleTheme: () => void;
  setTheme: (theme: 'light' | 'dark') => void;
  // Chat history — persists across page navigation, resets only on clearStorage
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
      lastSync: null,
      setLastSync: (lastSync) => set({ lastSync }),
      theme: 'light',
      toggleTheme: () => set((state) => ({ theme: state.theme === 'light' ? 'dark' : 'light' })),
      setTheme: (theme) => set({ theme }),
      chatHistory: [DEFAULT_AI_MESSAGE],
      addChatMessage: (msg) => set((state) => ({
        chatHistory: [...state.chatHistory, msg]
      })),
      clearChatHistory: () => set({ chatHistory: [DEFAULT_AI_MESSAGE] }),
      clearStorage: () => {
        localStorage.removeItem('careerguide-storage');
        set({ profile: null, lastSync: null, theme: 'light', isOffline: !navigator.onLine, chatHistory: [DEFAULT_AI_MESSAGE] });
      },
    }),
    {
      name: 'careerguide-storage',
      storage: createJSONStorage(() => localStorage),
    }
  )
);
