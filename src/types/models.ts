/** Shared TypeScript models for SafeGo. */

export type Hazard = 'Flood' | 'Typhoon' | 'Quake';
export type Language = 'en' | 'fil';
export type TextSize = 'standard' | 'large';

export interface HouseholdProfile {
  id: string;
  name: string;
  memberCount: number;
  hasChildren: boolean;
  hasSeniors: boolean;
  hasDisability: boolean;
  hasPets: boolean;
  hazard: Hazard;
  onboarded: boolean;
  createdAt: string;
}

export interface ChecklistItem {
  id: string;
  title: string;
  detail: string;
  category: string;
  isDone?: boolean;
  isPersonalised?: boolean;
}

export interface EvacuationCenter {
  id: string;
  name: string;
  address: string;
  barangay: string;
  distanceKm: number;
  isDemo: boolean;
  notes: string;
}

export interface EmergencyContact {
  id: string;
  name: string;
  relationship: string;
  phone: string;
  isSample: boolean;
  isEmergencyService: boolean;
}

export interface EvacuationData {
  notice: string;
  centers: EvacuationCenter[];
  contacts: EmergencyContact[];
}

export interface AppSettings {
  language: Language;
  textSize: TextSize;
}

export interface PersistedState {
  profile: HouseholdProfile | null;
  completedIds: string[];
  settings: AppSettings;
}
