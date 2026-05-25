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

interface OfflineState {
  profile: UserProfile | null;
  setProfile: (profile: UserProfile) => void;
  isOffline: boolean;
  setOfflineStatus: (status: boolean) => void;
  lastSync: string | null;
  setLastSync: (date: string) => void;
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

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
    }),
    {
      name: 'careerguide-storage',
      storage: createJSONStorage(() => localStorage),
    }
  )
);
