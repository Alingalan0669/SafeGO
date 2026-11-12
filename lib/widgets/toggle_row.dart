import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Label + supporting text + switch, with the entire row as a touch target.
class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.showDivider = false,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: title,
      hint: subtitle,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.blueSoft,
                        borderRadius: BorderRadius.circular(AppRadii.iconTile),
                      ),
                      child: Icon(icon, color: AppColors.blue, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
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
                  const SizedBox(width: AppSpacing.xs),
                  ExcludeSemantics(
                    child: Switch(
                      value: value,
                      onChanged: onChanged,
                      activeTrackColor: AppColors.blue,
                      activeThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.soft,
                      inactiveThumbColor: AppColors.white,
                    ),
                  ),
                ],
              ),
              if (showDivider)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: Divider(height: 1, color: AppColors.border),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
