import React from 'react';
import { StyleSheet, View } from 'react-native';
import { radii, spacing, statusStyles } from '../theme';
import { AppText } from './AppText';
import { Icon } from './Icon';

/** 24px icon plus text; severity is always conveyed by a word, not colour alone. */
export function AlertBanner({
  text,
  severity = 'warning',
}: {
  text: string;
  severity?: 'warning' | 'danger' | 'info';
}) {
  const palette =
    severity === 'danger'
      ? statusStyles.alert
      : severity === 'info'
        ? statusStyles.offline
        : statusStyles.incomplete;
  return (
    <View style={[styles.banner, { backgroundColor: palette.background }]}>
      <Icon name={severity === 'info' ? 'offline' : severity === 'danger' ? 'alert-danger' : 'alert-warning'} size={24} />
      <AppText variant="caption" color="ink" style={styles.text}>
        {text}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  banner: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: spacing.md,
    borderRadius: radii.input,
    padding: spacing.md,
  },
  text: { flex: 1 },
});
