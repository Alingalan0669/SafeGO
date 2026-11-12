import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_utils.dart';
import '../models/emergency_contact.dart';
import '../models/evacuation_center.dart';
import '../providers/evacuation_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/contact_row.dart';
import '../widgets/route_preview.dart';
import '../widgets/safe_button.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/tag_pill.dart';

/// Evacuation plan, center details and one-tap emergency calls.
class EvacuateScreen extends StatelessWidget {
  const EvacuateScreen({super.key});

  Future<void> _call(BuildContext context, EmergencyContact contact) async {
    final provider = context.read<EvacuationProvider>();
    final error = await provider.call(contact);
    if (!context.mounted || error == null) return;

    // Emulators, web and desktop builds may not have a dialer. Explain that
    // clearly and still show the number so it can be dialled manually.
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Call not available'),
        content: Text('$error\n\n${contact.name}: ${contact.phone}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final evacuation = context.watch<EvacuationProvider>();
    final emergency = evacuation.emergencyContact;

    return SafeArea(
      bottom: false,
      child: evacuation.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ScreenScroll(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Evacuate', style: AppTypography.h1),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Your safe way out, saved on this phone.',
                              style: AppTypography.bodyMuted,
                            ),
                          ],
                        ),
                      ),
                      const TagPill(
                        label: 'Offline ready',
                        foreground: AppColors.green,
                        background: AppColors.greenSoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AlertBanner(
                    title:
                        evacuation.usedFallback ? 'Saved backup data' : 'Demo data',
                    message: AppConstants.demoDataNotice,
                    tone: AlertTone.warning,
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SafeButton(
                    label: 'Evacuate Now',
                    icon: Icons.logout,
                    variant: SafeButtonVariant.danger,
                    onPressed: () => context.push(AppRoutes.evacuateNow),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Opens large, high-contrast steps you can follow quickly.',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(title: 'Your evacuation centers'),
                  if (evacuation.centers.isEmpty)
                    SafeCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No centers saved',
                            style: AppTypography.subtitle,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            evacuation.error ??
                                'The saved evacuation data could not be opened.',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SafeButton(
                            label: 'Try again',
                            variant: SafeButtonVariant.soft,
                            onPressed: evacuation.load,
                          ),
                        ],
                      ),
                    )
                  else
                    for (var index = 0;
                        index < evacuation.centers.length;
                        index++) ...[
                      _CenterDetailCard(
                        center: evacuation.centers[index],
                        isNearest: index == 0,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  const SizedBox(height: AppSpacing.md),
                  const SectionHeader(title: 'Emergency calls'),
                  if (emergency != null) ...[
                    _EmergencyCallCard(
                      contact: emergency,
                      onCall: () => _call(context, emergency),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  for (final contact in evacuation.familyContacts) ...[
                    ContactRow(
                      contact: contact,
                      onCall: () => _call(context, contact),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  SafeCard(
                    onTap: () => context.push(AppRoutes.offline),
                    semanticLabel: 'Learn about offline mode',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.offline_bolt_outlined,
                          color: AppColors.green,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No internet. Still prepared.',
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'All of this is saved on your phone.',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.muted),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Phone numbers are sample data. Confirm them with your barangay before an emergency.',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
    );
  }
}

class _CenterDetailCard extends StatelessWidget {
  const _CenterDetailCard({required this.center, required this.isNearest});

  final EvacuationCenter center;
  final bool isNearest;

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
              height: 124,
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
                    Expanded(
                      child: Text(center.name, style: AppTypography.subtitle),
                    ),
                    if (isNearest)
                      const TagPill(
                        label: 'Nearest',
                        foreground: AppColors.green,
                        background: AppColors.greenSoft,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(center.address, style: AppTypography.caption),
                if (center.notes.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.soft,
                      borderRadius: BorderRadius.circular(AppRadii.progress),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notes,
                          size: 16,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            center.notes,
                            style: AppTypography.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCallCard extends StatelessWidget {
  const _EmergencyCallCard({required this.contact, required this.onCall});

  final EmergencyContact contact;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.redSoft,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emergency, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.phone.isEmpty ? '911' : contact.phone,
                  style: AppTypography.h2.copyWith(color: AppColors.redDark),
                ),
                Text(
                  contact.detailLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.redDark,
                  ),
                ),
              ],
            ),
          ),
          SafeButton(
            label: 'Call 911',
            icon: Icons.call,
            expand: false,
            variant: SafeButtonVariant.danger,
            onPressed: onCall,
            semanticLabel: 'Call emergency services on 911',
          ),
        ],
      ),
    );
  }
}
