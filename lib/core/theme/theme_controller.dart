import 'package:flutter/material.dart';

/// App-wide light/dark switch. A plain [ValueNotifier] (no state-management
/// package) that the root listens to; toggling it rebuilds [MaterialApp].
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static bool get isDark => mode.value == ThemeMode.dark;

  static void setDark(bool dark) =>
      mode.value = dark ? ThemeMode.dark : ThemeMode.light;

  static void toggle() => setDark(!isDark);
}
