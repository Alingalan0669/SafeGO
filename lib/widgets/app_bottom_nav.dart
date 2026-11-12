import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';

/// Custom bottom navigation for the four main sections.
///
/// The shell supplies the current index; tapping asks the router to switch
/// branch. Each destination keeps its own navigation stack and has a 48dp+
/// touch target with a visible focus/selected state.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const List<_Destination> _destinations = [
    _Destination(label: 'Home', icon: Icons.home_outlined, active: Icons.home),
    _Destination(
      label: 'Prepare',
      icon: Icons.checklist_outlined,
      active: Icons.checklist,
    ),
    _Destination(
      label: 'Pack',
      icon: Icons.backpack_outlined,
      active: Icons.backpack,
    ),
    _Destination(
      label: 'Evacuate',
      icon: Icons.logout_outlined,
      active: Icons.logout,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              for (var index = 0; index < _destinations.length; index++)
                Expanded(
                  child: _NavItem(
                    destination: _destinations[index],
                    isActive: index == currentIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final IconData icon;
  final IconData active;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isActive,
    required this.onTap,
  });

  final _Destination destination;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.blue : AppColors.muted;

    return Semantics(
      button: true,
      selected: isActive,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                constraints: const BoxConstraints(
                  minWidth: AppConstants.minTouchTarget,
                  minHeight: 32,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.blueSoft : AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadii.progress),
                ),
                child: Icon(
                  isActive ? destination.active : destination.icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
