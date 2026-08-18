import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/animations/pressable.dart';
import '../../../shared/widgets/clay.dart';

/// White pill button for "login with" providers (Google / Apple).
/// Visual only — [onTap] is optional and defaults to a no-op.
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        decoration: Clay.decoration(const Color(0xFFF4F4F7), radius: 30),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const ClayGloss(radius: 30, opacity: 0.5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 26),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
