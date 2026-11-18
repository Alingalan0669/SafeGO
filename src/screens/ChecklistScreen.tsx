import React from 'react';
import { StyleSheet, View } from 'react-native';
import { colors, radii, spacing, statusStyles } from '../theme';
import { useApp } from '../store/AppContext';
import { AlertBanner } from '../components/AlertBanner';
import { AppText } from '../components/AppText';
import { ChecklistTile } from '../components/ChecklistTile';
import { ProgressBar } from '../components/ProgressBar';
import { Screen } from '../components/Screen';
import { TopBar } from '../components/TopBar';

/** One implementation powers both Prepare and Pack frames. */
export default function ChecklistScreen({ kind }: { kind: 'prepare' | 'pack' }) {
  const { t, checklists } = useApp();
  const items = kind === 'prepare' ? checklists.prepare : checklists.pack;
  const done = kind === 'prepare' ? checklists.prepareDone : checklists.packDone;
  const allDone = items.length > 0 && done === items.length;

  return (
    <Screen>
      <TopBar
        title={t(kind === 'prepare' ? 'prepareTitle' : 'packTitle')}
        subtitle={t(kind === 'prepare' ? 'prepareSubtitle' : 'packSubtitle')}
      />
      <View style={styles.progressCard}>
        <ProgressBar done={done} total={items.length} />
      </View>
      {allDone ? (
        <View style={styles.done}>
          <AlertBanner text={t('allDone')} severity="info" />
        </View>
      ) : null}
      <View style={styles.list}>
        {items.map((item) => (
          <ChecklistTile key={item.id} item={item} />
        ))}
      </View>
      {items.length === 0 ? (
        <AppText variant="body" color="muted">
          {t('emptyBody')}
        </AppText>
      ) : null}
    </Screen>
  );
}

const styles = StyleSheet.create({
  progressCard: {
    borderRadius: radii.card,
    backgroundColor: colors.blueSoft,
    padding: spacing.lg,
  },
  done: { backgroundColor: statusStyles.ready.background, borderRadius: radii.input },
  list: { gap: spacing.md },
});
