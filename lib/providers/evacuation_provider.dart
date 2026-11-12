import 'package:flutter/foundation.dart';

import '../models/emergency_contact.dart';
import '../models/evacuation_center.dart';
import '../services/mock_data_service.dart';
import '../services/phone_service.dart';

/// Loads the bundled evacuation dataset and performs one-tap calls.
///
/// Data is packaged in `assets/data/evacuation_data.json`, so this works with
/// no signal. `usedFallback` is surfaced to the UI so the user knows when
/// compiled-in demo data is being shown instead.
class EvacuationProvider extends ChangeNotifier {
  EvacuationProvider({
    MockDataService? dataService,
    PhoneService? phoneService,
  })  : _dataService = dataService ?? MockDataService(),
        _phoneService = phoneService ?? PhoneService();

  final MockDataService _dataService;
  final PhoneService _phoneService;

  List<EvacuationCenter> _centers = const [];
  List<EmergencyContact> _contacts = const [];
  EvacuationCenter? _selectedCenter;
  bool _isLoading = true;
  bool _usedFallback = false;
  String? _error;
  String? _callError;

  List<EvacuationCenter> get centers => _centers;
  EvacuationCenter? get selectedCenter => _selectedCenter;
  bool get isLoading => _isLoading;
  bool get usedFallback => _usedFallback;

  /// Read-only error for screens that need to render it inline.
  String? get error => _error;

  List<EmergencyContact> get familyContacts =>
      _contacts.where((contact) => !contact.isEmergencyService).toList();

  EmergencyContact? get emergencyContact {
    for (final contact in _contacts) {
      if (contact.isEmergencyService) return contact;
    }
    return null;
  }

  /// Primary center used by the Evacuate Now flow.
  EvacuationCenter? get primaryCenter =>
      _centers.isEmpty ? null : _centers.first;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dataset = await _dataService.load();
      _centers = List.unmodifiable(dataset.centers);
      _contacts = List.unmodifiable(dataset.contacts);
      _usedFallback = dataset.usedFallback;
      _selectedCenter = _centers.isEmpty ? null : _centers.first;

      if (_centers.isEmpty && _contacts.isEmpty) {
        _error = 'No evacuation data is saved on this phone yet.';
      }
    } catch (_) {
      // MockDataService already has a fallback; this is a last-resort guard so
      // a broken asset can never take the Evacuate tab down.
      _centers = const [];
      _contacts = const [];
      _error = 'Evacuation details could not be opened. Try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCenter(EvacuationCenter center) {
    if (_selectedCenter?.id == center.id) return;
    _selectedCenter = center;
    notifyListeners();
  }

  /// Opens the dialer for [contact]. Returns a message to show on failure so
  /// the screen can keep the user informed (emulators often lack a dialer).
  Future<String?> call(EmergencyContact contact) async {
    final result = await _phoneService.placeCall(contact.phone);
    if (result.launched) return null;
    _callError = result.error ?? 'The call could not be started.';
    return _callError;
  }

  String? takeError() {
    final error = _error;
    _error = null;
    return error;
  }

  String? takeCallError() {
    final error = _callError;
    _callError = null;
    return error;
  }
}
