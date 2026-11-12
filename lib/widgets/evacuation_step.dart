import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Numbered evacuation step with a connector line.
///
/// [onDark] swaps to the high-contrast palette used by Evacuate Now.
class EvacuationStep extends StatelessWidget {
  const EvacuationStep({
    super.key,
    required this.number,
    required this.title,
    required this.detail,
    this.isLast = false,
    this.onDark = false,
  });

  final int number;
  final String title;
  final String detail;
  final bool isLast;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final circleColor = onDark ? AppColors.white : AppColors.blue;
    final numberColor = onDark ? AppColors.redDark : AppColors.white;
    final titleColor = onDark ? AppColors.white : AppColors.ink;
    final detailColor = onDark ? AppColors.white : AppColors.muted;
    final lineColor =
        onDark ? AppColors.white.withValues(alpha: 0.35) : AppColors.border;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: AppTypography.subtitle.copyWith(
                  color: numberColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: lineColor,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: AppTypography.caption.copyWith(color: detailColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
