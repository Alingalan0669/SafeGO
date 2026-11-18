import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from 'react';
import {
  clearState,
  defaultSettings,
  loadState,
  saveState,
} from '../services/storage';
import { buildChecklists } from '../services/checklist';
import {
  translate,
  type TranslationKey,
} from '../data/translations';
import type {
  AppSettings,
  ChecklistItem,
  HouseholdProfile,
  Language,
  PersistedState,
  TextSize,
} from '../types/models';

interface AppContextValue {
  loading: boolean;
  error: boolean;
  profile: HouseholdProfile | null;
  completedIds: string[];
  settings: AppSettings;
  checklists: ReturnType<typeof buildChecklists>;
  refresh: () => Promise<void>;
  setProfile: (profile: HouseholdProfile) => Promise<void>;
  toggleItem: (id: string) => Promise<void>;
  setLanguage: (language: Language) => Promise<void>;
  setTextSize: (textSize: TextSize) => Promise<void>;
  reset: () => Promise<void>;
  t: (key: TranslationKey, values?: Record<string, string | number>) => string;
}

const AppContext = createContext<AppContextValue | null>(null);

export function AppProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<PersistedState>({
    profile: null,
    completedIds: [],
    settings: defaultSettings,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  const refresh = useCallback(async () => {
    try {
      const loaded = await loadState();
      setState(loaded);
      setError(false);
    } catch {
      setError(true);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  const persist = useCallback(async (next: PersistedState) => {
    setState(next);
    await saveState(next);
  }, []);

  const setProfile = useCallback(
    async (profile: HouseholdProfile) => {
      await persist({ ...state, profile });
    },
    [persist, state],
  );

  const toggleItem = useCallback(
    async (id: string) => {
      const exists = state.completedIds.includes(id);
      const completedIds = exists
        ? state.completedIds.filter((item) => item !== id)
        : [...state.completedIds, id];
      // Checklist completion is preserved even before household setup is saved.
      await persist({ ...state, completedIds });
    },
    [persist, state],
  );

  const setLanguage = useCallback(
    async (language: Language) => persist({ ...state, settings: { ...state.settings, language } }),
    [persist, state],
  );

  const setTextSize = useCallback(
    async (textSize: TextSize) => persist({ ...state, settings: { ...state.settings, textSize } }),
    [persist, state],
  );

  const reset = useCallback(async () => {
    await clearState();
    setState({ profile: null, completedIds: [], settings: defaultSettings });
  }, []);

  const checklists = useMemo(
    () => buildChecklists(state.profile, state.completedIds),
    [state.profile, state.completedIds],
  );

  const t = useCallback(
    (key: TranslationKey, values?: Record<string, string | number>) =>
      translate(state.settings.language, key, values),
    [state.settings.language],
  );

  const value = useMemo<AppContextValue>(
    () => ({
      loading,
      error,
      profile: state.profile,
      completedIds: state.completedIds,
      settings: state.settings,
      checklists,
      refresh,
      setProfile,
      toggleItem,
      setLanguage,
      setTextSize,
      reset,
      t,
    }),
    [
      loading,
      error,
      state.profile,
      state.completedIds,
      state.settings,
      checklists,
      refresh,
      setProfile,
      toggleItem,
      setLanguage,
      setTextSize,
      reset,
      t,
    ],
  );

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

export function useApp(): AppContextValue {
  const context = useContext(AppContext);
  if (!context) throw new Error('useApp must be used inside AppProvider');
  return context;
}

export type { ChecklistItem };
