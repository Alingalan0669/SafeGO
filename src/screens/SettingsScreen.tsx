import React, { useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import { radii, spacing } from '../theme';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';
import { SettingGroup, SettingRow } from '../components/SettingRow';
import { TopBar } from '../components/TopBar';

export default function SettingsScreen() {
  const router = useRouter();
  const { t, settings, setLanguage, setTextSize, reset } = useApp();
  const [confirming, setConfirming] = useState(false);

  return (
    <Screen>
      <TopBar title={t('settingsTitle')} showSettings={false} />

      <SettingGroup title={t('language')}>
        <SettingRow
          label={t('english')}
          selected={settings.language === 'en'}
          onPress={() => void setLanguage('en')}
        />
        <SettingRow
          label={t('filipino')}
          selected={settings.language === 'fil'}
          onPress={() => void setLanguage('fil')}
        />
      </SettingGroup>

      <SettingGroup title={t('textSize')}>
        <SettingRow
          label={t('standard')}
          selected={settings.textSize === 'standard'}
          onPress={() => void setTextSize('standard')}
        />
        <SettingRow
          label={t('large')}
          selected={settings.textSize === 'large'}
          onPress={() => void setTextSize('large')}
        />
      </SettingGroup>

      <View style={styles.previews}>
        <SettingRow label={t('largeTextTitle')} onPress={() => router.push('/large-text')} />
        <SettingRow label={t('demoCallTitle')} onPress={() => router.push('/demo-call')} />
        <SettingRow label={t('filipinoTitle')} onPress={() => router.push('/filipino')} />
      </View>

      <View style={styles.reset}>
        <AppText variant="subtitle" accessibilityRole="header">
          {t('resetTitle')}
        </AppText>
        <AppText variant="caption" color="muted">
          {t('resetBody')}
        </AppText>
        <PrimaryButton
          variant={confirming ? 'danger' : 'secondary'}
          label={confirming ? t('resetButton') : t('resetTitle')}
          onPress={() => {
            if (confirming) void reset().then(() => router.replace('/'));
            else setConfirming(true);
          }}
        />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  previews: { gap: spacing.sm, borderRadius: radii.card },
  reset: { gap: spacing.md, marginTop: spacing.xl },
});
