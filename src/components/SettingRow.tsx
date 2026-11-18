import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { colors, layout, radii, spacing } from '../theme';
import { AppText } from './AppText';

export function SettingRow({
  label,
  value,
  onPress,
  selected = false,
}: {
  label: string;
  value?: string;
  onPress: () => void;
  selected?: boolean;
}) {
  return (
    <Pressable
      onPress={onPress}
      accessibilityRole="radio"
      accessibilityState={{ selected }}
      accessibilityLabel={label}
      style={({ pressed }) => [
        styles.row,
        selected && styles.selected,
        pressed && styles.pressed,
      ]}
    >
      <AppText variant="body">{label}</AppText>
      {value ? (
        <AppText variant="caption" color={selected ? 'blue' : 'muted'}>
          {value}
        </AppText>
      ) : null}
    </Pressable>
  );
}

export function SettingGroup({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <View style={styles.group}>
      <AppText variant="subtitle" accessibilityRole="header">
        {title}
      </AppText>
      <View style={styles.options}>{children}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  group: { gap: spacing.md },
  options: { gap: spacing.sm },
  row: {
    minHeight: layout.minTouchTarget,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: spacing.md,
    paddingHorizontal: spacing.lg,
    borderRadius: radii.input,
    borderWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.white,
  },
  selected: { borderColor: colors.blue, backgroundColor: colors.blueSoft },
  pressed: { opacity: 0.8 },
});
