import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Circular readiness gauge shown on Home and Prepare.
class ReadinessRing extends StatelessWidget {
  const ReadinessRing({
    super.key,
    required this.percent,
    this.size = 104,
    this.strokeWidth = 10,
    this.foreground = AppColors.blue,
    this.background = AppColors.blueSoft,
    this.textColor = AppColors.ink,
    this.caption = 'ready',
  });

  final int percent;
  final double size;
  final double strokeWidth;
  final Color foreground;
  final Color background;
  final Color textColor;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final safePercent = percent.clamp(0, 100);

    return Semantics(
      label: 'Readiness score $safePercent percent',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: safePercent / 100),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  backgroundColor: background,
                  valueColor: AlwaysStoppedAnimation<Color>(foreground),
                );
              },
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$safePercent%',
                    maxLines: 1,
                    softWrap: false,
                    style: AppTypography.number.copyWith(color: textColor),
                  ),
                  Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
