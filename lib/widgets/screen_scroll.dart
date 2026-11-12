import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Standard scrollable page body.
///
/// Every screen uses one so long content can never overflow: the page scrolls
/// instead of throwing a RenderFlex overflow.
class ScreenScroll extends StatelessWidget {
  const ScreenScroll({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xs,
      AppSpacing.lg,
      AppSpacing.xl,
    ),
    this.controller,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: padding,
      child: child,
    );
  }
}
