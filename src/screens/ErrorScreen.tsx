import React from 'react';
import { useApp } from '../store/AppContext';
import { AlertBanner } from '../components/AlertBanner';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';

export default function ErrorScreen() {
  const { t, refresh } = useApp();
  return (
    <Screen>
      <AlertBanner text={t('errorBody')} severity="danger" />
      <AppText variant="h2" accessibilityRole="header">
        {t('errorTitle')}
      </AppText>
      <PrimaryButton label={t('tryAgain')} onPress={() => void refresh()} />
    </Screen>
  );
}
