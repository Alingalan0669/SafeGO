import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Visual tone of an [AlertBanner].
enum AlertTone { info, success, warning, danger }

/// Inline advisory banner.
///
/// Soft semantic backgrounds keep WCAG AA contrast for the dark text while
/// still reading clearly as an alert.
class AlertBanner extends StatelessWidget {
  const AlertBanner({
    super.key,
    required this.title,
    required this.message,
    this.tone = AlertTone.info,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final AlertTone tone;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, defaultIcon) = switch (tone) {
      AlertTone.info => (AppColors.blueSoft, AppColors.blueDark, Icons.info_outline),
      AlertTone.success => (
          AppColors.greenSoft,
          AppColors.green,
          Icons.check_circle_outline,
        ),
      AlertTone.warning => (
          AppColors.amberSoft,
          AppColors.amber,
          Icons.warning_amber_rounded,
        ),
      AlertTone.danger => (
          AppColors.redSoft,
          AppColors.red,
          Icons.error_outline,
        ),
    };

    return Semantics(
      container: true,
      label: '$title. $message',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: foreground.withValues(alpha: 0.25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? defaultIcon, color: foreground, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: AppTypography.caption.copyWith(color: foreground),
                  ),
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: foreground,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(48, 40),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        actionLabel!,
                        style: AppTypography.caption.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
