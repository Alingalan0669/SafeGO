import 'package:flutter/foundation.dart';

import '../models/household_profile.dart';
import '../services/local_storage_service.dart';

/// Owns the household profile and persists every edit.
///
/// UI widgets only read [profile] and call [save]; validation and storage
/// live here so screens stay declarative.
class HouseholdProvider extends ChangeNotifier {
  HouseholdProvider(this._storage) {
    _restore();
  }

  final LocalStorageService _storage;

  HouseholdProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  HouseholdProfile? get profile => _profile;
  bool get hasProfile => _profile != null;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isPersistent => _storage.isPersistent;

  /// Values used to pre-fill household setup.
  HouseholdProfile get draft => _profile ?? HouseholdProfile.initial();

  Future<void> _restore() async {
    try {
      _profile = _storage.loadProfile();
    } catch (_) {
      _error = 'Your saved household could not be opened.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validates and persists a household. Returns false when the write fails so
  /// the screen can keep the user on the form and show a message.
  Future<bool> save(HouseholdProfile next) async {
    if (next.memberCount < 1 || next.memberCount > 12) {
      _error = 'Choose between 1 and 12 family members.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    final saved = await _storage.saveProfile(next);
    _isSaving = false;

    if (!saved) {
      _error = 'We could not save your household on this phone. Try again.';
      notifyListeners();
      return false;
    }

    _profile = next;
    notifyListeners();
    return true;
  }

  /// Removes every SafeGo key and the in-memory profile.
  ///
  /// The checklist and settings providers are reset by the Settings screen
  /// after this succeeds, so a partial failure cannot leave stale UI.
  Future<bool> clearAllData() async {
    final saved = await _storage.clearAll();
    if (!saved) {
      _error = 'Saved data could not be cleared on this phone.';
      notifyListeners();
      return false;
    }
    reset();
    return true;
  }

  /// Clears the profile after a full data reset.
  void reset() {
    _profile = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  /// Screens call this once to show a snackbar, then the error is cleared.
  String? takeError() {
    final error = _error;
    _error = null;
    return error;
  }
}
