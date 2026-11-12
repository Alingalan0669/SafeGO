import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';

/// Minus / value / plus control for the household size.
class FamilyStepper extends StatelessWidget {
  const FamilyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = AppConstants.minMembers,
    this.max = AppConstants.maxMembers,
    this.label = 'Family members',
    this.helper = 'Include everyone who lives with you.',
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String label;
  final String helper;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(helper, style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _StepButton(
            icon: Icons.remove,
            label: 'Remove a family member',
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.h2,
            ),
          ),
          _StepButton(
            icon: Icons.add,
            label: 'Add a family member',
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: enabled ? AppColors.soft : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.iconTile),
          side: const BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: AppConstants.minTouchTarget,
            height: AppConstants.minTouchTarget,
            child: Icon(
              icon,
              size: 22,
              color: enabled ? AppColors.blueDark : AppColors.border,
            ),
          ),
        ),
      ),
    );
  }
}
