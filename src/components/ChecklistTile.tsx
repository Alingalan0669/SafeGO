import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { colors, radii, spacing, statusStyles } from '../theme';
import { formatDetail } from '../services/checklist';
import { useApp } from '../store/AppContext';
import type { ChecklistItem } from '../types/models';
import { AppText } from './AppText';
import { Icon } from './Icon';

export function ChecklistTile({ item }: { item: ChecklistItem }) {
  const { toggleItem, profile, t } = useApp();
  const done = Boolean(item.isDone);
  return (
    <Pressable
      onPress={() => void toggleItem(item.id)}
      accessibilityRole="checkbox"
      accessibilityState={{ checked: done }}
      accessibilityLabel={`${item.title}. ${item.detail}`}
      style={({ pressed }) => [styles.tile, pressed && styles.pressed]}
    >
      <View style={[styles.checkbox, done && styles.checked]}>
        {done ? <Icon name="check" size={18} /> : null}
      </View>
      <View style={styles.copy}>
        <AppText variant="subtitle" color="ink" numberOfLines={2}>
          {item.title}
        </AppText>
        <AppText variant="caption" color="muted" numberOfLines={3}>
          {formatDetail(item.detail, profile)}
        </AppText>
        {item.isPersonalised ? (
          <AppText variant="label" color="blue">
            {t('personalised')}
          </AppText>
        ) : null}
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  tile: {
    minHeight: 86,
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.lg,
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: radii.card,
    padding: spacing.lg,
  },
  pressed: { backgroundColor: colors.soft },
  checkbox: {
    width: 24,
    height: 24,
    borderRadius: radii.checkbox,
    borderWidth: 2,
    borderColor: colors.blue,
    alignItems: 'center',
    justifyContent: 'center',
    flexShrink: 0,
  },
  checked: { backgroundColor: statusStyles.ready.foreground, borderColor: statusStyles.ready.foreground },
  copy: { flex: 1, gap: spacing.xs },
});
