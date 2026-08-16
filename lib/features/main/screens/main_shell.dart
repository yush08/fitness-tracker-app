// Tab widgets are intentionally non-const so a theme flip rebuilds them.
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../activity/screens/activity_feed_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../nutrition/screens/calorie_tracking_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../stats/screens/statistics_screen.dart';
import '../shell_controller.dart';

/// Hosts the six primary tabs behind a shared bottom navigation bar.
///
/// The selected tab lives in [ShellController] so any screen can switch tabs.
/// Rebuilds on a theme flip too (the tab screens read the global [AppColors]
/// tokens rather than [Theme], so they need an explicit trigger).
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    ShellController.index.value = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ThemeController.mode, ShellController.index]),
      builder: (context, _) {
        final index = ShellController.index.value;
        final tabs = <Widget>[
          HomeScreen(),
          CalorieTrackingScreen(),
          StatisticsScreen(),
          ActivityFeedScreen(),
          ProfileScreen(),
          SettingsScreen(),
        ];
        return PopScope(
          // On a non-Home tab, system-back returns to Home instead of exiting.
          canPop: index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && index != 0) ShellController.go(0);
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(index: index, children: tabs),
            bottomNavigationBar: AppBottomNav(
              currentIndex: index,
              onTap: ShellController.go,
            ),
          ),
        );
      },
    );
  }
}
