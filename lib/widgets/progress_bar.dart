import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Thin progress bar used by Prepare, Pack and the onboarding steps.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color = AppColors.blue,
    this.background = AppColors.soft,
    this.semanticLabel,
  });

  /// 0.0 - 1.0.
  final double value;
  final double height;
  final Color color;
  final Color background;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);

    return Semantics(
      value: '${(safeValue * 100).round()} percent',
      label: semanticLabel ?? 'Progress',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.progress),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: background),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      width: constraints.maxWidth * safeValue,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(AppRadii.progress),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
