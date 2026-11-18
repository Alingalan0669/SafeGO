import React from 'react';
import { Pressable, StyleSheet } from 'react-native';
import { colors, layout, radii, spacing, typography } from '../theme';
import { AppText } from './AppText';

interface Props {
  label: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
}

const variants = {
  primary: { background: colors.blue, foreground: colors.white, border: colors.blue },
  secondary: { background: colors.white, foreground: colors.blue, border: colors.blue },
  danger: { background: colors.red, foreground: colors.white, border: colors.red },
} as const;

export function PrimaryButton({ label, onPress, variant = 'primary', disabled = false }: Props) {
  const palette = variants[variant];
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      accessibilityRole="button"
      accessibilityLabel={label}
      style={({ pressed }) => [
        styles.button,
        {
          backgroundColor: disabled ? colors.soft : palette.background,
          borderColor: disabled ? colors.border : palette.border,
        },
        pressed && !disabled && styles.pressed,
      ]}
    >
      <AppText
        variant="button"
        color={disabled ? 'muted' : undefined}
        style={[styles.label, { color: disabled ? colors.muted : palette.foreground }]}
      >
        {label}
      </AppText>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    minHeight: layout.buttonHeight,
    borderRadius: radii.card,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: spacing.xl,
  },
  pressed: { opacity: 0.8 },
  label: { ...typography.button, textAlign: 'center' },
});
