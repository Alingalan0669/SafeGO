import React, { useState } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import evacuation from '../data/evacuation.json';
import { colors, radii, spacing } from '../theme';
import { dial } from '../services/phone';
import { useApp } from '../store/AppContext';
import type { EvacuationData } from '../types/models';
import { AlertBanner } from '../components/AlertBanner';
import { AppText } from '../components/AppText';
import { PrimaryButton } from '../components/PrimaryButton';
import { Screen } from '../components/Screen';
import { TopBar } from '../components/TopBar';

const data = evacuation as EvacuationData;

export default function EvacuateScreen() {
  const router = useRouter();
  const { t } = useApp();
  const [callFailed, setCallFailed] = useState(false);

  const call = async (phone: string) => {
    const ok = await dial(phone);
    setCallFailed(!ok);
  };

  return (
    <Screen>
      <TopBar title={t('evacuateTitle')} subtitle={t('evacuateSubtitle')} />
      <AlertBanner text={t('demoNotice')} severity="warning" />

      <AppText variant="subtitle" accessibilityRole="header">
        {t('nearbyCenters')}
      </AppText>
      <View style={styles.centers}>
        {data.centers.map((center) => (
          <View key={center.id} style={styles.card}>
            <AppText variant="subtitle">{center.name}</AppText>
            <AppText variant="caption" color="muted">
              {center.address}
            </AppText>
            <AppText variant="caption" color="blue">
              {t('distance', { km: center.distanceKm })}
            </AppText>
            <AppText variant="caption" color="muted">
              {center.notes}
            </AppText>
          </View>
        ))}
      </View>

      <AppText variant="subtitle" accessibilityRole="header">
        {t('emergencyContacts')}
      </AppText>
      <View style={styles.contacts}>
        {data.contacts.map((contact) => (
          <View key={contact.id} style={styles.contact}>
            <View style={styles.contactCopy}>
              <AppText variant="body">{contact.name}</AppText>
              <AppText variant="caption" color="muted">
                {contact.relationship} · {contact.phone}
              </AppText>
            </View>
            <Pressable
              onPress={() => void call(contact.phone)}
              accessibilityRole="button"
              accessibilityLabel={t('call', { name: contact.name })}
              style={styles.call}
            >
              <AppText variant="label" color="blue">
                {t('call', { name: '' }).trim()}
              </AppText>
            </Pressable>
          </View>
        ))}
      </View>
      {callFailed ? <AlertBanner text={t('callFailed')} severity="danger" /> : null}
      <AppText variant="caption" color="muted">
        {t('callHint')}
      </AppText>

      <PrimaryButton variant="danger" label={t('evacuateNow')} onPress={() => router.push('/evacuate-now')} />
    </Screen>
  );
}

const styles = StyleSheet.create({
  centers: { gap: spacing.md },
  card: {
    gap: spacing.xs,
    borderRadius: radii.card,
    borderWidth: 1,
    borderColor: colors.border,
    padding: spacing.lg,
    backgroundColor: colors.white,
  },
  contacts: { gap: spacing.md },
  contact: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    borderRadius: radii.card,
    borderWidth: 1,
    borderColor: colors.border,
    padding: spacing.md,
    backgroundColor: colors.white,
  },
  contactCopy: { flex: 1, gap: 2 },
  call: {
    minWidth: 72,
    minHeight: 48,
    borderRadius: radii.input,
    borderWidth: 1,
    borderColor: colors.blue,
    backgroundColor: colors.blueSoft,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: spacing.md,
  },
});
