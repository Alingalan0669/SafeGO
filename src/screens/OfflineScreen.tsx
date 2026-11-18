import React from 'react';
import { useApp } from '../store/AppContext';
import { AlertBanner } from '../components/AlertBanner';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';

export default function OfflineScreen() {
  const { t, refresh } = useApp();
  return (
    <Screen>
      <AlertBanner text={t('offlineBody')} severity="info" />
      <AppText variant="h2" accessibilityRole="header">
        {t('offlineTitle')}
      </AppText>
      <PrimaryButton label={t('tryAgain')} onPress={() => void refresh()} />
    </Screen>
  );
}
