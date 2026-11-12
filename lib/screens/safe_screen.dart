import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_utils.dart';
import '../providers/household_provider.dart';
import '../widgets/safe_button.dart';

/// Confirmation screen after the user reaches safety.
class SafeScreen extends StatelessWidget {
  const SafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final household = context.watch<HouseholdProvider>();
    final profile = household.profile ?? household.draft;

    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.close),
                color: AppColors.white,
                tooltip: 'Close and return Home',
                iconSize: 28,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 108,
                      height: 108,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 64,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'You are safe.',
                      textAlign: TextAlign.center,
                      style: AppTypography.h1.copyWith(
                        fontSize: 36,
                        height: 42 / 36,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'You reached safety. Take a breath — then let your family know where you are.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.groups_outlined,
                                color: AppColors.white,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  profile.displayName,
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            '${peopleLabel(profile.memberCount)} in your household. '
                            'This screen does not send alerts automatically.',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SafeButton(
                            label: 'Call a family contact',
                            icon: Icons.call,
                            variant: SafeButtonVariant.onDark,
                            onPressed: () => context.go(AppRoutes.evacuate),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SafeButton(
                      label: 'Back to Home',
                      icon: Icons.home_outlined,
                      variant: SafeButtonVariant.secondary,
                      onPressed: () => context.go(AppRoutes.home),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your checklist and household stay saved on this phone.',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
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
