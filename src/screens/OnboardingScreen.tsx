import React, { useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import { colors, spacing } from '../theme';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';

const pages = [
  { title: 'onboarding1Title', body: 'onboarding1Body' },
  { title: 'onboarding2Title', body: 'onboarding2Body' },
  { title: 'onboarding3Title', body: 'onboarding3Body' },
] as const;

export default function OnboardingScreen() {
  const router = useRouter();
  const { t } = useApp();
  const [page, setPage] = useState(0);
  const copy = pages[page];
  const last = page === pages.length - 1;

  return (
    <Screen>
      <View style={styles.hero}>
        <AppText variant="caption" color="blue">
          {t('appName')}
        </AppText>
        <AppText variant="h1" accessibilityRole="header">
          {t(copy.title)}
        </AppText>
        <AppText variant="body" color="muted">
          {t(copy.body)}
        </AppText>
      </View>

      <View style={styles.dots} accessibilityRole="tablist">
        {pages.map((_, index) => (
          <View
            key={index}
            style={[styles.dot, index === page && styles.dotActive]}
            accessibilityState={{ selected: index === page }}
          />
        ))}
      </View>

      <View style={styles.actions}>
        <PrimaryButton
          label={last ? t('getStarted') : t('next')}
          onPress={() =>
            last ? router.replace('/household-setup') : setPage((current) => current + 1)
          }
        />
        <PrimaryButton
          variant="secondary"
          label={t('skip')}
          onPress={() => router.replace('/household-setup')}
        />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  hero: { gap: spacing.lg, marginTop: spacing.xxxl, minHeight: 280 },
  dots: { flexDirection: 'row', gap: spacing.sm, justifyContent: 'center' },
  dot: { width: 8, height: 8, borderRadius: 4, backgroundColor: colors.border },
  dotActive: { backgroundColor: colors.blue, width: 24 },
  actions: { gap: spacing.md, marginTop: spacing.xl },
});
