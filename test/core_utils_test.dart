import 'package:flutter_test/flutter_test.dart';
import 'package:safego/core/utils/app_utils.dart';

void main() {
  group('greetingFor', () {
    test('changes across the day', () {
      expect(greetingFor(DateTime(2026, 1, 1, 7)), 'Good morning');
      expect(greetingFor(DateTime(2026, 1, 1, 12)), 'Good afternoon');
      expect(greetingFor(DateTime(2026, 1, 1, 18)), 'Good evening');
      expect(greetingFor(DateTime(2026, 1, 1, 23)), 'Good evening');
    });
  });

  group('percentLabel', () {
    test('handles normal and empty lists', () {
      expect(percentLabel(3, 15), '20%');
      expect(percentLabel(0, 0), '0%');
      expect(percentLabel(5, 5), '100%');
    });
  });

  group('sanitisePhoneNumber', () {
    test('keeps a leading plus and strips separators', () {
      expect(sanitisePhoneNumber('+63 917 000 0001'), '+639170000001');
      expect(sanitisePhoneNumber('911'), '911');
      expect(sanitisePhoneNumber('  '), '');
    });
  });

  group('distanceLabel', () {
    test('uses metres below one kilometre', () {
      expect(distanceLabel(1.2), '1.2 km away');
      expect(distanceLabel(0.75), '750 m away');
      expect(distanceLabel(0), 'Distance unavailable');
    });
  });

  test('bulletJoin separates values', () {
    expect(bulletJoin(['Children', 'Flood']), 'Children • Flood');
  });

  test('peopleLabel is singular only for one', () {
    expect(peopleLabel(1), '1 person');
    expect(peopleLabel(5), '5 people');
  });
}
