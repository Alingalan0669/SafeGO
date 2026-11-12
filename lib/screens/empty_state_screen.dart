import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/empty_state_view.dart';

/// A friendly empty state that explains what will appear and how to start.
class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'Empty state',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: EmptyStateView(
                icon: Icons.inbox_outlined,
                title: 'Nothing saved yet',
                message:
                    'Your household and checklists will appear here. Set up your household to build a plan in about a minute.',
                actionLabel: 'Set up household',
                onAction: () => context.push(AppRoutes.editHousehold),
                secondaryLabel: 'Back to Home',
                onSecondary: () => context.go(AppRoutes.home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
