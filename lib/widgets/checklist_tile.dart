import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/checklist_item.dart';
import 'tag_pill.dart';

/// One tappable checklist row.
///
/// The whole row (minimum 64dp tall) is the touch target, not just the box,
/// which is friendlier on small phones and for users with limited dexterity.
class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    super.key,
    required this.item,
    required this.onToggle,
    this.showPersonalisedTag = true,
  });

  final ChecklistItem item;
  final VoidCallback onToggle;
  final bool showPersonalisedTag;

  @override
  Widget build(BuildContext context) {
    final done = item.isDone;

    return Semantics(
      container: true,
      button: true,
      checked: done,
      label: item.title,
      hint: done ? 'Packed or completed. Tap to undo.' : item.detail,
      excludeSemantics: true,
      child: Material(
        color: done ? AppColors.greenSoft : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: done ? AppColors.green : AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TickBox(isDone: done),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: done ? AppColors.green : AppColors.ink,
                          decoration:
                              done ? TextDecoration.lineThrough : null,
                          decorationColor: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(item.detail, style: AppTypography.caption),
                      if (showPersonalisedTag && item.isPersonalised) ...[
                        const SizedBox(height: AppSpacing.xs),
                        const TagPill(label: 'Made for your household'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  done ? Icons.check_circle : Icons.circle_outlined,
                  size: 20,
                  color: done ? AppColors.green : AppColors.border,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TickBox extends StatelessWidget {
  const _TickBox({required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDone ? AppColors.green : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.checkbox),
        border: Border.all(
          color: isDone ? AppColors.green : AppColors.border,
          width: 2,
        ),
      ),
      child: isDone
          ? const Icon(Icons.check, size: 18, color: AppColors.white)
          : null,
    );
  }
}
