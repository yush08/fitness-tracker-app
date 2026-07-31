import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF8BD00),
      Color(0xFFFC900D),
      Color(0xFFFC940B),
      Color(0xFFFBA801),
      Color(0xFFF9B702),
    ],
    stops: [
      0.0,
      0.30,
      0.61,
      0.85,
      0.94,
    ],
  );

  static const LinearGradient onboardingBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE500),
      Color(0xFFFF6F00),
    ],
  );

  /// Login / sign-up background — white at the top fading into warm orange.
  static const LinearGradient authBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Colors.white,
      Color(0xFFFFC46B),
      Color(0xFFFB9905),
    ],
    stops: [0.0, 0.45, 0.8, 1.0],
  );
}