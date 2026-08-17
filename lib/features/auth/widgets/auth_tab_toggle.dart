import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Segmented "Log In / Sign Up" control shown at the top of the auth screen.
///
/// The white selection pill is a single element that physically *slides*
/// between the two sides (via [AnimatedAlign]) rather than cross-fading in and
/// out per segment — so switching tabs reads as one continuous movement.
/// [activeIndex] 0 = Log In, 1 = Sign Up.
class AuthTabToggle extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const AuthTabToggle({
    super.key,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF9C8BF5), Color(0xFF7358E0)],
        ),
      ),
      child: Stack(
        children: [
          // Sliding white pill — fills half the width and eases across.
          Positioned.fill(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment:
                  activeIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _segment('Log In', 0),
              _segment('Sign Up', 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segment(String label, int index) {
    final active = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: active ? Colors.black : Colors.white,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
