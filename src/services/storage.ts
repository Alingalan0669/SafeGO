import AsyncStorage from '@react-native-async-storage/async-storage';
import type { AppSettings, PersistedState } from '../types/models';

const KEY = 'safego.state.v1';

export const defaultSettings: AppSettings = { language: 'en', textSize: 'standard' };

export const emptyState: PersistedState = {
  profile: null,
  completedIds: [],
  settings: defaultSettings,
};

/** Merge stored values with defaults so older/partial records never crash startup. */
function sanitize(value: unknown): PersistedState {
  if (!value || typeof value !== 'object') return emptyState;
  const record = value as Partial<PersistedState>;
  return {
    profile: record.profile ?? null,
    completedIds: Array.isArray(record.completedIds)
      ? record.completedIds.filter((id): id is string => typeof id === 'string')
      : [],
    settings: { ...defaultSettings, ...(record.settings ?? {}) },
  };
}

export async function loadState(): Promise<PersistedState> {
  try {
    const raw = await AsyncStorage.getItem(KEY);
    return raw ? sanitize(JSON.parse(raw)) : emptyState;
  } catch {
    // Corrupt or unavailable storage should still let the app open.
    return emptyState;
  }
}

export async function saveState(state: PersistedState): Promise<void> {
  try {
    await AsyncStorage.setItem(KEY, JSON.stringify(state));
  } catch {
    // Storage failures are non-fatal: the in-memory state remains usable.
  }
}

export async function clearState(): Promise<void> {
  try {
    await AsyncStorage.removeItem(KEY);
  } catch {
    // Ignore: nothing else to clean up.
  }
}
