import React from 'react';
import { Tabs } from 'expo-router';
import { colors, layout, spacing, typography } from '../../src/theme';
import { Icon, type IconName } from '../../src/components/Icon';
import { useApp } from '../../src/store/AppContext';

const tabs: Array<{ name: string; icon: IconName; label: 'home' | 'prepare' | 'pack' | 'evacuate' }> = [
  { name: 'index', icon: 'home-on', label: 'home' },
  { name: 'prepare', icon: 'prepare-on', label: 'prepare' },
  { name: 'pack', icon: 'pack-on', label: 'pack' },
  { name: 'evacuate', icon: 'evacuate-on', label: 'evacuate' },
];

export default function TabLayout() {
  const { t } = useApp();
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          height: layout.tabBarHeight,
          paddingTop: spacing.sm,
          paddingBottom: spacing.sm,
          borderTopColor: colors.border,
          backgroundColor: colors.white,
        },
        tabBarLabelStyle: { ...typography.label, marginTop: 2 },
        tabBarActiveTintColor: colors.blue,
        tabBarInactiveTintColor: colors.muted,
      }}
    >
      {tabs.map((tab) => (
        <Tabs.Screen
          key={tab.name}
          name={tab.name}
          options={{
            title: t(tab.label),
            tabBarIcon: ({ focused }) => (
              <Icon name={focused ? tab.icon : (tab.icon.replace('-on', '-off') as IconName)} size={24} />
            ),
          }}
        />
      ))}
    </Tabs>
  );
}
