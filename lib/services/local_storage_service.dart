import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/household_profile.dart';

/// Offline persistence for SafeGo.
///
/// Everything the app needs is stored on the device with shared_preferences:
/// the household profile, checklist ticks and accessibility preferences.
/// No network request is ever made, which is the core of the offline-first
/// requirement.
///
/// All methods are defensive: a storage failure returns `false`/`null`
/// instead of throwing, so the UI can show a friendly error.
class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences? _prefs;

  /// Opens the on-device storage. If the platform store is unavailable we
  /// still return a service (in-memory no-op) so the app can run.
  static Future<LocalStorageService> create() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return LocalStorageService._(prefs);
    } catch (_) {
      return LocalStorageService._(null);
    }
  }

  /// False when the OS store could not be opened; the app remains usable but
  /// changes will not survive a restart.
  bool get isPersistent => _prefs != null;

  // ---------------------------------------------------------------------------
  // Household profile
  // ---------------------------------------------------------------------------

  HouseholdProfile? loadProfile() {
    final raw = _prefs?.getString(AppConstants.profileKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return HouseholdProfile.fromJson(decoded);
    } catch (_) {
      // Corrupt payload: ignore it and let onboarding run again.
      return null;
    }
  }

  Future<bool> saveProfile(HouseholdProfile profile) async {
    try {
      return await _prefs?.setString(
            AppConstants.profileKey,
            jsonEncode(profile.toJson()),
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Checklist ticks (a flat set of completed item ids)
  // ---------------------------------------------------------------------------

  Set<String> loadCompletedIds() {
    try {
      return (_prefs?.getStringList(AppConstants.checklistKey) ?? const [])
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<bool> saveCompletedIds(Set<String> ids) async {
    try {
      final sorted = ids.toList()..sort();
      return await _prefs?.setStringList(AppConstants.checklistKey, sorted) ??
          false;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------

  AppLanguage loadLanguage() {
    final value = _prefs?.getString('${AppConstants.settingsKey}.language');
    return AppLanguage.values.firstWhere(
      (language) => language.name == value,
      orElse: () => AppLanguage.english,
    );
  }

  bool loadLargeText() =>
      _prefs?.getBool('${AppConstants.settingsKey}.largeText') ?? false;

  Future<bool> saveSettings({
    required AppLanguage language,
    required bool largeText,
  }) async {
    try {
      final languageSaved = await _prefs?.setString(
            '${AppConstants.settingsKey}.language',
            language.name,
          ) ??
          false;
      final textSaved = await _prefs?.setBool(
            '${AppConstants.settingsKey}.largeText',
            largeText,
          ) ??
          false;
      return languageSaved && textSaved;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  /// Removes every SafeGo key. Used by "Clear saved data" after confirmation.
  Future<bool> clearAll() async {
    try {
      final prefs = _prefs;
      if (prefs == null) return false;
      await prefs.remove(AppConstants.profileKey);
      await prefs.remove(AppConstants.checklistKey);
      await prefs.remove('${AppConstants.settingsKey}.language');
      await prefs.remove('${AppConstants.settingsKey}.largeText');
      return true;
    } catch (_) {
      return false;
    }
  }
}
