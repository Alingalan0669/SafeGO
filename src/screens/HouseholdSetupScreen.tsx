import React, { useState } from 'react';
import { Pressable, StyleSheet, TextInput, View } from 'react-native';
import { useRouter } from 'expo-router';
import { colors, layout, radii, spacing, statusStyles } from '../theme';
import { useApp } from '../store/AppContext';
import type { TranslationKey } from '../data/translations';
import type { Hazard } from '../types/models';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';
import { TopBar } from '../components/TopBar';

type Flag = 'hasChildren' | 'hasSeniors' | 'hasDisability' | 'hasPets';

export default function HouseholdSetupScreen() {
  const router = useRouter();
  const { t, setProfile } = useApp();
  const [name, setName] = useState('');
  const [memberCount, setMemberCount] = useState(2);
  const [flags, setFlags] = useState<Record<Flag, boolean>>({
    hasChildren: false,
    hasSeniors: false,
    hasDisability: false,
    hasPets: false,
  });
  const [hazard, setHazard] = useState<Hazard>('Flood');
  const [saving, setSaving] = useState(false);

  const toggle = (flag: Flag) => setFlags((current) => ({ ...current, [flag]: !current[flag] }));
  const hazards: Hazard[] = ['Flood', 'Typhoon', 'Quake'];
  const flagLabels: Array<[Flag, TranslationKey]> = [
    ['hasChildren', 'children'],
    ['hasSeniors', 'seniors'],
    ['hasDisability', 'disability'],
    ['hasPets', 'pets'],
  ];

  const save = async () => {
    if (saving || !name.trim()) return;
    setSaving(true);
    await setProfile({
      id: `household-${Date.now()}`,
      name: name.trim(),
      memberCount,
      ...flags,
      hazard,
      onboarded: true,
      createdAt: new Date().toISOString(),
    });
    router.replace('/(tabs)');
  };

  return (
    <Screen>
      <TopBar title={t('setupTitle')} showSettings={false} />
      <AppText variant="body" color="muted">
        {t('setupBody')}
      </AppText>

      <View style={styles.field}>
        <AppText variant="label">{t('householdName')}</AppText>
        <TextInput
          value={name}
          onChangeText={setName}
          placeholder={t('householdNamePlaceholder')}
          placeholderTextColor={colors.muted}
          accessibilityLabel={t('householdName')}
          style={styles.input}
        />
      </View>

      <View style={styles.field}>
        <AppText variant="label">{t('members')}</AppText>
        <View style={styles.stepper}>
          <Pressable
            onPress={() => setMemberCount((count) => Math.max(1, count - 1))}
            disabled={memberCount <= 1}
            accessibilityRole="button"
            accessibilityLabel={t('decrease')}
            style={styles.stepperButton}
          >
            <AppText variant="h2">−</AppText>
          </Pressable>
          <AppText variant="subtitle">{t('memberCount', { count: memberCount })}</AppText>
          <Pressable
            onPress={() => setMemberCount((count) => Math.min(20, count + 1))}
            disabled={memberCount >= 20}
            accessibilityRole="button"
            accessibilityLabel={t('increase')}
            style={styles.stepperButton}
          >
            <AppText variant="h2">+</AppText>
          </Pressable>
        </View>
      </View>

      <View style={styles.field}>
        <AppText variant="label">{t('whoIsInYourHome')}</AppText>
        <View style={styles.chips}>
          {flagLabels.map(([flag, label]) => (
            <Pressable
              key={flag}
              onPress={() => toggle(flag)}
              accessibilityRole="checkbox"
              accessibilityState={{ checked: flags[flag] }}
              accessibilityLabel={t(label)}
              style={[styles.chip, flags[flag] && styles.chipSelected]}
            >
              <AppText variant="caption" color={flags[flag] ? 'blue' : 'muted'}>
                {flags[flag] ? '✓ ' : ''}
                {t(label)}
              </AppText>
            </Pressable>
          ))}
        </View>
      </View>

      <View style={styles.field}>
        <AppText variant="label">{t('mainHazard')}</AppText>
        <View style={styles.chips}>
          {hazards.map((option) => {
            const label = option === 'Flood' ? 'flood' : option === 'Typhoon' ? 'typhoon' : 'quake';
            return (
              <Pressable
                key={option}
                onPress={() => setHazard(option)}
                accessibilityRole="radio"
                accessibilityState={{ selected: hazard === option }}
                accessibilityLabel={t(label)}
                style={[styles.chip, hazard === option && styles.chipSelected]}
              >
                <AppText variant="caption" color={hazard === option ? 'blue' : 'muted'}>
                  {t(label)}
                </AppText>
              </Pressable>
            );
          })}
        </View>
      </View>

      <PrimaryButton label={t('saveAndContinue')} onPress={() => void save()} disabled={!name.trim()} />
    </Screen>
  );
}

const styles = StyleSheet.create({
  field: { gap: spacing.sm },
  input: {
    minHeight: 56,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: radii.input,
    paddingHorizontal: spacing.lg,
    color: colors.ink,
    backgroundColor: colors.white,
  },
  stepper: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: spacing.md },
  stepperButton: {
    width: layout.minTouchTarget,
    height: layout.minTouchTarget,
    borderRadius: radii.input,
    borderWidth: 1,
    borderColor: colors.blue,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.blueSoft,
  },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: spacing.sm },
  chip: {
    minHeight: layout.minTouchTarget,
    justifyContent: 'center',
    paddingHorizontal: spacing.lg,
    borderRadius: radii.input,
    borderWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.white,
  },
  chipSelected: { borderColor: colors.blue, backgroundColor: statusStyles.offline.background },
});
