import 'package:flutter_test/flutter_test.dart';
import 'package:safego/models/household_profile.dart';
import 'package:safego/providers/checklist_provider.dart';
import 'package:safego/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const profile = HouseholdProfile(
    ownerName: 'Maria',
    memberCount: 5,
    hasChildren: true,
    hasSeniors: false,
    hasDisability: false,
    hasPets: false,
    hazard: HazardType.flood,
  );

  late LocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.create();
  });

  test('readiness is the share of prepare and packed items', () async {
    final provider = ChecklistProvider(storage);
    provider.syncProfile(profile);

    expect(provider.prepareTotal, 4);
    expect(provider.packTotal, 15);
    expect(provider.readinessPercent, 0);

    await provider.toggle('prep.plan');
    expect(provider.prepareDone, 1);
    expect(provider.readinessPercent, 5); // 1 / 19

    await provider.toggle('pack.water');
    expect(provider.packDone, 1);
    expect(provider.readinessPercent, 11); // 2 / 19
  });

  test('ticks survive a household change by item id', () async {
    final provider = ChecklistProvider(storage);
    provider.syncProfile(profile);
    await provider.toggle('pack.children');

    expect(provider.isDone('pack.children'), isTrue);

    // Remove children; the tick stays stored but the item disappears.
    provider.syncProfile(profile.copyWith(hasChildren: false));
    expect(provider.packTotal, 14);
    expect(provider.isDone('pack.children'), isTrue);

    // Add children back: the same item returns already ticked.
    provider.syncProfile(profile.copyWith(hasChildren: true));
    final childItem = provider.packItems.firstWhere(
      (item) => item.id == 'pack.children',
    );
    expect(childItem.isDone, isTrue);
  });

  test('nextStep prefers prepare, then pack', () async {
    final provider = ChecklistProvider(storage);
    provider.syncProfile(profile);

    expect(provider.nextStep?.id, 'prep.plan');

    for (final item in provider.prepareItems) {
      await provider.toggle(item.id);
    }
    expect(provider.nextStep?.id, 'pack.water');
  });

  test('clearAll removes every tick', () async {
    final provider = ChecklistProvider(storage);
    provider.syncProfile(profile);
    await provider.toggle('prep.plan');
    await provider.clearAll();

    expect(provider.totalDone, 0);
    expect(provider.readinessPercent, 0);
  });

  test('profile parsing falls back safely', () {
    final parsed = HouseholdProfile.fromJson({
      'ownerName': '',
      'memberCount': 99,
      'hazard': 'unknown',
    });

    expect(parsed.ownerName, 'Maria');
    expect(parsed.memberCount, 12);
    expect(parsed.hazard, HazardType.flood);
    expect(parsed.hasPets, isFalse);
  });
}
