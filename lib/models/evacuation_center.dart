/// Evacuation center loaded from `assets/data/evacuation_data.json`.
///
/// The data is bundled with the app, so the Evacuate screen works with no
/// internet connection. Every record is flagged as demo data.
class EvacuationCenter {
  const EvacuationCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.barangay,
    required this.distanceKm,
    required this.notes,
    this.isDemo = true,
  });

  final String id;
  final String name;
  final String address;
  final String barangay;
  final double distanceKm;
  final String notes;
  final bool isDemo;

  factory EvacuationCenter.fromJson(Map<String, dynamic> json) {
    final rawDistance = json['distanceKm'];
    return EvacuationCenter(
      id: (json['id'] as String?) ?? 'center',
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? (json['name'] as String).trim()
          : 'Evacuation center',
      address: (json['address'] as String?) ?? 'Address unavailable',
      barangay: (json['barangay'] as String?) ?? '',
      distanceKm: rawDistance is num ? rawDistance.toDouble() : 0,
      notes: (json['notes'] as String?) ?? '',
      isDemo: json['isDemo'] != false,
    );
  }
}
