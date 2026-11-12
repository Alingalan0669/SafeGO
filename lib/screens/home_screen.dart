import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_utils.dart';
import '../models/checklist_item.dart';
import '../models/evacuation_center.dart';
import '../models/household_profile.dart';
import '../providers/checklist_provider.dart';
import '../providers/evacuation_provider.dart';
import '../providers/household_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/readiness_ring.dart';
import '../widgets/route_preview.dart';
import '../widgets/safe_button.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';

/// Main dashboard: readiness, next step, quick counts and the nearest center.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final household = context.watch<HouseholdProvider>();
    final checklist = context.watch<ChecklistProvider>();
    final evacuation = context.watch<EvacuationProvider>();

    final profile = household.profile ?? household.draft;
    final center = evacuation.primaryCenter;

    return SafeArea(
      bottom: false,
      child: ScreenScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeHeader(profile: profile),
            const SizedBox(height: AppSpacing.md),
            _ReadinessCard(
              percent: checklist.readinessPercent,
              label: checklist.readinessLabel,
              done: checklist.totalDone,
              total: checklist.totalItems,
            ),
            const SizedBox(height: AppSpacing.md),
            _HazardAlert(hazard: profile.hazard),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Continue preparing'),
            _NextStepCard(
              next: checklist.nextStep,
              prepareDone: checklist.prepareDone,
              prepareTotal: checklist.prepareTotal,
              packDone: checklist.packDone,
              packTotal: checklist.packTotal,
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Your evacuation center'),
            if (center != null)
              _CenterCard(center: center)
            else
              SafeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No saved center yet', style: AppTypography.subtitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Open Evacuate to see the demo evacuation plan saved on this phone.',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SafeButton(
                      label: 'Open Evacuate',
                      variant: SafeButtonVariant.soft,
                      onPressed: () => context.go(AppRoutes.evacuate),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(
                  Icons.offline_bolt_outlined,
                  size: 16,
                  color: AppColors.muted,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Text(
                    'Works offline. Last saved on this phone.',
                    style: AppTypography.caption,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.profile});

  final HouseholdProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${greetingFor(DateTime.now())},',
                style: AppTypography.bodyMuted,
              ),
              Text(
                profile.ownerName,
                style: AppTypography.h1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Let’s keep your family ready.',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        TopBarIconAction(
          icon: Icons.settings_outlined,
          label: 'Open settings',
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({
    required this.percent,
    required this.label,
    required this.done,
    required this.total,
  });

  final int percent;
  final String label;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blueDark, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(AppRadii.hero),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Readiness Score',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  label,
                  style: AppTypography.h2.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$done of $total steps done',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadii.progress),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Flexible(
                        child: Text(
                          'Prepare + Pack',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.white,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ReadinessRing(
            percent: percent,
            size: 108,
            strokeWidth: 10,
            foreground: AppColors.white,
            background: AppColors.white.withValues(alpha: 0.22),
            textColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}

class _HazardAlert extends StatelessWidget {
  const _HazardAlert({required this.hazard});

  final HazardType hazard;

  @override
  Widget build(BuildContext context) {
    final (title, message) = switch (hazard) {
      HazardType.flood => (
          'Flood watch • Demo alert',
          'Heavy rain is expected this afternoon. Avoid walking through floodwater.',
        ),
      HazardType.typhoon => (
          'Typhoon watch • Demo alert',
          'Secure loose items and charge your phone while the power is on.',
        ),
      HazardType.quake => (
          'Quake reminder • Demo alert',
          'Check that heavy furniture is secured. Agree where your family will meet.',
        ),
    };

    return AlertBanner(
      title: title,
      message: message,
      tone: AlertTone.warning,
      actionLabel: 'View evacuation plan',
      onAction: () => context.go(AppRoutes.evacuate),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({
    required this.next,
    required this.prepareDone,
    required this.prepareTotal,
    required this.packDone,
    required this.packTotal,
  });

  final ChecklistItem? next;
  final int prepareDone;
  final int prepareTotal;
  final int packDone;
  final int packTotal;

  @override
  Widget build(BuildContext context) {
    if (next == null) {
      return SafeCard(
        color: AppColors.greenSoft,
        borderColor: AppColors.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified, color: AppColors.green),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'You’re fully prepared',
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Keep your go-bag fresh and review your plan every few months.',
              style: AppTypography.caption.copyWith(color: AppColors.green),
            ),
            const SizedBox(height: AppSpacing.sm),
            SafeButton(
              label: 'Review checklists',
              variant: SafeButtonVariant.soft,
              onPressed: () => context.go(AppRoutes.prepare),
            ),
          ],
        ),
      );
    }

    final isPack = next!.id.startsWith('pack.');
    final destination = isPack ? AppRoutes.pack : AppRoutes.prepare;

    return Column(
      children: [
        SafeCard(
          onTap: () => context.go(destination),
          semanticLabel: 'Next step: ${next!.title}',
          child: Row(
            children: [
              _CategoryIcon(category: next!.category),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPack ? 'Next in your go-bag' : 'Next step',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      next!.title,
                      style: AppTypography.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      next!.detail,
                      style: AppTypography.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickStat(
                label: 'Prepare',
                value: '$prepareDone/$prepareTotal',
                icon: Icons.checklist,
                onTap: () => context.go(AppRoutes.prepare),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickStat(
                label: 'Go-bag',
                value: '$packDone/$packTotal',
                icon: Icons.backpack,
                onTap: () => context.go(AppRoutes.pack),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      semanticLabel: '$label $value',
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.blueSoft,
              borderRadius: BorderRadius.circular(AppRadii.iconTile),
            ),
            child: Icon(icon, size: 20, color: AppColors.blue),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.caption),
                Text(
                  value,
                  style: AppTypography.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterCard extends StatelessWidget {
  const _CenterCard({required this.center});

  final EvacuationCenter center;

  @override
  Widget build(BuildContext context) {
    return SafeCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: RoutePreview(
              height: 116,
              distanceLabel: distanceLabel(center.distanceKm),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        center.name,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  center.address,
                  style: AppTypography.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                SafeButton(
                  label: 'See evacuation plan',
                  icon: Icons.logout,
                  variant: SafeButtonVariant.soft,
                  onPressed: () => context.go(AppRoutes.evacuate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final ChecklistCategory category;

  @override
  Widget build(BuildContext context) {
    final icon = switch (category) {
      ChecklistCategory.water => Icons.water_drop,
      ChecklistCategory.food => Icons.restaurant,
      ChecklistCategory.medical => Icons.medical_services,
      ChecklistCategory.documents => Icons.description,
      ChecklistCategory.tools => Icons.handyman,
      ChecklistCategory.clothing => Icons.checkroom,
      ChecklistCategory.children => Icons.child_care,
      ChecklistCategory.seniors => Icons.elderly,
      ChecklistCategory.disability => Icons.accessible,
      ChecklistCategory.pets => Icons.pets,
      ChecklistCategory.contacts => Icons.contacts,
    };

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.blueSoft,
        borderRadius: BorderRadius.circular(AppRadii.iconTile),
      ),
      child: Icon(icon, color: AppColors.blue, size: 22),
    );
  }
}
