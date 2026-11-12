/// Small, pure helpers shared by screens and providers.
///
/// Keeping these functions pure makes them trivial to unit test and easy to
/// explain during the oral defense.
library;

/// Returns a time-aware greeting used on the Home dashboard.
String greetingFor(DateTime time) {
  final hour = time.hour;
  if (hour < 12) return 'Good morning';
  if (hour < 18) return 'Good afternoon';
  return 'Good evening';
}

/// Clamps a percentage into the 0-100 range and rounds it for display.
int clampPercent(num raw) => raw.clamp(0, 100).round();

/// Formats a completion ratio (0.0 - 1.0) without dividing by zero.
String percentLabel(int done, int total) {
  if (total <= 0) return '0%';
  return '${((done / total) * 100).clamp(0, 100).round()}%';
}

/// "1 person" / "5 people" - avoids awkward copy in the household summary.
String peopleLabel(int count) => '$count ${count == 1 ? 'person' : 'people'}';

/// Keeps only digits and a leading + so a phone number is safe to put in a
/// `tel:` URI. Example: "+63 917 000 0001" -> "+639170000001".
String sanitisePhoneNumber(String raw) {
  final trimmed = raw.trim();
  final hasPlus = trimmed.startsWith('+');
  final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return '';
  return hasPlus ? '+$digits' : digits;
}

/// 1.2 km / 750 m - used by the evacuation center card.
String distanceLabel(double kilometres) {
  if (kilometres <= 0) return 'Distance unavailable';
  if (kilometres < 1) return '${(kilometres * 1000).round()} m away';
  return '${kilometres.toStringAsFixed(1)} km away';
}

/// Converts a list of strings into a readable sentence fragment:
/// ["Children", "Flood"] -> "Children • Flood".
String bulletJoin(Iterable<String> values) => values.join(' • ');
