import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:safego/core/theme/app_theme.dart';
import 'package:safego/models/household_profile.dart';
import 'package:safego/providers/checklist_provider.dart';
import 'package:safego/providers/evacuation_provider.dart';
import 'package:safego/providers/household_provider.dart';
import 'package:safego/providers/settings_provider.dart';
import 'package:safego/screens/empty_state_screen.dart';
import 'package:safego/screens/error_screen.dart';
import 'package:safego/screens/evacuate_now_screen.dart';
import 'package:safego/screens/evacuate_screen.dart';
import 'package:safego/screens/offline_screen.dart';
import 'package:safego/screens/safe_screen.dart';
import 'package:safego/screens/settings_screen.dart';
import 'package:safego/screens/text_preview_screen.dart';
import 'package:safego/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Renders the screens that are not covered by the app-flow test, with the
/// "Larger text" scale applied, and fails on any layout overflow.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final screens = <String, Widget Function()>{
    'Evacuate': () => const EvacuateScreen(),
    'Evacuate Now': () => const EvacuateNowScreen(),
    'You are safe': () => const SafeScreen(),
    'Settings': () => const SettingsScreen(),
    'Large text preview': () => const TextPreviewScreen(),
    'Offline': () => const OfflineScreen(),
    'Error': () => const ErrorScreen(),
    'Empty': () => const EmptyStateScreen(),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key} renders without overflow at 115% text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.create();

      final household = HouseholdProvider(storage);
      await household.save(HouseholdProfile.initial());
      final checklist = ChecklistProvider(storage)
        ..syncProfile(household.profile);
      final settings = SettingsProvider(storage);
      final evacuation = EvacuationProvider();
      // Asset loading needs a real async zone inside a widget test.
      await tester.runAsync(evacuation.load);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<HouseholdProvider>.value(value: household),
            ChangeNotifierProvider<ChecklistProvider>.value(value: checklist),
            ChangeNotifierProvider<SettingsProvider>.value(value: settings),
            ChangeNotifierProvider<EvacuationProvider>.value(value: evacuation),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: const TextScaler.linear(1.15),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: entry.value(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
