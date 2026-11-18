import React from 'react';
import { useRouter } from 'expo-router';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';

export default function EmptyScreen() {
  const router = useRouter();
  const { t } = useApp();
  return (
    <Screen>
      <AppText variant="h2" accessibilityRole="header">
        {t('emptyTitle')}
      </AppText>
      <AppText variant="body" color="muted">
        {t('emptyBody')}
      </AppText>
      <PrimaryButton label={t('goToSetup')} onPress={() => router.push('/household-setup')} />
    </Screen>
  );
}
