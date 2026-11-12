import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safego/main.dart';
import 'package:safego/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first run reaches Home and switches tabs', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.create();

    await tester.pumpWidget(SafeGoApp(storage: storage));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Onboarding page 1.
    expect(
      find.text('A little preparation.\nA safer family.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Tell us about\nyour household.'), findsOneWidget);

    // Save the default household (Maria, 5 people, children, flood).
    await tester.tap(find.text('Build my plan'));
    await tester.pumpAndSettle();

    // Home dashboard.
    expect(find.text('Readiness Score'), findsOneWidget);
    expect(find.text('Maria'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Evacuate'), findsOneWidget);

    await tester.tap(find.text('Prepare').last);
    await tester.pumpAndSettle();
    expect(find.text('Your preparedness steps'), findsOneWidget);

    await tester.tap(find.text('Pack').last);
    await tester.pumpAndSettle();
    expect(find.text('Go-bag'), findsOneWidget);
    expect(find.textContaining('Packed 0 of 15'), findsWidgets);
  });
}
