import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Segmented "Log In / Sign Up" control shown at the top of the auth screens.
/// [activeIndex] 0 = Log In, 1 = Sign Up.
class AuthTabToggle extends StatelessWidget {
  final int activeIndex;
  final VoidCallback onLogin;
  final VoidCallback onSignup;

  const AuthTabToggle({
    super.key,
    required this.activeIndex,
    required this.onLogin,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8BD00), Color(0xFFFB9905)],
        ),
      ),
      child: Row(
        children: [
          _segment('Log In', activeIndex == 0, onLogin),
          _segment('Sign Up', activeIndex == 1, onSignup),
        ],
      ),
    );
  }

  Widget _segment(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(36),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: active ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
