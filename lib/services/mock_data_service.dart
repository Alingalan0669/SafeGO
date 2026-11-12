import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/emergency_contact.dart';
import '../models/evacuation_center.dart';

/// Bundle of data the Evacuate screen needs.
class EvacuationDataset {
  const EvacuationDataset({
    required this.centers,
    required this.contacts,
    this.usedFallback = false,
  });

  final List<EvacuationCenter> centers;
  final List<EmergencyContact> contacts;

  /// True when the JSON asset could not be read and in-code fallbacks were
  /// used. The UI still works, but shows an honest "saved data" banner.
  final bool usedFallback;

  List<EmergencyContact> get familyContacts =>
      contacts.where((contact) => !contact.isEmergencyService).toList();

  EmergencyContact? get emergencyContact {
    for (final contact in contacts) {
      if (contact.isEmergencyService) return contact;
    }
    return null;
  }
}

/// Loads mock evacuation data from the bundled JSON asset.
///
/// The app intentionally never calls a weather/evacuation API in this MVP:
/// the data is packaged with the build so it is available with zero signal.
class MockDataService {
  static const String assetPath = 'assets/data/evacuation_data.json';

  Future<EvacuationDataset> load() async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return _fallback();
      }

      final centers = _parseCenters(decoded['centers']);
      final contacts = _parseContacts(decoded['contacts']);
      if (centers.isEmpty || contacts.isEmpty) return _fallback();

      return EvacuationDataset(
        centers: centers,
        contacts: _ensureEmergencyService(contacts),
      );
    } catch (_) {
      // Missing/corrupt asset or invalid JSON: fall back to compiled-in demo
      // data rather than crashing the Evacuate tab.
      return _fallback();
    }
  }

  List<EvacuationCenter> _parseCenters(dynamic raw) {
    if (raw is! List) return const [];
    final centers = <EvacuationCenter>[];
    for (final entry in raw) {
      if (entry is Map<String, dynamic>) {
        centers.add(EvacuationCenter.fromJson(entry));
      }
    }
    return centers;
  }

  List<EmergencyContact> _parseContacts(dynamic raw) {
    if (raw is! List) return const [];
    final contacts = <EmergencyContact>[];
    for (final entry in raw) {
      if (entry is Map<String, dynamic>) {
        contacts.add(EmergencyContact.fromJson(entry));
      }
    }
    return contacts;
  }

  /// 911 must always be reachable, even if the JSON omits it.
  List<EmergencyContact> _ensureEmergencyService(
    List<EmergencyContact> contacts,
  ) {
    if (contacts.any((contact) => contact.isEmergencyService)) return contacts;
    return [...contacts, _fallbackEmergencyContact];
  }

  EvacuationDataset _fallback() => EvacuationDataset(
        centers: _fallbackCenters,
        contacts: [..._fallbackContacts, _fallbackEmergencyContact],
        usedFallback: true,
      );

  static const EmergencyContact _fallbackEmergencyContact = EmergencyContact(
    id: 'contact-emergency',
    name: 'Emergency services',
    relationship: 'National hotline',
    phone: '911',
    isSample: false,
    isEmergencyService: true,
  );

  static const List<EvacuationCenter> _fallbackCenters = [
    EvacuationCenter(
      id: 'san-isidro-es',
      name: 'San Isidro Elementary School',
      address: 'Purok 3, Brgy. San Isidro, San Pablo City, Laguna',
      barangay: 'San Isidro',
      distanceKm: 1.2,
      notes: 'Covered court is the assembly area. Bring IDs and medicines.',
    ),
    EvacuationCenter(
      id: 'san-isidro-covered-court',
      name: 'San Isidro Covered Court',
      address: 'Purok 1, Brgy. San Isidro, San Pablo City, Laguna',
      barangay: 'San Isidro',
      distanceKm: 2.4,
      notes: 'Higher ground and a backup when the school is full.',
    ),
  ];

  static const List<EmergencyContact> _fallbackContacts = [
    EmergencyContact(
      id: 'contact-ana',
      name: 'Ana',
      relationship: 'Sister',
      phone: '+63 917 000 0001',
    ),
    EmergencyContact(
      id: 'contact-barangay',
      name: 'San Isidro Barangay Hall',
      relationship: 'Local hotline',
      phone: '+63 49 000 0002',
    ),
  ];
}
