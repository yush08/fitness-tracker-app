import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles are getters (not cached fields) so they re-read the
/// theme-aware [AppColors] neutrals on every access and flip with the theme.
class AppTextStyles {
  static TextStyle get body => GoogleFonts.montserrat(
        fontSize: 16,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get small => GoogleFonts.montserrat(
        fontSize: 14,
        color: AppColors.textSecondary,
      );

  // ---- Dashboard styles ----

  /// Large screen title, e.g. "Calorie tracking", "Settings".
  static TextStyle get screenTitle => GoogleFonts.montserrat(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Section / card heading, e.g. "Today's Meals", "Nutrition Breakdown".
  static TextStyle get cardTitle => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Emphasised numeric value inside stat tiles.
  static TextStyle get statValue => GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Muted caption / metadata.
  static TextStyle get caption => GoogleFonts.montserrat(
        fontSize: 12,
        color: AppColors.textSecondary,
      );

  /// Bottom navigation labels.
  static TextStyle get navLabel =>
      GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w500);
}
