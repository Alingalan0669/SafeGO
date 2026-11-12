import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../widgets/alert_banner.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/safe_button.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';

/// Explains clearly that SafeGo needs no connection.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Offline mode',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ScreenScroll(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.greenSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_off_outlined,
                          size: 44,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Text(
                        'No internet.\nStill prepared.',
                        textAlign: TextAlign.center,
                        style: AppTypography.h1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: Text(
                        'SafeGo is offline-first. Everything you enter is saved on this phone and nothing is sent to a server.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SafeCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available without signal',
                            style: AppTypography.subtitle,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          const _OfflineRow(
                            label: 'Household profile',
                            detail: 'Your people, needs and main hazard.',
                          ),
                          const _OfflineRow(
                            label: 'Prepare checklist',
                            detail: 'Four preparedness steps and their progress.',
                          ),
                          const _OfflineRow(
                            label: 'Personalised go-bag',
                            detail: 'Rebuilt when your household changes.',
                          ),
                          const _OfflineRow(
                            label: 'Evacuation plan',
                            detail: 'Demo centers, contacts and route preview.',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const AlertBanner(
                      title: 'Honest limitation',
                      message:
                          'SafeGo does not download live weather or live evacuation updates. Confirm official advisories with your barangay.',
                      tone: AlertTone.warning,
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SafeButton(
                      label: 'Back to Home',
                      icon: Icons.home_outlined,
                      onPressed: () => context.go(AppRoutes.home),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: Text(
                        'Saved on this phone • Works offline',
                        style: AppTypography.caption,
                      ),
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

class _OfflineRow extends StatelessWidget {
  const _OfflineRow({
    required this.label,
    required this.detail,
    this.isLast = false,
  });

  final String label;
  final String detail;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(detail, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
