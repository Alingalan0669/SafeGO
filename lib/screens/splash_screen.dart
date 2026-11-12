import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../providers/household_provider.dart';
import '../widgets/app_logo.dart';

/// Branded launch screen.
///
/// It waits for the local profile to load (and a short minimum beat), then
/// sends first-run users to onboarding and returning users straight Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minDelayPassed = false;
  bool _navigationScheduled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _minDelayPassed = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleNavigation(HouseholdProvider household) {
    if (_navigationScheduled) return;
    _navigationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go(
        household.hasProfile ? AppRoutes.home : AppRoutes.onboarding,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final household = context.watch<HouseholdProvider>();
    if (_minDelayPassed && !household.isLoading) {
      _scheduleNavigation(household);
    }

    return Scaffold(
      backgroundColor: AppColors.blueDark,
      body: Stack(
        children: [
          // Decorative rings keep the splash branded without any image asset.
          Positioned(
            top: -90,
            right: -60,
            child: _Circle(
              size: 260,
              color: AppColors.blue.withValues(alpha: 0.45),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: _Circle(
              size: 320,
              color: AppColors.blue.withValues(alpha: 0.35),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const Spacer(),
                  const AppLogo(
                    size: 104,
                    background: AppColors.white,
                    foreground: AppColors.blue,
                    radius: AppRadii.mark,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: AppTypography.h1.copyWith(
                      fontSize: 40,
                      height: 1.1,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppConstants.tagline,
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.offline_bolt_outlined,
                        size: 16,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Flexible(
                        child: Text(
                          AppConstants.offlineNotice,
                          textAlign: TextAlign.center,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
