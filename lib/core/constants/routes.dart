/// Named routes. Screens and providers must use these instead of raw strings
/// so a rename only happens in one place.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String setup = '/setup';

  static const String home = '/home';
  static const String prepare = '/prepare';
  static const String pack = '/pack';
  static const String evacuate = '/evacuate';

  static const String evacuateNow = '/evacuate-now';
  static const String safe = '/safe';
  static const String settings = '/settings';
  static const String editHousehold = '/setup?edit=1';
  static const String textPreview = '/text-preview';
  static const String offline = '/offline';
  static const String error = '/error';
  static const String empty = '/empty';
}
