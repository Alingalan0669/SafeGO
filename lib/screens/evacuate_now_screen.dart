import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_utils.dart';
import '../providers/evacuation_provider.dart';
import '../widgets/evacuation_step.dart';
import '../widgets/route_preview.dart';
import '../widgets/safe_button.dart';

/// High-contrast emergency mode.
///
/// White on near-black, very large type and only the two actions that matter:
/// call for help or confirm you are safe.
class EvacuateNowScreen extends StatelessWidget {
  const EvacuateNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final evacuation = context.watch<EvacuationProvider>();
    final center = evacuation.primaryCenter;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.white,
                    tooltip: 'Close emergency mode',
                    iconSize: 28,
                  ),
                  const Expanded(
                    child: Text(
                      'EVACUATE NOW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(AppRadii.progress),
                      ),
                      child: Text(
                        'Emergency mode • Offline',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Leave now.\nStay calm.',
                      style: AppTypography.h1.copyWith(
                        fontSize: 40,
                        height: 44 / 40,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Follow these steps. Tap “I’m safe” when you reach the center.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SafeButton(
                      label: 'Call 911 now',
                      icon: Icons.call,
                      variant: SafeButtonVariant.danger,
                      onPressed: () async {
                        final contact = evacuation.emergencyContact;
                        if (contact == null) return;
                        final error = await evacuation.call(contact);
                        if (!context.mounted || error == null) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Steps',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const EvacuationStep(
                      number: 1,
                      title: 'Leave immediately',
                      detail:
                          'Do not wait for the water to rise. Take the safest route, not the shortest.',
                      onDark: true,
                    ),
                    const EvacuationStep(
                      number: 2,
                      title: 'Bring your go-bag',
                      detail:
                          'Phone, medicines, IDs, water and chargers. Hold children’s hands.',
                      onDark: true,
                    ),
                    const EvacuationStep(
                      number: 3,
                      title: 'Switch off utilities',
                      detail:
                          'Turn off the main power only if it is safe to reach. Lock the door.',
                      onDark: true,
                    ),
                    EvacuationStep(
                      number: 4,
                      title: center == null
                          ? 'Go to your evacuation center'
                          : 'Go to ${center.name}',
                      detail: center == null
                          ? 'Open the Evacuate tab to see your saved center.'
                          : '${center.address} • ${distanceLabel(center.distanceKm)}',
                      isLast: true,
                      onDark: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (center != null) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadii.card),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Your destination',
                              style: AppTypography.caption,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              center.name,
                              style: AppTypography.subtitle,
                            ),
                            const SizedBox(height: 2),
                            Text(center.address, style: AppTypography.caption),
                            const SizedBox(height: AppSpacing.xs),
                            RoutePreview(
                              height: 110,
                              distanceLabel: distanceLabel(center.distanceKm),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    SafeButton(
                      label: 'I’m safe',
                      icon: Icons.check_circle_outline,
                      variant: SafeButtonVariant.success,
                      onPressed: () => context.push(AppRoutes.safe),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Text(
                        'Saved on this phone • No internet needed',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
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
