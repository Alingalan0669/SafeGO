import 'package:flutter_test/flutter_test.dart';
import 'package:safego/core/utils/checklist_factory.dart';
import 'package:safego/models/household_profile.dart';

void main() {
  const base = HouseholdProfile(
    ownerName: 'Maria',
    memberCount: 5,
    hasChildren: false,
    hasSeniors: false,
    hasDisability: false,
    hasPets: false,
    hazard: HazardType.flood,
  );

  test('prepare template has four unique steps', () {
    expect(prepareChecklistTemplate, hasLength(4));
    expect(
      prepareChecklistTemplate.map((item) => item.id).toSet(),
      hasLength(4),
    );
  });

  test('base go-bag has 14 items', () {
    expect(buildPackChecklist(base), hasLength(14));
  });

  test('children adds one personalised item (15 total)', () {
    final pack = buildPackChecklist(base.copyWith(hasChildren: true));
    expect(pack, hasLength(15));
    expect(pack.where((item) => item.isPersonalised), hasLength(1));
    expect(pack.first.id, 'pack.water');
    expect(
      pack.first.detail,
      contains('15 L'),
      reason: 'water scales with the household size',
    );
  });

  test('all household needs produce 19 unique items', () {
    final pack = buildPackChecklist(
      base.copyWith(
        hasChildren: true,
        hasSeniors: true,
        hasDisability: true,
        hasPets: true,
      ),
    );
    expect(pack, hasLength(19));
    expect(pack.map((item) => item.id).toSet(), hasLength(19));
    expect(pack.where((item) => item.isPersonalised), hasLength(5));
  });

  test('a null profile still returns a usable base list', () {
    expect(buildPackChecklist(null), hasLength(14));
  });
}
