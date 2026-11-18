import React from 'react';
import { Text, type StyleProp, type TextStyle } from 'react-native';
import { colors, typography, withTextSize, type ColorToken, type TypographyToken } from '../theme';
import { useApp } from '../store/AppContext';

interface Props {
  children: React.ReactNode;
  variant?: TypographyToken;
  color?: ColorToken;
  style?: StyleProp<TextStyle>;
  numberOfLines?: number;
  accessibilityRole?: 'header' | 'text';
}

/** All copy goes through here so the Large text setting applies consistently. */
export function AppText({
  children,
  variant = 'body',
  color = 'ink',
  style,
  numberOfLines,
  accessibilityRole,
}: Props) {
  const { settings } = useApp();
  const base = withTextSize(typography[variant], settings.textSize === 'large');
  return (
    <Text
      style={[base, { color: colors[color] }, style]}
      numberOfLines={numberOfLines}
      accessibilityRole={accessibilityRole}
    >
      {children}
    </Text>
  );
}
