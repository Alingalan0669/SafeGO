import React from 'react';
import { StyleSheet, View } from 'react-native';
import { radii, spacing, statusStyles, type ColorToken } from '../theme';
import { AppText } from './AppText';
import { Icon } from './Icon';

type Status = keyof typeof statusStyles;

const iconFor: Record<Status, 'check' | 'alert-warning' | 'alert-danger' | 'offline'> = {
  ready: 'check',
  incomplete: 'alert-warning',
  alert: 'alert-danger',
  offline: 'offline',
};

export function StatusCard({
  status,
  title,
  body,
}: {
  status: Status;
  title: string;
  body?: string;
}) {
  const palette = statusStyles[status];
  const foreground: ColorToken =
    status === 'ready' ? 'green' : status === 'incomplete' ? 'amber' : status === 'alert' ? 'red' : 'blue';
  return (
    <View style={[styles.card, { backgroundColor: palette.background }]}>
      <View style={[styles.iconWrap, { backgroundColor: palette.foreground }]}>
        <Icon name={iconFor[status]} size={20} />
      </View>
      <View style={styles.copy}>
        <AppText variant="subtitle" color={foreground}>
          {title}
        </AppText>
        {body ? (
          <AppText variant="body" color="ink">
            {body}
          </AppText>
        ) : null}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: spacing.md,
    borderRadius: radii.card,
    padding: spacing.lg,
  },
  iconWrap: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    flexShrink: 0,
  },
  copy: { flex: 1, gap: spacing.xs },
});
