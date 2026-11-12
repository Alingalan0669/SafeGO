/// An emergency contact loaded from the bundled mock JSON.
class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    this.isSample = true,
    this.isEmergencyService = false,
  });

  final String id;
  final String name;
  final String relationship;
  final String phone;

  /// Demo numbers are labelled in the UI so nobody relies on them for real.
  final bool isSample;

  /// True for the national 911 hotline, which gets a full-width button.
  final bool isEmergencyService;

  String get displayName =>
      relationship.trim().isEmpty ? name : '$name • $relationship';

  /// "Sample contact" or "Emergency hotline" - keeps the row honest.
  String get detailLabel {
    if (isEmergencyService) return 'National emergency hotline';
    return isSample ? 'Sample contact • confirm number' : relationship;
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];
    final rawPhone = json['phone'];
    return EmergencyContact(
      id: (json['id'] as String?) ?? 'contact-${json['name']}',
      name: rawName is String && rawName.trim().isNotEmpty
          ? rawName.trim()
          : 'Saved contact',
      relationship: (json['relationship'] as String?) ?? '',
      phone: rawPhone is String ? rawPhone : '',
      isSample: json['isSample'] != false,
      isEmergencyService: json['isEmergencyService'] == true,
    );
  }
}
