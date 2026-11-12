import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../models/household_profile.dart';
import '../providers/checklist_provider.dart';
import '../providers/household_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/checklist_tile.dart';
import '../widgets/progress_bar.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';

/// Four-step preparedness checklist.
class PrepareScreen extends StatelessWidget {
  const PrepareScreen({super.key});

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
    final hazard = (household.profile ?? household.draft).hazard;

    final allDone =
        checklist.prepareTotal > 0 && checklist.prepareDone == checklist.prepareTotal;

    return SafeArea(
      bottom: false,
      child: ScreenScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prepare', style: AppTypography.h1),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Four small steps that make a big difference.',
              style: AppTypography.bodyMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            _PrepareProgressCard(
              done: checklist.prepareDone,
              total: checklist.prepareTotal,
              percent: checklist.prepareTotal == 0
                  ? 0
                  : (checklist.prepareDone / checklist.prepareTotal * 100)
                      .round(),
            ),
            const SizedBox(height: AppSpacing.md),
            if (allDone)
              const AlertBanner(
                title: 'All four steps complete',
                message:
                    'Your family plan is ready. Review it every few months and after moving home.',
                tone: AlertTone.success,
                icon: Icons.verified_outlined,
              ),
            if (allDone) const SizedBox(height: AppSpacing.md),
            const SectionHeader(title: 'Your preparedness steps'),
            if (checklist.prepareItems.isEmpty)
              SafeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No steps yet', style: AppTypography.subtitle),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Your checklist will appear here once your household is set up.',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              )
            else
              for (final item in checklist.prepareItems) ...[
                ChecklistTile(
                  item: item,
                  onToggle: () => _toggle(context, item.id),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            const SizedBox(height: AppSpacing.sm),
            _TipCard(hazard: hazard),
            const SizedBox(height: AppSpacing.md),
            SafeCard(
              onTap: () => context.go(AppRoutes.pack),
              semanticLabel: 'Open your go-bag checklist',
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.blueSoft,
                      borderRadius: BorderRadius.circular(AppRadii.iconTile),
                    ),
                    child: const Icon(
                      Icons.backpack_outlined,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next: pack your go-bag',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${checklist.packDone} of ${checklist.packTotal} items packed',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.muted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrepareProgressCard extends StatelessWidget {
  const _PrepareProgressCard({
    required this.done,
    required this.total,
    required this.percent,
  });

  final int done;
  final int total;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return SafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress', style: AppTypography.caption),
                    const SizedBox(height: 2),
                    Text('$done of $total steps complete',
                        style: AppTypography.subtitle),
                  ],
                ),
              ),
              Text(
                '$percent%',
                style: AppTypography.h2.copyWith(color: AppColors.blue),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ProgressBar(
            value: total == 0 ? 0 : done / total,
            semanticLabel: 'Prepare checklist progress',
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.hazard});

  final HazardType hazard;

  @override
  Widget build(BuildContext context) {
    return SafeCard(
      color: AppColors.amberSoft,
      borderColor: AppColors.amber.withValues(alpha: 0.35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.amber),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip for ${hazard.label.toLowerCase()}',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.amber,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hazard.packNote,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
