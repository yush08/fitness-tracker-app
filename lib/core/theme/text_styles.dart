import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle heading = GoogleFonts.montserrat(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle subHeading = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.montserrat(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static TextStyle button = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle small = GoogleFonts.montserrat(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}