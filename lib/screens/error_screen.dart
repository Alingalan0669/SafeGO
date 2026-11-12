import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/safe_button.dart';
import '../widgets/screen_scroll.dart';

/// Friendly retry state for the (simulated) alert refresh.
///
/// SafeGo has no network call in this MVP, so retry always falls back to the
/// saved data instead of pretending a live alert arrived.
class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _retrying = false;

  Future<void> _retry() async {
    if (_retrying) return;
    setState(() => _retrying = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _retrying = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Still offline. Your saved plan is up to date and ready to use.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Alert update',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ScreenScroll(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.redSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_off_outlined,
                        size: 44,
                        color: AppColors.red,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Couldn’t get\nthe latest alert.',
                      textAlign: TextAlign.center,
                      style: AppTypography.h1,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'You may have no signal. This is normal during a storm. '
                      'Your household, checklist and evacuation plan are still saved on this phone.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMuted,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(color: AppColors.green),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.verified, color: AppColors.green),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saved plan is ready',
                                  style: AppTypography.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.green,
                                  ),
                                ),
                                Text(
                                  'You can still prepare, pack and evacuate without a connection.',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SafeButton(
                      label: _retrying ? 'Trying again…' : 'Try again',
                      icon: Icons.refresh,
                      onPressed: _retrying ? null : _retry,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SafeButton(
                      label: 'Use saved data',
                      icon: Icons.home_outlined,
                      variant: SafeButtonVariant.secondary,
                      onPressed: () => context.go(AppRoutes.home),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
