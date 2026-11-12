import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// The SafeGo shield mark. Used on Splash, Onboarding and Settings.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 56,
    this.background = AppColors.blueSoft,
    this.foreground = AppColors.blue,
    this.radius = AppRadii.card,
  });

  final double size;
  final Color background;
  final Color foreground;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(
        Icons.shield_outlined,
        size: size * 0.52,
        color: foreground,
        semanticLabel: 'SafeGo logo',
      ),
    );
  }
}
