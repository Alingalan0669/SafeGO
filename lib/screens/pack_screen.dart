import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_utils.dart';
import '../models/household_profile.dart';
import '../providers/checklist_provider.dart';
import '../providers/household_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/checklist_tile.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/progress_bar.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/tag_pill.dart';

/// Personalised go-bag checklist.
class PackScreen extends StatelessWidget {
  const PackScreen({super.key});

  Future<void> _toggle(BuildContext context, String id) async {
    final checklist = context.read<ChecklistProvider>();
    await checklist.toggle(id);
    if (!context.mounted) return;
    final error = checklist.takeError();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final checklist = context.watch<ChecklistProvider>();
    final household = context.watch<HouseholdProvider>();
    final profile = household.profile ?? household.draft;

    final allPacked =
        checklist.packTotal > 0 && checklist.packDone == checklist.packTotal;

    return SafeArea(
      bottom: false,
      child: checklist.packItems.isEmpty
          ? EmptyStateView(
              icon: Icons.backpack_outlined,
              title: 'Your go-bag is empty',
              message:
                  'Set up your household and SafeGo will build a go-bag around the people and pets at home.',
              actionLabel: 'Update household',
              onAction: () => context.push(AppRoutes.editHousehold),
            )
          : ScreenScroll(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Go-bag', style: AppTypography.h1),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Built for ${peopleLabel(profile.memberCount)}'
                    '${profile.hasPets ? ' and pets' : ''}.',
                    style: AppTypography.bodyMuted,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PackSummaryCard(
                    done: checklist.packDone,
                    total: checklist.packTotal,
                    profile: profile,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (allPacked)
                    AlertBanner(
                      title: 'Your go-bag is packed',
                      message:
                          'Store it somewhere dry and easy to reach. Check food, water and medicines every few months.',
                      tone: AlertTone.success,
                      icon: Icons.backpack,
                      actionLabel: 'Update household',
                      onAction: () => context.push(AppRoutes.editHousehold),
                    )
                  else
                    AlertBanner(
                      title: 'Packing for ${profile.hazard.label.toLowerCase()}',
                      message: profile.hazard.packNote,
                      tone: AlertTone.warning,
                      icon: Icons.lightbulb_outline,
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(
                    title: 'Packed ${checklist.packDone} of ${checklist.packTotal}',
                    actionLabel: 'Household',
                    onAction: () => context.push(AppRoutes.editHousehold),
                  ),
                  for (final item in checklist.packItems) ...[
                    ChecklistTile(
                      item: item,
                      onToggle: () => _toggle(context, item.id),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Based on three days of supplies for everyone at home. '
                    'Add medicines, IDs and anything your family needs.',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
    );
  }
}

class _PackSummaryCard extends StatelessWidget {
  const _PackSummaryCard({
    required this.done,
    required this.total,
    required this.profile,
  });

  final int done;
  final int total;
  final HouseholdProfile profile;

  @override
  Widget build(BuildContext context) {
    return SafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(AppRadii.iconTile),
                ),
                child: const Icon(Icons.backpack, color: AppColors.blue),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Packed $done of $total',
                      style: AppTypography.subtitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${percentLabel(done, total)} of your go-bag is ready',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              if (profile.hasChildren) const TagPill(label: 'Personalised'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ProgressBar(
            value: total == 0 ? 0 : done / total,
            color: AppColors.green,
            semanticLabel: 'Go-bag packing progress',
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xxs,
            runSpacing: AppSpacing.xxs,
            children: [
              TagPill(label: peopleLabel(profile.memberCount)),
              if (profile.hasChildren) const TagPill(label: 'Children'),
              if (profile.hasSeniors) const TagPill(label: 'Seniors'),
              if (profile.hasDisability)
                const TagPill(label: 'Disability support'),
              if (profile.hasPets) const TagPill(label: 'Pets'),
              TagPill(
                label: profile.hazard.label,
                foreground: AppColors.amber,
                background: AppColors.amberSoft,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
