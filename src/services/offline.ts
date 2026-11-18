import * as Network from 'expo-network';
import { AppState, type AppStateStatus } from 'react-native';
import { useEffect, useState } from 'react';

/** Expo Go-safe connectivity check; expo-network has no native build requirement. */
export function useOffline(): boolean {
  const [offline, setOffline] = useState(false);

  useEffect(() => {
    let active = true;
    const refresh = async () => {
      try {
        const state = await Network.getNetworkStateAsync();
        // isConnected can be null when the platform cannot determine connectivity;
        // treat that as online so the offline badge is only shown when we know.
        if (active) setOffline(state.isConnected === false);
      } catch {
        if (active) setOffline(false);
      }
    };
    refresh();
    const subscription = AppState.addEventListener('change', (status: AppStateStatus) => {
      if (status === 'active') refresh();
    });
    return () => {
      active = false;
      subscription.remove();
    };
  }, []);

  return offline;
}
