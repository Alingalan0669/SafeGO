import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Small label used to mark generated/personalised rows or demo data.
class TagPill extends StatelessWidget {
  const TagPill({
    super.key,
    required this.label,
    this.foreground = AppColors.blueDark,
    this.background = AppColors.blueSoft,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.checkbox),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: foreground,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
