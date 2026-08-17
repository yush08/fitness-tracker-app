 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/onboarding/screens/onboarding_pager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Draw edge-to-edge so screen gradients extend behind the status/nav bars
  // instead of leaving a black strip at the bottom.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
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
          home: const OnboardingPager(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
