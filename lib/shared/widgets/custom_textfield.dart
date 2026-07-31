import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

/// Reusable pill/rounded text field.
///
/// Works on both the light (orange auth) and dark (dashboard) surfaces via
/// [dark]. Kept dependency-free and controlled by an optional [controller].
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final bool dark;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool pill;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.dark = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.pill = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fill = dark ? AppColors.surface : const Color(0xFFE7E7E7);
    final textColor = dark ? AppColors.textPrimary : Colors.black87;
    final hintColor = dark ? AppColors.textSecondary : Colors.black45;
    final radius = pill ? AppSizes.pillRadius : AppSizes.fieldRadius;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: color, width: 1.4),
        );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: GoogleFonts.montserrat(color: textColor, fontSize: 15),
      cursorColor: AppColors.accentBlue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(color: hintColor, fontSize: 15),
        filled: true,
        fillColor: fill,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        enabledBorder: border(Colors.transparent),
        focusedBorder: border(AppColors.accentBlue),
        border: border(Colors.transparent),
      ),
    );
  }
}
