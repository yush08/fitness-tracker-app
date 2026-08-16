import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/custom_textfield.dart';

/// Label + rounded field pair shared by the login and sign-up screens.
class AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: hint,
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          suffixIcon: suffixIcon,
          pill: true,
          errorText: errorText,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
