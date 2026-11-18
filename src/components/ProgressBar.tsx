import React from 'react';
import { StyleSheet, View } from 'react-native';
import { colors, layout, radii, spacing } from '../theme';
import { useApp } from '../store/AppContext';
import { AppText } from './AppText';

/** Progress bar plus an always-visible numeric label (not colour alone). */
export function ProgressBar({ done, total }: { done: number; total: number }) {
  const { t } = useApp();
  const percent = total === 0 ? 0 : Math.round((done / total) * 100);
  return (
    <View style={styles.wrap}>
      <View
        style={styles.track}
        accessibilityRole="progressbar"
        accessibilityValue={{ min: 0, max: total, now: done }}
      >
        <View style={[styles.fill, { width: `${percent}%` }]} />
      </View>
      <AppText variant="caption" color="muted">
        {t('checklistProgress', { done, total })}
      </AppText>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { gap: spacing.sm },
  track: {
    height: layout.progressHeight,
    borderRadius: radii.progress,
    backgroundColor: colors.soft,
    overflow: 'hidden',
  },
  fill: { height: '100%', borderRadius: radii.progress, backgroundColor: colors.blue },
});
