import React, { useState } from 'react';
import { Pressable, ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { colors, layout, radii, spacing, typography } from '../theme';
import { dial } from '../services/phone';
import { useOffline } from '../services/offline';
import { useApp } from '../store/AppContext';
import { AppText } from '../components/AppText';

const stepKeys = ['step1', 'step2', 'step3', 'step4'] as const;

/** High-contrast emergency screen: large type, explicit steps, always-visible call action. */
export default function EvacuateNowScreen() {
  const router = useRouter();
  const { t } = useApp();
  const offline = useOffline();
  const [callFailed, setCallFailed] = useState(false);

  const call = async () => {
    const ok = await dial('911');
    setCallFailed(!ok);
  };

  return (
    <SafeAreaView style={styles.safe} edges={['top', 'left', 'right']}>
      <ScrollView contentContainerStyle={styles.scroll}>
        <AppText variant="h1" color="white" accessibilityRole="header">
          {t('evacuateNowTitle')}
        </AppText>
        <AppText variant="subtitle" color="white">
          {t('urgentNotice')}
        </AppText>

        {offline ? (
          <View style={styles.offline}>
            <AppText variant="caption" color="ink">
              {t('offlineBadge')}
            </AppText>
          </View>
        ) : null}

        <View style={styles.steps}>
          {stepKeys.map((key) => (
            <View key={key} style={styles.step}>
              <AppText variant="body" color="white">
                {t(key)}
              </AppText>
            </View>
          ))}
        </View>

        {callFailed ? (
          <View style={styles.error}>
            <AppText variant="caption" color="ink">
              {t('callFailed')}
            </AppText>
          </View>
        ) : null}

        <Pressable
          onPress={() => void call()}
          accessibilityRole="button"
          accessibilityLabel="Call 911"
          style={({ pressed }) => [styles.callButton, pressed && styles.pressed]}
        >
          <AppText style={[typography.h2, styles.callLabel]}>CALL 911</AppText>
        </Pressable>

        <Pressable
          onPress={() => router.push('/safe')}
          accessibilityRole="button"
          style={({ pressed }) => [styles.safeButton, pressed && styles.pressed]}
        >
          <AppText variant="button" color="white">
            {t('safeTitle')}
          </AppText>
        </Pressable>

        <Pressable
          onPress={() => router.back()}
          accessibilityRole="button"
          accessibilityLabel={t('back')}
          style={styles.back}
        >
          <AppText variant="caption" color="white">
            {t('back')}
          </AppText>
        </Pressable>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: colors.redDark },
  scroll: { flexGrow: 1, padding: spacing.xl, gap: spacing.lg },
  offline: { backgroundColor: colors.white, borderRadius: radii.input, padding: spacing.md },
  error: { backgroundColor: colors.white, borderRadius: radii.input, padding: spacing.md },
  steps: { gap: spacing.md, marginTop: spacing.sm },
  step: {
    minHeight: 72,
    justifyContent: 'center',
    borderRadius: radii.card,
    borderWidth: 2,
    borderColor: colors.white,
    padding: spacing.lg,
  },
  callButton: {
    minHeight: 72,
    borderRadius: radii.card,
    backgroundColor: colors.white,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: spacing.md,
  },
  callLabel: { color: colors.redDark },
  safeButton: {
    minHeight: layout.minTouchTarget,
    borderRadius: radii.input,
    borderWidth: 1,
    borderColor: colors.white,
    alignItems: 'center',
    justifyContent: 'center',
  },
  back: { minHeight: layout.minTouchTarget, alignItems: 'center', justifyContent: 'center' },
  pressed: { opacity: 0.8 },
});
