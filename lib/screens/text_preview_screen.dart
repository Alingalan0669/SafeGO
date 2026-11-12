import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../providers/household_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/checklist_tile.dart';
import '../widgets/readiness_ring.dart';
import '../widgets/safe_button.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/toggle_row.dart';
import '../models/checklist_item.dart';

/// Demonstrates the accessibility "Larger text" setting live.
class TextPreviewScreen extends StatefulWidget {
  const TextPreviewScreen({super.key});

  @override
  State<TextPreviewScreen> createState() => _TextPreviewScreenState();
}

class _TextPreviewScreenState extends State<TextPreviewScreen> {
  bool _sampleDone = true;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final household = context.watch<HouseholdProvider>();
    final profile = household.profile ?? household.draft;

    final sampleItem = ChecklistItem(
      id: 'preview.contact',
      title: 'Emergency contacts',
      detail: 'Save family and local contacts.',
      isDone: _sampleDone,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Large text preview',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ScreenScroll(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Readable when it matters.',
                      style: AppTypography.h1,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Turn larger text on to see this preview update immediately. '
                      'Emergency steps use the same setting.',
                      style: AppTypography.bodyMuted,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SafeCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: ToggleRow(
                        title: 'Larger text',
                        subtitle: settings.largeText
                            ? 'Currently 115% of the base size.'
                            : 'Currently the standard size.',
                        value: settings.largeText,
                        icon: Icons.text_fields,
                        onChanged: settings.setLargeText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Sample dashboard'),
                    SafeCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Readiness Score',
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Almost ready',
                                  style: AppTypography.h2,
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  profile.summaryLine,
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const ReadinessRing(percent: 82, size: 88),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ChecklistTile(
                      item: sampleItem,
                      onToggle: () =>
                          setState(() => _sampleDone = !_sampleDone),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const AlertBanner(
                      title: 'Flood watch • Demo alert',
                      message:
                          'Heavy rain is expected. Avoid walking through floodwater.',
                      tone: AlertTone.warning,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SafeButton(
                      label: 'Back to settings',
                      icon: Icons.arrow_back,
                      variant: SafeButtonVariant.secondary,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'SafeGo also respects your phone’s accessibility settings.',
                      style: AppTypography.caption,
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
