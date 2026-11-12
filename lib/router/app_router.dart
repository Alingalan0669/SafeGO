import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/routes.dart';
import '../screens/empty_state_screen.dart';
import '../screens/error_screen.dart';
import '../screens/evacuate_now_screen.dart';
import '../screens/evacuate_screen.dart';
import '../screens/home_screen.dart';
import '../screens/household_setup_screen.dart';
import '../screens/offline_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/pack_screen.dart';
import '../screens/prepare_screen.dart';
import '../screens/safe_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/text_preview_screen.dart';
import 'app_shell.dart';

/// App router.
///
/// The four tabs live in a `StatefulShellRoute.indexedStack` so each keeps its
/// own stack. Full-screen flows (setup, emergency mode, settings, previews)
/// are pushed on the root navigator with a slide transition.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _fadePage(state, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _slidePage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.setup,
        pageBuilder: (context, state) => _slidePage(
          state,
          HouseholdSetupScreen(
            isEditing: state.uri.queryParameters['edit'] == '1',
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.prepare,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: PrepareScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.pack,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: PackScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.evacuate,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: EvacuateScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.evacuateNow,
        pageBuilder: (context, state) =>
            _fadePage(state, const EvacuateNowScreen()),
      ),
      GoRoute(
        path: AppRoutes.safe,
        pageBuilder: (context, state) => _fadePage(state, const SafeScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) =>
            _slidePage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.textPreview,
        pageBuilder: (context, state) =>
            _slidePage(state, const TextPreviewScreen()),
      ),
      GoRoute(
        path: AppRoutes.offline,
        pageBuilder: (context, state) =>
            _slidePage(state, const OfflineScreen()),
      ),
      GoRoute(
        path: AppRoutes.error,
        pageBuilder: (context, state) => _slidePage(state, const ErrorScreen()),
      ),
      GoRoute(
        path: AppRoutes.empty,
        pageBuilder: (context, state) =>
            _slidePage(state, const EmptyStateScreen()),
      ),
    ],
  );

  static CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = animation.drive(
          Tween(begin: const Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
        );
        return SlideTransition(position: curved, child: child);
      },
    );
  }

  static CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 240),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
