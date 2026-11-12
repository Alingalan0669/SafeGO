import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/household_profile.dart';

/// Three selectable hazard tiles used during household setup.
class HazardSelector extends StatelessWidget {
  const HazardSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HazardType selected;
  final ValueChanged<HazardType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < HazardType.values.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _HazardTile(
              hazard: HazardType.values[index],
              isSelected: HazardType.values[index] == selected,
              onTap: () => onChanged(HazardType.values[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _HazardTile extends StatelessWidget {
  const _HazardTile({
    required this.hazard,
    required this.isSelected,
    required this.onTap,
  });

  final HazardType hazard;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (hazard) {
      HazardType.flood => Icons.water,
      HazardType.typhoon => Icons.cyclone,
      HazardType.quake => Icons.vibration,
    };

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${hazard.label} hazard',
      child: Material(
        color: isSelected ? AppColors.blueSoft : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.iconTile),
          side: BorderSide(
            color: isSelected ? AppColors.blue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 84),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 26,
                    color: isSelected ? AppColors.blue : AppColors.muted,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    hazard.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: isSelected ? AppColors.blueDark : AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
