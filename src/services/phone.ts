import { Linking } from 'react-native';

/** Strip spaces/dashes but keep leading + so international numbers still dial. */
export function dial(phone: string): Promise<boolean> {
  const cleaned = phone.replace(/[^\d+]/g, '');
  return Linking.openURL(`tel:${cleaned}`).then(() => true).catch(() => false);
}
