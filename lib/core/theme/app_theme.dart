import 'package:flutter/material.dart';

/// SafeGo design tokens.
///
/// Every colour, radius, spacing value and text style used by the app comes
/// from this file so screens never hardcode raw values. Tokens were extracted
/// from the "SafeGo / Design system" frame in the Figma file.
abstract final class AppColors {
  // Brand / semantics from the Figma semantic colour row.
  static const Color blue = Color(0xFF1D4ED8);
  static const Color blueDark = Color(0xFF1E3A8A);
  static const Color blueSoft = Color(0xFFEFF6FF);
  static const Color green = Color(0xFF166534);
  static const Color greenSoft = Color(0xFFF0FDF4);
  static const Color amber = Color(0xFF92400E);
  static const Color amberSoft = Color(0xFFFFFBEB);
  static const Color red = Color(0xFFB91C1C);
  static const Color redDark = Color(0xFF7F1D1D);
  static const Color redSoft = Color(0xFFFEF2F2);
  static const Color ink = Color(0xFF111827);
  static const Color muted = Color(0xFF4B5563);
  static const Color border = Color(0xFFCBD5E1);
  static const Color soft = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

/// 8pt spacing grid (with 4pt used only for icon/label gaps).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Corner radii used by the component specimens.
abstract final class AppRadii {
  static const double checkbox = 6;
  static const double progress = 8;
  static const double iconTile = 12;
  static const double card = 16;
  static const double hero = 24;
  static const double mark = 28;
}

/// Type scale: Inter, exactly the sizes/line heights from the design system.
abstract final class AppTypography {
  static const String family = 'Inter';

  /// H1 / 28 / Bold / 36
  static const TextStyle h1 = TextStyle(
    fontFamily: family,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  /// H2 / 22 / Bold / 28
  static const TextStyle h2 = TextStyle(
    fontFamily: family,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  /// Subtitle / 18 / SemiBold / 24
  static const TextStyle subtitle = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Body / 16 / Regular / 24
  static const TextStyle body = TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  /// Body in a secondary colour.
  static const TextStyle bodyMuted = TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  /// Caption / 14 / Medium / 20
  static const TextStyle caption = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  /// 18pt action label used by buttons.
  static const TextStyle button = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// Large numeric display (readiness score / empty-state count).
  static const TextStyle number = TextStyle(
    fontFamily: family,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
}

/// Global Material theme assembled from the tokens above.
abstract final class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      secondary: AppColors.green,
      onSecondary: AppColors.white,
      error: AppColors.red,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.ink,
      outline: AppColors.border,
    );

    final textTheme = const TextTheme(
      headlineLarge: AppTypography.h1,
      headlineMedium: AppTypography.h2,
      titleLarge: AppTypography.subtitle,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.caption,
      labelLarge: AppTypography.button,
    ).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
      fontFamily: AppTypography.family,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.family,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: textTheme,
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.body.copyWith(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          borderSide: const BorderSide(color: AppColors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTypography.body.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.iconTile),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.blue,
          minimumSize: const Size(48, 48),
          textStyle: AppTypography.caption,
        ),
      ),
    );
  }
}
