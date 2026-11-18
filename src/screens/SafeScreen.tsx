import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import { radii, spacing, statusStyles } from '../theme';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';
import { StatusCard } from '../components/StatusCard';

export default function SafeScreen() {
  const router = useRouter();
  const { t } = useApp();
  return (
    <Screen>
      <View style={styles.wrap}>
        <StatusCard status="ready" title={t('safeTitle')} body={t('safeBody')} />
        <PrimaryButton label={t('backToHome')} onPress={() => router.replace('/(tabs)')} />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  wrap: { gap: spacing.xl, marginTop: spacing.xxxl, backgroundColor: statusStyles.ready.background, borderRadius: radii.card, padding: spacing.lg },
});
