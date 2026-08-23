import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Light and dark themes for the dashboard side of the app.
///
/// The onboarding/auth flow paints its own orange gradients on top, so each
/// theme only needs sensible neutral defaults + Montserrat text. Both are
/// built from the theme-aware [AppColors] getters (driven by [AppColors.isDark]),
/// so callers must set that flag before reading these.
class AppTheme {
  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: AppColors.accentBlue,
        secondary: AppColors.secondary,
        surface: AppColors.cardBackground,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      splashColor: AppColors.accentBlue.withValues(alpha: 0.12),
      highlightColor: Colors.transparent,
    );
  }
}
