import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/utils/checklist_factory.dart';
import '../models/checklist_item.dart';
import '../models/household_profile.dart';
import '../services/local_storage_service.dart';

/// Owns both checklists (Prepare and Pack) and the readiness score.
///
/// Ticks are stored as a flat set of item ids so they survive a household
/// change: the go-bag list can be regenerated while "packed" ticks remain on
/// items that still exist.
class ChecklistProvider extends ChangeNotifier {
  ChecklistProvider(this._storage) : _completedIds = _storage.loadCompletedIds() {
    _prepareItems = _applyTicks(prepareChecklistTemplate);
    _packItems = _applyTicks(buildPackChecklist(null));
  }

  final LocalStorageService _storage;
  final Set<String> _completedIds;

  late List<ChecklistItem> _prepareItems;
  late List<ChecklistItem> _packItems;

  String _packSignature = '';
  HouseholdProfile? _profile;
  String? _error;
  Timer? _persistDebounce;
  bool _disposed = false;

  List<ChecklistItem> get prepareItems => _prepareItems;
  List<ChecklistItem> get packItems => _packItems;

  int get prepareTotal => _prepareItems.length;
  int get packTotal => _packItems.length;

  int get prepareDone => _prepareItems.where((item) => item.isDone).length;
  int get packDone => _packItems.where((item) => item.isDone).length;

  int get totalDone => prepareDone + packDone;
  int get totalItems => prepareTotal + packTotal;

  /// 0-100 readiness: prepared steps plus packed go-bag items over everything
  /// the household currently needs to do.
  int get readinessPercent {
    if (totalItems <= 0) return 0;
    return ((totalDone / totalItems) * 100).clamp(0, 100).round();
  }

  /// Short label used by the Home score ring.
  String get readinessLabel {
    if (readinessPercent >= 100) return 'Fully prepared';
    if (readinessPercent >= 70) return 'Almost ready';
    if (readinessPercent >= 40) return 'Making progress';
    return 'Just getting started';
  }

  /// The next unfinished item, Prepare first, then Pack.
  ChecklistItem? get nextStep {
    for (final item in _prepareItems) {
      if (!item.isDone) return item;
    }
    for (final item in _packItems) {
      if (!item.isDone) return item;
    }
    return null;
  }

  bool isDone(String id) => _completedIds.contains(id);

  /// Rebuilds the personalised go-bag when the household changes.
  ///
  /// Called by the `ChangeNotifierProxyProvider` in `main.dart`. A signature
  /// check keeps this cheap and prevents rebuilding on unrelated rebuilds.
  void syncProfile(HouseholdProfile? profile) {
    _profile = profile;
    final signature = profile?.packSignature ?? 'none';
    if (signature == _packSignature) return;

    _packSignature = signature;
    _packItems = _applyTicks(buildPackChecklist(profile));

    // The proxy provider calls this during build; deferring the notification
    // avoids "markNeedsBuild during build" while still refreshing listeners.
    scheduleMicrotask(() {
      if (!_disposed) notifyListeners();
    });
  }

  /// Toggles one row and persists the tick set.
  ///
  /// The UI updates immediately; the write is debounced because people often
  /// tick several rows in a row and each SharedPreferences write is a disk
  /// round-trip.
  Future<void> toggle(String id) async {
    if (_completedIds.contains(id)) {
      _completedIds.remove(id);
    } else {
      _completedIds.add(id);
    }

    _prepareItems = _applyTicks(prepareChecklistTemplate);
    _packItems = _applyTicks(buildPackChecklist(_profile));
    notifyListeners();

    _persistDebounce?.cancel();
    _persistDebounce = Timer(const Duration(milliseconds: 150), _persist);
  }

  Future<void> _persist() async {
    final saved = await _storage.saveCompletedIds(_completedIds);
    if (!saved) {
      _error = 'Your checklist changes were not saved on this phone.';
      notifyListeners();
    }
  }

  /// Drops every tick after the user confirms a full reset.
  Future<void> clearAll() async {
    _persistDebounce?.cancel();
    _completedIds.clear();
    _prepareItems = _applyTicks(prepareChecklistTemplate);
    _packItems = _applyTicks(buildPackChecklist(_profile));
    notifyListeners();

    final saved = await _storage.saveCompletedIds(_completedIds);
    if (!saved) {
      _error = 'The checklist could not be cleared on this phone.';
      notifyListeners();
    }
  }

  List<ChecklistItem> _applyTicks(List<ChecklistItem> items) {
    return List.unmodifiable(
      items.map(
        (item) => item.copyWith(isDone: _completedIds.contains(item.id)),
      ),
    );
  }

  /// Screens show this once in a snackbar, then it is cleared.
  String? takeError() {
    final error = _error;
    _error = null;
    return error;
  }

  @override
  void dispose() {
    _disposed = true;
    _persistDebounce?.cancel();
    super.dispose();
  }
}
