import React from 'react';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';
import { Screen } from '../components/Screen';
import { TopBar } from '../components/TopBar';

export default function LargeTextScreen() {
  const { t } = useApp();
  return (
    <Screen>
      <TopBar title={t('largeTextTitle')} showSettings={false} />
      <AppText variant="body" color="muted">
        {t('largeTextBody')}
      </AppText>
      <AppText variant="subtitle" accessibilityRole="header">
        {t('packTitle')}
      </AppText>
      <AppText variant="body">{t('onboarding2Body')}</AppText>
      <AppText variant="caption" color="muted">
        {t('readinessHint')}
      </AppText>
    </Screen>
  );
}
