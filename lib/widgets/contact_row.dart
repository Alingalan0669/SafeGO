import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/emergency_contact.dart';

/// One contact with a large, one-tap call button.
class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.contact,
    required this.onCall,
  });

  final EmergencyContact contact;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final trimmedName = contact.name.trim();
    final initial =
        trimmedName.isEmpty ? '?' : trimmedName.substring(0, 1).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.blueSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: AppTypography.subtitle.copyWith(color: AppColors.blueDark),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.displayName,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  contact.detailLabel,
                  style: AppTypography.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (contact.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    contact.phone,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.blueDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Semantics(
            button: true,
            label: 'Call ${contact.name}',
            child: Material(
              color: AppColors.blue,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onCall,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.call, color: AppColors.white, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
