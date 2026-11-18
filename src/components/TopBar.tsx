import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import { colors, layout, spacing } from '../theme';
import { AppText } from './AppText';
import { Icon } from './Icon';

/** Figma top app bar: 64px tall with title and a 48px settings target. */
export function TopBar({
  title,
  subtitle,
  showSettings = true,
}: {
  title: string;
  subtitle?: string;
  showSettings?: boolean;
}) {
  const router = useRouter();
  return (
    <View style={styles.bar}>
      <View style={styles.copy}>
        <AppText variant="h2" accessibilityRole="header">
          {title}
        </AppText>
        {subtitle ? (
          <AppText variant="caption" color="muted">
            {subtitle}
          </AppText>
        ) : null}
      </View>
      {showSettings ? (
        <Pressable
          onPress={() => router.push('/settings')}
          accessibilityRole="button"
          accessibilityLabel="Settings"
          hitSlop={spacing.sm}
          style={styles.settings}
        >
          <Icon name="settings" size={24} />
        </Pressable>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  bar: {
    minHeight: layout.topBarHeight,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.md,
  },
  copy: { flex: 1, gap: 2 },
  settings: {
    width: layout.minTouchTarget,
    height: layout.minTouchTarget,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 12,
    backgroundColor: colors.blueSoft,
  },
});
