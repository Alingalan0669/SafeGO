import React from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { colors, spacing } from '../theme';
import { useApp } from '../store/AppContext';
import { useOffline } from '../services/offline';
import { AppText } from './AppText';
import { Icon } from './Icon';

/** Shared scroll container: SafeArea, offline indicator, and an optional banner. */
export function Screen({
  children,
  scroll = true,
  banner,
}: {
  children: React.ReactNode;
  scroll?: boolean;
  banner?: React.ReactNode;
}) {
  const { t } = useApp();
  const offline = useOffline();
  const content = (
    <View style={styles.inner}>
      {offline ? (
        <View style={styles.offline}>
          <Icon name="offline" size={20} />
          <AppText variant="caption" color="blue" style={styles.offlineText}>
            {t('offlineBadge')}
          </AppText>
        </View>
      ) : null}
      {banner}
      {children}
    </View>
  );

  return (
    <SafeAreaView style={styles.safe} edges={['top', 'left', 'right']}>
      {scroll ? (
        <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
          {content}
        </ScrollView>
      ) : (
        <View style={styles.scroll}>{content}</View>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: colors.white },
  scroll: { flexGrow: 1, padding: spacing.xl, paddingBottom: spacing.xxxl },
  inner: { gap: spacing.lg },
  offline: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    backgroundColor: colors.blueSoft,
    borderRadius: 12,
    padding: spacing.md,
  },
  offlineText: { flexShrink: 1 },
});
