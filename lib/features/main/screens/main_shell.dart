// Tab widgets are intentionally non-const so a theme flip rebuilds them.
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          // Status-bar icons follow the dashboard theme (light on dark, etc.).
          value: (AppColors.isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
          child: PopScope(
            // On a non-Home tab, system-back returns to Home instead of exiting.
            canPop: index == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && index != 0) ShellController.go(0);
            },
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: _TabSwitcher(index: index, children: tabs),
              bottomNavigationBar: AppBottomNav(
                currentIndex: index,
                onTap: ShellController.go,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Hosts the tabs in an [IndexedStack] (so each tab keeps its scroll position
/// and state) while fading + easing the incoming tab in whenever the index
/// changes — so switching tabs matches the motion used elsewhere in the app
/// instead of a hard cut.
class _TabSwitcher extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _TabSwitcher({required this.index, required this.children});

  @override
  State<_TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<_TabSwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    value: 1,
  );
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.02),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void didUpdateWidget(_TabSwitcher old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: IndexedStack(index: widget.index, children: widget.children),
      ),
    );
  }
}
