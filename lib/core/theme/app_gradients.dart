import 'package:flutter/material.dart';

class AppGradients {
  /// Primary CTA gradient — violet/purple pill (Continue, Sign In, …).
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFA593F7),
      Color(0xFF8B7BF0),
      Color(0xFF7B67EC),
      Color(0xFF6A54E4),
    ],
    stops: [
      0.0,
      0.35,
      0.70,
      1.0,
    ],
  );

  /// Onboarding background — soft purple at the top fading into lime green.
  static const LinearGradient onboardingBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9385D8),
      Color(0xFFAFC162),
      Color(0xFFC7F536),
    ],
    stops: [0.0, 0.7, 1.0],
  );

  /// Reversed onboarding background — lime at the top fading into purple.
  static const LinearGradient onboardingBackgroundGradientReversed =
      LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFC7F536),
      Color(0xFFAFC162),
      Color(0xFF9385D8),
    ],
    stops: [0.0, 0.35, 1.0],
  );

  /// Login / sign-up background — black at the top fading into violet.
  static const LinearGradient authBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF050506),
      Color(0xFF0A0A12),
      Color(0xFF3E2F82),
      Color(0xFF8B7BF0),
    ],
    stops: [0.0, 0.55, 0.9, 1.0],
  );
}
