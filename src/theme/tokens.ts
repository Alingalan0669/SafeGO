/**
 * SafeGo design tokens — ported 1:1 from the Figma "SafeGo / Design system" frame.
 * Screens must import from here; no screen should contain a raw hex colour.
 */
import type { TextStyle } from 'react-native';

/** Semantic palette from the Figma "Semantic colors" swatches. */
export const colors = {
  blue: '#1D4ED8',
  blueDark: '#1E3A8A',
  blueSoft: '#EFF6FF',
  green: '#166534',
  greenSoft: '#F0FDF4',
  amber: '#92400E',
  amberSoft: '#FFFBEB',
  red: '#B91C1C',
  redDark: '#7F1D1D',
  redSoft: '#FEF2F2',
  ink: '#111827',
  muted: '#4B5563',
  border: '#CBD5E1',
  soft: '#F3F4F6',
  white: '#FFFFFF',
} as const;

export type ColorToken = keyof typeof colors;

/** Inter is bundled in assets/fonts and loaded by expo-font in app/_layout.tsx. */
export const fontFamilies = {
  regular: 'Inter-Regular',
  medium: 'Inter-Medium',
  semibold: 'Inter-SemiBold',
  bold: 'Inter-Bold',
} as const;

/** Figma type scale: H1 28/36, H2 22/28, Subtitle 18/24, Body 16/24, Caption 14/20. */
export const typography = {
  h1: { fontFamily: fontFamilies.bold, fontSize: 28, lineHeight: 36 },
  h2: { fontFamily: fontFamilies.bold, fontSize: 22, lineHeight: 28 },
  subtitle: { fontFamily: fontFamilies.semibold, fontSize: 18, lineHeight: 24 },
  body: { fontFamily: fontFamilies.regular, fontSize: 16, lineHeight: 24 },
  caption: { fontFamily: fontFamilies.medium, fontSize: 14, lineHeight: 20 },
  button: { fontFamily: fontFamilies.semibold, fontSize: 18, lineHeight: 24 },
  label: { fontFamily: fontFamilies.medium, fontSize: 14, lineHeight: 20 },
} satisfies Record<string, TextStyle>;

export type TypographyToken = keyof typeof typography;

/** 8pt grid. 4/12 are half-steps used by icon-internal padding and 12px gaps. */
export const spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  xxl: 32,
  xxxl: 48,
  huge: 64,
} as const;

export const radii = {
  checkbox: 6,
  progress: 8,
  input: 12,
  tab: 12,
  card: 16,
} as const;

/** Structural measurements taken from the 390x844 Figma frames. */
export const layout = {
  minTouchTarget: 48,
  screenPadding: 24,
  contentWidth: 342,
  topBarHeight: 64,
  tabBarHeight: 80,
  buttonHeight: 56,
  cardPadding: 16,
  progressHeight: 8,
} as const;

/** Status-card colour pairs; always paired with a text label, never colour alone. */
export const statusStyles = {
  ready: { foreground: colors.green, background: colors.greenSoft },
  incomplete: { foreground: colors.amber, background: colors.amberSoft },
  alert: { foreground: colors.red, background: colors.redSoft },
  offline: { foreground: colors.blue, background: colors.blueSoft },
} as const;

/**
 * "Large text" setting: the Figma preview uses 20px body instead of 16px.
 * Scaling both font size and line height keeps the 8pt rhythm intact.
 */
export function withTextSize(style: TextStyle, large: boolean): TextStyle {
  if (!large) return style;
  return {
    ...style,
    fontSize: (style.fontSize ?? 16) + 4,
    lineHeight: (style.lineHeight ?? 24) + 4,
  };
}
