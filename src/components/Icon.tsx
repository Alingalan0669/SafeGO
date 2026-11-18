import React from 'react';
import Svg, { Path } from 'react-native-svg';
import { colors } from '../theme';

export type IconName =
  | 'check'
  | 'home-on'
  | 'home-off'
  | 'prepare-on'
  | 'prepare-off'
  | 'pack-on'
  | 'pack-off'
  | 'evacuate-on'
  | 'evacuate-off'
  | 'settings'
  | 'alert-warning'
  | 'alert-danger'
  | 'offline';

const paths: Record<IconName, string[]> = {
  check: ['M5 12L9 16L19 6'],
  'home-on': ['M3 10L12 3L21 10V21H15V14H9V21H3V10Z'],
  'home-off': ['M3 10L12 3L21 10V21H15V14H9V21H3V10Z'],
  'prepare-on': [
    'M7 4H17C18.1046 4 19 4.89543 19 6V19C19 20.1046 18.1046 21 17 21H7C5.89543 21 5 20.1046 5 19V6C5 4.89543 5.89543 4 7 4Z',
    'M8 12L10 14L15 9M8 18H16M9 3H15V7H9V3Z',
  ],
  'prepare-off': [
    'M7 4H17C18.1046 4 19 4.89543 19 6V19C19 20.1046 18.1046 21 17 21H7C5.89543 21 5 20.1046 5 19V6C5 4.89543 5.89543 4 7 4Z',
    'M8 12L10 14L15 9M8 18H16M9 3H15V7H9V3Z',
  ],
  'pack-on': [
    'M9 6H15C17.2091 6 19 7.79086 19 10V18C19 20.2091 17.2091 22 15 22H9C6.79086 22 5 20.2091 5 18V10C5 7.79086 6.79086 6 9 6Z',
    'M9 6V3H15V6M5 12H19M9 16H15',
  ],
  'pack-off': [
    'M9 6H15C17.2091 6 19 7.79086 19 10V18C19 20.2091 17.2091 22 15 22H9C6.79086 22 5 20.2091 5 18V10C5 7.79086 6.79086 6 9 6Z',
    'M9 6V3H15V6M5 12H19M9 16H15',
  ],
  'evacuate-on': ['M4 20H20M7 17L11 12L8 9L12 5L16 8H20M12 12L17 17V21M11 5V2'],
  'evacuate-off': ['M4 20H20M7 17L11 12L8 9L12 5L16 8H20M12 12L17 17V21M11 5V2'],
  settings: [
    'M16 8C16 10.2091 14.2091 12 12 12C9.79086 12 8 10.2091 8 8C8 5.79086 9.79086 4 12 4C14.2091 4 16 5.79086 16 8Z',
    'M4 22V19C4 16.8783 4.84285 14.8434 6.34315 13.3431C7.84344 11.8429 9.87827 11 12 11C14.1217 11 16.1566 11.8429 17.6569 13.3431C19.1571 14.8434 20 16.8783 20 19V22',
  ],
  'alert-warning': ['M12 9V14M12 17H12.01M12 3L22 21H2L12 3Z'],
  'alert-danger': ['M12 9V14M12 17H12.01M12 3L22 21H2L12 3Z'],
  offline: [
    'M3 3L21 21M2 8C3.23313 7.14936 4.57961 6.47612 6 6M10 5C12.0992 4.67866 14.2414 4.77842 16.3016 5.29349C18.3619 5.80855 20.299 6.7286 22 8M5 12C6.47522 10.9294 8.19337 10.2421 10 10M15 11C16.3844 11.0782 17.7416 11.4175 19 12M8 16C8.91052 15.1135 10.079 14.539 11.337 14.3593C12.5951 14.1795 13.8777 14.4039 15 15M12 20H12.01',
  ],
};

const strokeFor = (name: IconName): string => {
  if (name === 'check') return colors.white;
  if (name === 'alert-warning') return colors.amber;
  if (name === 'alert-danger') return colors.red;
  if (name === 'offline') return colors.blue;
  if (name.endsWith('-off')) return colors.muted;
  return colors.blue;
};

export function Icon({ name, size = 24 }: { name: IconName; size?: number }) {
  const stroke = strokeFor(name);
  return (
    <Svg width={size} height={size} viewBox="0 0 24 24" fill="none" accessibilityElementsHidden>
      {paths[name].map((d, index) => (
        <Path
          key={index}
          d={d}
          stroke={stroke}
          strokeWidth={1.8}
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      ))}
    </Svg>
  );
}
