import React from 'react';
import { useRouter } from 'expo-router';
import { spacing } from '../theme';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';

export default function SplashScreen() {
  const router = useRouter();
  const { t } = useApp();
  return (
    <Screen>
      <AppText variant="h1" color="blue" accessibilityRole="header">
        {t('appName')}
      </AppText>
      <AppText variant="subtitle" color="ink">
        {t('tagline')}
      </AppText>
      <PrimaryButton label={t('getStarted')} onPress={() => router.replace('/onboarding')} />
      <AppText variant="caption" color="muted" style={{ marginTop: spacing.xl }}>
        {t('demoNotice')}
      </AppText>
    </Screen>
  );
}
