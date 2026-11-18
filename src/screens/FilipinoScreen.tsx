import React from 'react';
import { useApp } from '../store/AppContext';
import { translate } from '../data/translations';
import { AppText } from '../components/AppText';
import { Screen } from '../components/Screen';
import { TopBar } from '../components/TopBar';

/** Always renders Filipino regardless of the saved setting. */
export default function FilipinoScreen() {
  const { t } = useApp();
  return (
    <Screen>
      <TopBar title={translate('fil', 'filipinoTitle')} showSettings={false} />
      <AppText variant="body" color="muted">
        {translate('fil', 'filipinoBody')}
      </AppText>
      <AppText variant="h2" accessibilityRole="header">
        {translate('fil', 'onboarding1Title')}
      </AppText>
      <AppText variant="body">{translate('fil', 'onboarding1Body')}</AppText>
      <AppText variant="subtitle">{t('preview')}</AppText>
    </Screen>
  );
}
