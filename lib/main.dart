import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        // Keep the token flag in sync before the theme/screens read it.
        AppColors.isDark = mode == ThemeMode.dark;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoFit',
          themeMode: mode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const OnboardingScreen(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
