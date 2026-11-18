import React from 'react';
import { Redirect } from 'expo-router';
import { useApp } from '../src/store/AppContext';

/** First launch shows the splash/onboarding flow; returning users go straight home. */
export default function Index() {
  const { loading, profile } = useApp();
  if (loading) return null;
  return <Redirect href={profile?.onboarded ? '/(tabs)' : '/splash'} />;
}
