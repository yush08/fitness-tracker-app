import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

/// Small brand wordmark shown at the top-left of dashboard screens
/// (the designs use a "logo" placeholder here).
///
/// Wrapped in an [AnimatedBuilder] on [ThemeController.mode] so it re-reads the
/// theme-aware [AppColors] even when used as a `const` widget (a const instance
/// is otherwise skipped by the framework on a theme flip, leaving stale colours).
class AppLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const AppLogo({super.key, this.fontSize = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.mode,
      builder: (context, _) => RichText(
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
      ),
    );
  }
}
