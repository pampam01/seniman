import { create } from 'zustand';

interface User {
  id: string;
  email: string;
  user_type: 'seniman' | 'klien' | 'admin';
  first_name: string | null;
  last_name: string | null;
  profile_picture_url: string | null;
  is_verified: boolean;
}

interface AuthState {
  user: User | null;
  isLoading: boolean;
  setUser: (user: User | null) => void;
  setLoading: (isLoading: boolean) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  isLoading: true,
  setUser: (user) => set({ user, isLoading: false }),
  setLoading: (isLoading) => set({ isLoading }),
  logout: () => set({ user: null }),
}));
