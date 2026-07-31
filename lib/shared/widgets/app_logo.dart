import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Small brand wordmark shown at the top-left of dashboard screens
/// (the designs use a "logo" placeholder here).
class AppLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const AppLogo({super.key, this.fontSize = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: color ?? AppColors.textPrimary,
        ),
        children: [
          const TextSpan(text: 'Go'),
          TextSpan(
            text: 'Fit',
            style: TextStyle(color: color ?? AppColors.accentText),
          ),
        ],
      ),
    );
  }
}
