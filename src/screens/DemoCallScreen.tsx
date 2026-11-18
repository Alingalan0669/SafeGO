import React, { useState } from 'react';
import { Pressable, StyleSheet } from 'react-native';
import { colors, layout, radii, spacing } from '../theme';
import { dial } from '../services/phone';
import { useApp } from '../store/AppContext';
import { AlertBanner } from '../components/AlertBanner';
import { AppText } from '../components/AppText';
import { Screen } from '../components/Screen';
import { TopBar } from '../components/TopBar';

export default function DemoCallScreen() {
  const { t } = useApp();
  const [failed, setFailed] = useState(false);
  return (
    <Screen>
      <TopBar title={t('demoCallTitle')} showSettings={false} />
      <AppText variant="body" color="muted">
        {t('demoCallBody')}
      </AppText>
      <Pressable
        onPress={() => void dial('911').then((ok) => setFailed(!ok))}
        accessibilityRole="button"
        accessibilityLabel="Call 911"
        style={({ pressed }) => [styles.call, pressed && styles.pressed]}
      >
        <AppText variant="button" color="white">
          CALL 911
        </AppText>
      </Pressable>
      {failed ? <AlertBanner text={t('callFailed')} severity="danger" /> : null}
    </Screen>
  );
}

const styles = StyleSheet.create({
  call: {
    minHeight: layout.buttonHeight,
    borderRadius: radii.card,
    backgroundColor: colors.red,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: spacing.lg,
  },
  pressed: { opacity: 0.8 },
});
