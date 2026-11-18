import React from 'react';
import { ActivityIndicator, StyleSheet, View } from 'react-native';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useFonts } from 'expo-font';
import { colors } from '../src/theme';
import { AppProvider } from '../src/store/AppContext';

export default function RootLayout() {
  const [fontsLoaded] = useFonts({
    'Inter-Regular': require('../assets/fonts/Inter-400.ttf'),
    'Inter-Medium': require('../assets/fonts/Inter-500.ttf'),
    'Inter-SemiBold': require('../assets/fonts/Inter-600.ttf'),
    'Inter-Bold': require('../assets/fonts/Inter-700.ttf'),
  });

  if (!fontsLoaded) {
    return (
      <View style={styles.loading}>
        <ActivityIndicator size="large" color={colors.blue} />
      </View>
    );
  }

  return (
    <AppProvider>
      <StatusBar style="dark" />
      <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.white } }} />
    </AppProvider>
  );
}

const styles = StyleSheet.create({
  loading: { flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.white },
});
