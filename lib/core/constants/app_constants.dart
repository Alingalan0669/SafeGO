/// App-wide constants and storage keys.
abstract final class AppConstants {
  static const String appName = 'SafeGo';
  static const String tagline = 'Prepare. Pack. Evacuate.';

  /// National emergency hotline used by the Evacuate screens.
  static const String emergencyNumber = '911';

  /// The prototype deliberately uses demo data. These labels keep that clear.
  static const String demoDataNotice =
      'Demo data • Confirm with your barangay before an emergency';
  static const String offlineNotice = 'Saved on this phone • Works offline';

  // ---- SharedPreferences keys (versioned so future migrations are explicit) ----
  static const String profileKey = 'safego.profile.v1';
  static const String checklistKey = 'safego.checklist.v1';
  static const String settingsKey = 'safego.settings.v1';

  static const int minMembers = 1;
  static const int maxMembers = 12;

  /// Minimum accessible touch target, in logical pixels.
  static const double minTouchTarget = 48;
}
