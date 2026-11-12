import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/checklist_provider.dart';
import 'providers/evacuation_provider.dart';
import 'providers/household_provider.dart';
import 'providers/settings_provider.dart';
import 'router/app_router.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open local storage before the first frame so the correct screen is shown
  // immediately (onboarding vs. Home) and settings apply from the start.
  final storage = await LocalStorageService.create();

  runApp(SafeGoApp(storage: storage));
}

class SafeGoApp extends StatelessWidget {
  const SafeGoApp({super.key, required this.storage});

  final LocalStorageService storage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: storage),
        ChangeNotifierProvider(
          create: (_) => HouseholdProvider(storage),
        ),
        // The proxy keeps the go-bag in sync with the household profile.
        ChangeNotifierProxyProvider<HouseholdProvider, ChecklistProvider>(
          create: (_) => ChecklistProvider(storage),
          update: (_, household, checklist) {
            final provider = checklist!;
            provider.syncProfile(household.profile);
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storage),
        ),
        ChangeNotifierProvider(
          create: (_) => EvacuationProvider()..load(),
        ),
      ],
      child: const _SafeGoView(),
    );
  }
}

class _SafeGoView extends StatefulWidget {
  const _SafeGoView();

  @override
  State<_SafeGoView> createState() => _SafeGoViewState();
}

class _SafeGoViewState extends State<_SafeGoView> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp.router(
      title: 'SafeGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final systemScale = media.textScaler.scale(1);
        // "Larger text" raises the floor to 115% while still respecting a
        // phone that is already set larger than that.
        final scale = settings.largeText && systemScale < 1.15
            ? 1.15
            : systemScale;

        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
