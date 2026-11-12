import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../models/household_profile.dart';
import '../providers/checklist_provider.dart';
import '../providers/household_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/safe_button.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/tag_pill.dart';
import '../widgets/toggle_row.dart';

/// Profile, accessibility, offline information and data controls.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _clearData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear saved data?'),
        content: const Text(
          'Your household, checklist ticks and preferences will be removed from this phone. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep my data'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Clear everything'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final household = context.read<HouseholdProvider>();
    final checklist = context.read<ChecklistProvider>();
    final settings = context.read<SettingsProvider>();

    await checklist.clearAll();
    final cleared = await household.clearAllData();
    await settings.reset();

    if (!context.mounted) return;
    if (!cleared) {
      final error = household.takeError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Saved data could not be cleared.')),
      );
      return;
    }

    context.go(AppRoutes.onboarding);
  }

  Future<void> _selectLanguage(
    BuildContext context,
    AppLanguage language,
  ) async {
    final settings = context.read<SettingsProvider>();
    await settings.setLanguage(language);
    if (!context.mounted) return;

    if (language == AppLanguage.filipino) {
      // Honest scope note: the preference is stored, but the translated copy
      // is not part of this MVP build yet.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Filipino is saved as your preference. Translated copy is coming in the next update.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final household = context.watch<HouseholdProvider>();
    final settings = context.watch<SettingsProvider>();
    final profile = household.profile ?? household.draft;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Profile & settings',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ScreenScroll(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileCard(
                      profile: profile,
                      onTap: () => context.push(AppRoutes.editHousehold),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Accessibility'),
                    SafeCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        children: [
                          ToggleRow(
                            title: 'Larger text',
                            subtitle:
                                'Increase text size across SafeGo, including emergency steps.',
                            value: settings.largeText,
                            icon: Icons.text_fields,
                            showDivider: true,
                            onChanged: settings.setLargeText,
                          ),
                          _SettingsRow(
                            icon: Icons.visibility_outlined,
                            title: 'Preview large text',
                            subtitle: 'See how Home looks with bigger type.',
                            onTap: () => context.push(AppRoutes.textPreview),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Language'),
                    SafeCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App language',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'English is fully available. Filipino copy is next.',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<AppLanguage>(
                              showSelectedIcon: false,
                              segments: [
                                for (final language in AppLanguage.values)
                                  ButtonSegment<AppLanguage>(
                                    value: language,
                                    label: Text(language.label),
                                  ),
                              ],
                              selected: {settings.language},
                              onSelectionChanged: (selection) =>
                                  _selectLanguage(context, selection.first),
                              style: const ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(
                                  Size(0, 48),
                                ),
                                textStyle: WidgetStatePropertyAll(
                                  AppTypography.caption,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Offline & data'),
                    SafeCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        children: [
                          _SettingsRow(
                            icon: Icons.offline_bolt_outlined,
                            title: 'Offline mode',
                            subtitle:
                                'How SafeGo works with no signal or data.',
                            onTap: () => context.push(AppRoutes.offline),
                          ),
                          _SettingsRow(
                            icon: Icons.phone_android,
                            title: 'Storage status',
                            subtitle: household.isPersistent
                                ? 'Saved on this phone • Works offline'
                                : 'Temporary session only • storage unavailable',
                            onTap: null,
                          ),
                          _SettingsRow(
                            icon: Icons.refresh,
                            title: 'Preview retry state',
                            subtitle: 'See the friendly error screen.',
                            onTap: () => context.push(AppRoutes.error),
                          ),
                          _SettingsRow(
                            icon: Icons.inbox_outlined,
                            title: 'Preview empty state',
                            subtitle: 'See how SafeGo explains an empty list.',
                            onTap: () => context.push(AppRoutes.empty),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'About'),
                    SafeCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppConstants.appName,
                                  style: AppTypography.subtitle,
                                ),
                              ),
                              const TagPill(label: 'v1.0.0'),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Prepare. Pack. Evacuate. A preparedness companion for Philippine households.',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          const AlertBanner(
                            title: 'Demo data only',
                            message:
                                'Evacuation centers and phone numbers are samples. Confirm them with your barangay.',
                            tone: AlertTone.warning,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SafeButton(
                      label: 'Clear saved data',
                      icon: Icons.delete_outline,
                      variant: SafeButtonVariant.secondary,
                      onPressed: () => _clearData(context),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: Text(
                        'SafeGo never asks for an account and sends nothing to a server.',
                        textAlign: TextAlign.center,
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onTap});

  final HouseholdProfile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = profile.ownerName.trim().isEmpty
        ? 'S'
        : profile.ownerName.trim().substring(0, 1).toUpperCase();

    return SafeCard(
      onTap: onTap,
      semanticLabel: 'Edit ${profile.displayName}',
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.blueSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: AppTypography.h2.copyWith(color: AppColors.blueDark),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName,
                  style: AppTypography.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  profile.summaryLine,
                  style: AppTypography.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Tap to edit your household',
                  style: AppTypography.caption.copyWith(color: AppColors.blue),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.soft,
              borderRadius: BorderRadius.circular(AppRadii.iconTile),
            ),
            child: Icon(icon, size: 20, color: AppColors.ink),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right, color: AppColors.muted)
          else
            const Icon(Icons.check_circle_outline, color: AppColors.green),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}
