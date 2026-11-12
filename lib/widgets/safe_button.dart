import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';

/// Button styles used across SafeGo.
enum SafeButtonVariant {
  /// Filled blue: the single main action on a screen.
  primary,

  /// White with a blue outline: secondary actions.
  secondary,

  /// Soft blue fill: low-emphasis actions on white cards.
  soft,

  /// Green fill: "I am safe" confirmation.
  success,

  /// Red fill: emergency / destructive actions.
  danger,

  /// White fill for dark high-contrast screens.
  onDark,
}

/// Accessible primary button.
///
/// Always at least 56dp tall (above the 48dp requirement), with a 16dp radius
/// from the design system and an optional leading icon.
class SafeButton extends StatelessWidget {
  const SafeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = SafeButtonVariant.primary,
    this.expand = true,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SafeButtonVariant variant;
  final bool expand;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    final (background, foreground, border) = switch (variant) {
      SafeButtonVariant.primary => (AppColors.blue, AppColors.white, null),
      SafeButtonVariant.secondary => (
          AppColors.white,
          AppColors.blue,
          AppColors.blue,
        ),
      SafeButtonVariant.soft => (AppColors.blueSoft, AppColors.blueDark, null),
      SafeButtonVariant.success => (AppColors.green, AppColors.white, null),
      SafeButtonVariant.danger => (AppColors.red, AppColors.white, null),
      SafeButtonVariant.onDark => (AppColors.white, AppColors.blueDark, null),
    };

    final effectiveBackground = enabled ? background : AppColors.soft;
    final effectiveForeground = enabled ? foreground : AppColors.muted;

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: Material(
        color: effectiveBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: border != null && enabled
              ? BorderSide(color: border, width: 1.5)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 56,
            constraints: const BoxConstraints(
              minWidth: AppConstants.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            width: expand ? double.infinity : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 22, color: effectiveForeground),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.button.copyWith(
                      color: effectiveForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
