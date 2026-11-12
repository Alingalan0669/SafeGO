import 'package:flutter/foundation.dart';

import '../models/household_profile.dart';
import '../services/local_storage_service.dart';

/// Accessibility + language preferences.
///
/// Both settings are stored locally so they apply before any network (there is
/// no network call in this MVP) and survive restarts.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._storage)
      : _language = _storage.loadLanguage(),
        _largeText = _storage.loadLargeText();

  final LocalStorageService _storage;

  AppLanguage _language;
  bool _largeText;
  String? _error;

  AppLanguage get language => _language;
  bool get largeText => _largeText;

  /// Global text scale handed to `MaterialApp.builder`.
  ///
  /// 1.15 is the Figma "Large text preview": readable without breaking the
  /// 390px layout. We clamp Flutter's own scale on top of this for safety.
  double get textScaleFactor => _largeText ? 1.15 : 1.0;

  Future<void> setLanguage(AppLanguage next) async {
    if (next == _language) return;
    _language = next;
    notifyListeners();
    await _persist();
  }

  Future<void> setLargeText(bool enabled) async {
    if (enabled == _largeText) return;
    _largeText = enabled;
    notifyListeners();
    await _persist();
  }

  Future<bool> _persist() async {
    final saved = await _storage.saveSettings(
      language: _language,
      largeText: _largeText,
    );
    if (!saved) {
      _error = 'Your display preferences were not saved on this phone.';
      notifyListeners();
    }
    return saved;
  }

  /// Restores defaults after "Clear saved data".
  Future<void> reset() async {
    _language = AppLanguage.english;
    _largeText = false;
    notifyListeners();
  }

  String? takeError() {
    final error = _error;
    _error = null;
    return error;
  }
}
