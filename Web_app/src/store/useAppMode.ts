import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface AppModeState {
  isOnline: boolean;
  setOnlineMode: (online: boolean) => void;
  toggleMode: () => void;
}

export const useAppMode = create<AppModeState>()(
  persist(
    (set) => ({
      isOnline: false, // Offline by default
      setOnlineMode: (online) => set({ isOnline: online }),
      toggleMode: () => set((state) => ({ isOnline: !state.isOnline })),
    }),
    {
      name: 'careerguide-app-mode',
    }
  )
);
