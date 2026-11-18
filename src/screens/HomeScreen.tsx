import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import { colors, radii, spacing } from '../theme';
import { useApp } from '../store/AppContext';
import type { TranslationKey } from '../data/translations';
import { AppText } from '../components/AppText';
import { Icon, type IconName } from '../components/Icon';
import { ProgressBar } from '../components/ProgressBar';
import { Screen } from '../components/Screen';
import { StatusCard } from '../components/StatusCard';
import { TopBar } from '../components/TopBar';

export default function HomeScreen() {
  const router = useRouter();
  const { t, profile, checklists } = useApp();
  const ready = checklists.readiness === 100;

  const actions: Array<{ icon: IconName; label: TranslationKey; route: string }> = [
    { icon: 'prepare-on', label: 'viewPrepare', route: '/prepare' },
    { icon: 'pack-on', label: 'viewPack', route: '/pack' },
    { icon: 'evacuate-on', label: 'viewEvacuate', route: '/evacuate' },
  ];

  return (
    <Screen>
      <TopBar title={t('greeting')} subtitle={profile?.name ?? t('appName')} />
      <AppText variant="caption" color="blue">
        {t('tagline')}
      </AppText>

      <View style={styles.scoreCard}>
        <AppText variant="caption" color="muted">
          {t('readiness')}
        </AppText>
        <AppText variant="h1" accessibilityRole="header">
          {t('readinessScore', { score: checklists.readiness })}
        </AppText>
        <ProgressBar done={checklists.prepareDone + checklists.packDone} total={checklists.prepare.length + checklists.pack.length} />
        <AppText variant="caption" color="muted">
          {t('readinessHint')}
        </AppText>
      </View>

      <StatusCard
        status={ready ? 'ready' : 'incomplete'}
        title={t(ready ? 'readyTitle' : 'keepGoingTitle')}
        body={t(ready ? 'readyBody' : 'keepGoingBody')}
      />

      <AppText variant="subtitle" accessibilityRole="header">
        {t('quickActions')}
      </AppText>
      <View style={styles.actions}>
        {actions.map((action) => (
          <Pressable
            key={action.route}
            onPress={() => router.push(action.route)}
            accessibilityRole="button"
            accessibilityLabel={t(action.label)}
            style={({ pressed }) => [styles.action, pressed && styles.pressed]}
          >
            <Icon name={action.icon} size={24} />
            <AppText variant="body" style={styles.actionLabel}>
              {t(action.label)}
            </AppText>
          </Pressable>
        ))}
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  scoreCard: {
    gap: spacing.md,
    borderRadius: radii.card,
    borderWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.blueSoft,
    padding: spacing.xl,
  },
  actions: { gap: spacing.md },
  action: {
    minHeight: 72,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.lg,
    borderRadius: radii.card,
    borderWidth: 1,
    borderColor: colors.border,
    padding: spacing.lg,
    backgroundColor: colors.white,
  },
  pressed: { backgroundColor: colors.soft },
  actionLabel: { flex: 1 },
});
