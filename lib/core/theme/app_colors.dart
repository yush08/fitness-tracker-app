import 'package:flutter/material.dart';

/// App colour tokens — lime / black / lavender aesthetic.
///
/// Brand / chart / status colours are constant across themes. The neutral
/// surface + text tokens are getters driven by [isDark], so one flag flip +
/// rebuild re-themes the whole app (light ⇄ dark).
class AppColors {
  /// Current theme mode. Set by the root before building (see ThemeController).
  static bool isDark = true;

  // ---- Brand / accent (constant across themes) ----
  /// Signature violet — used for fills, CTAs, nav highlight, primary data.
  static const Color accent = Color(0xFF8B7BF0);

  /// Content colour to sit on top of [accent] (white for contrast on violet).
  static const Color onAccent = Color(0xFFFFFFFF);

  /// Soft lavender — secondary cards & data.
  static const Color lavender = Color(0xFFCBB8F2);

  /// Violet — secondary accent / links that must read on light too.
  static const Color violet = Color(0xFF8B7BF0);

  static const Color primary = accent;
  static const Color secondary = lavender;

  /// Back-compat alias: everything that used the old "accent blue" is now lime.
  static Color get accentBlue => accent;

  /// Coloured text/link accent — lime on dark, violet on light (readable both).
  static Color get accentText => isDark ? accent : const Color(0xFF6D28D9);

  // ---- Status ----
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ---- Chart palette ----
  static const Color chartBlue = accent; // primary data → lime
  static const Color chartViolet = violet;
  static const Color chartRed = Color(0xFFFF6B6B);
  static const Color chartYellow = Color(0xFFF5B301);
  static const Color chartGreen = Color(0xFF22C55E);

  // ---- Achievement tiers ----
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFF5B301);

  /// Bottom-nav pill — dark in both themes (floating pill look).
  static const Color navSurface = Color(0xFF17181C);

  // ---- Neutrals (theme-aware) ----
  static Color get background =>
      isDark ? const Color(0xFF0D0D0F) : const Color(0xFFF1F1F5);
  static Color get cardBackground =>
      isDark ? const Color(0xFF17181C) : Colors.white;
  static Color get surfaceMuted =>
      isDark ? const Color(0xFF131418) : const Color(0xFFF7F7FB);
  static Color get surface =>
      isDark ? const Color(0xFF24262C) : const Color(0xFFEAEAF0);
  static Color get border =>
      isDark ? const Color(0xFF2B2D33) : const Color(0xFFE4E4EC);

  static Color get textPrimary =>
      isDark ? Colors.white : const Color(0xFF141419);
  static Color get textSecondary =>
      isDark ? const Color(0xFF9A9CA6) : const Color(0xFF56585F);
  static Color get textMuted =>
      isDark ? const Color(0xFF6A6C76) : const Color(0xFF9A9CA6);
}
