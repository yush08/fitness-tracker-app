import 'package:flutter/material.dart';

/// Claymorphism toolkit — soft, puffy "clay" surfaces used across the app.
///
/// The look is built from three layers that a plain [BoxDecoration] gives us
/// without any inner-shadow package:
///   1. a diagonal fill gradient (lighter top-left → darker bottom-right) that
///      fakes the way light wraps a rounded clay lump;
///   2. a deep, soft drop shadow plus a tight contact shadow for lift;
///   3. a light "rim" shadow at the top-left so the edge catches the light.
/// A thin top gloss ([ClayGloss]) is layered on top for the glossy sheen.
class Clay {
  const Clay._();

  static Color lighten(Color c, [double amount = 0.1]) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color darken(Color c, [double amount = 0.1]) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// A raised clay surface of [base] colour.
  static BoxDecoration decoration(
    Color base, {
    double radius = 30,
    double depth = 1.0,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [lighten(base, 0.11), base, darken(base, 0.08)],
        stops: const [0.0, 0.55, 1.0],
      ),
      boxShadow: [
        // Deep, soft drop shadow — the "floating clay" lift.
        BoxShadow(
          color: darken(base, 0.30).withOpacity(0.42 * depth),
          blurRadius: 28,
          spreadRadius: -4,
          offset: const Offset(0, 16),
        ),
        // Tight contact shadow so it sits, rather than hovers.
        BoxShadow(
          color: Colors.black.withOpacity(0.16 * depth),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
        // Top-left rim light — the puffy clay highlight. Kept tight and low
        // so it reads as a soft edge, not a glow, on dark backgrounds.
        BoxShadow(
          color: lighten(base, 0.20).withOpacity(0.32),
          blurRadius: 8,
          spreadRadius: -10,
          offset: const Offset(-5, -6),
        ),
      ],
    );
  }
}

/// Glossy top highlight for a clay surface — drop it inside a [Stack] filling
/// the button so the upper edge picks up a soft sheen. Purely decorative and
/// ignores pointers.
class ClayGloss extends StatelessWidget {
  const ClayGloss({super.key, this.radius = 30, this.opacity = 0.22});

  final double radius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(opacity),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
