import '../core/utils/app_utils.dart';

/// Hazards supported by the MVP. `name` is what gets persisted in JSON.
enum HazardType { flood, typhoon, quake }

extension HazardTypeX on HazardType {
  String get label => switch (this) {
        HazardType.flood => 'Flood',
        HazardType.typhoon => 'Typhoon',
        HazardType.quake => 'Quake',
      };

  /// Short safety line shown in the go-bag header.
  String get packNote => switch (this) {
        HazardType.flood => 'Never walk or drive through floodwater.',
        HazardType.typhoon => 'Secure loose items and charge your phone early.',
        HazardType.quake => 'Drop, cover, then move to open ground.',
      };
}

/// Language preference. English is fully wired; Filipino is stored for the
/// next translation pass so the preference survives restarts.
enum AppLanguage { english, filipino }

extension AppLanguageX on AppLanguage {
  String get label => this == AppLanguage.english ? 'English' : 'Filipino';
}

/// The household is the single source of personalisation for SafeGo.
///
/// It is immutable: every edit creates a new instance and is persisted by
/// [HouseholdProvider]. That makes state changes predictable and testable.
class HouseholdProfile {
  const HouseholdProfile({
    required this.ownerName,
    required this.memberCount,
    required this.hasChildren,
    required this.hasSeniors,
    required this.hasDisability,
    required this.hasPets,
    required this.hazard,
  });

  final String ownerName;
  final int memberCount;
  final bool hasChildren;
  final bool hasSeniors;
  final bool hasDisability;
  final bool hasPets;
  final HazardType hazard;

  /// Initial values shown on a first run. They mirror the Figma demo household
  /// (Maria, 5 people, children, flood) so the prototype opens with rich data.
  factory HouseholdProfile.initial() => const HouseholdProfile(
        ownerName: 'Maria',
        memberCount: 5,
        hasChildren: true,
        hasSeniors: false,
        hasDisability: false,
        hasPets: false,
        hazard: HazardType.flood,
      );

  /// "Maria’s household" - used on Settings.
  String get displayName => '$ownerName’s household';

  /// "5 people • Children • Flood" - matches the Settings summary card.
  String get summaryLine {
    final parts = <String>[
      peopleLabel(memberCount),
      if (hasChildren) 'Children',
      if (hasSeniors) 'Seniors',
      if (hasDisability) 'Disability support',
      if (hasPets) 'Pets',
      hazard.label,
    ];
    return bulletJoin(parts);
  }

  /// A compact fingerprint used to decide whether the go-bag must be rebuilt.
  /// Done/packed ticks are keyed by item id so they survive the rebuild.
  String get packSignature =>
      '$memberCount|$hasChildren|$hasSeniors|$hasDisability|$hasPets|${hazard.name}';

  HouseholdProfile copyWith({
    String? ownerName,
    int? memberCount,
    bool? hasChildren,
    bool? hasSeniors,
    bool? hasDisability,
    bool? hasPets,
    HazardType? hazard,
  }) {
    return HouseholdProfile(
      ownerName: ownerName ?? this.ownerName,
      memberCount: memberCount ?? this.memberCount,
      hasChildren: hasChildren ?? this.hasChildren,
      hasSeniors: hasSeniors ?? this.hasSeniors,
      hasDisability: hasDisability ?? this.hasDisability,
      hasPets: hasPets ?? this.hasPets,
      hazard: hazard ?? this.hazard,
    );
  }

  Map<String, dynamic> toJson() => {
        'ownerName': ownerName,
        'memberCount': memberCount,
        'hasChildren': hasChildren,
        'hasSeniors': hasSeniors,
        'hasDisability': hasDisability,
        'hasPets': hasPets,
        'hazard': hazard.name,
      };

  /// Defensive parsing: a corrupt or partial JSON payload must never crash the
  /// app. Invalid values fall back to safe defaults.
  factory HouseholdProfile.fromJson(Map<String, dynamic> json) {
    final rawName = json['ownerName'];
    final name = rawName is String ? rawName.trim() : '';
    final rawCount = json['memberCount'];
    final count = rawCount is num ? rawCount.toInt() : 5;

    return HouseholdProfile(
      ownerName: name.isEmpty ? 'Maria' : name,
      memberCount: count.clamp(1, 12),
      hasChildren: json['hasChildren'] == true,
      hasSeniors: json['hasSeniors'] == true,
      hasDisability: json['hasDisability'] == true,
      hasPets: json['hasPets'] == true,
      hazard: HazardType.values.firstWhere(
        (value) => value.name == json['hazard'],
        orElse: () => HazardType.flood,
      ),
    );
  }
}
