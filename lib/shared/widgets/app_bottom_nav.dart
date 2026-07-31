import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

/// Tab identifiers for the dashboard bottom navigation.
/// The int value doubles as the [IndexedStack] index in [MainShell].
enum AppTab { home, calories, stats, feed, profile, settings }

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

const List<_NavItem> _items = [
  _NavItem(Icons.home_rounded, 'Home'),
  _NavItem(Icons.restaurant_rounded, 'Calories'),
  _NavItem(Icons.bar_chart_rounded, 'Stats'),
  _NavItem(Icons.dynamic_feed_rounded, 'My Feed'),
  _NavItem(Icons.person_rounded, 'Profile'),
  _NavItem(Icons.settings_rounded, 'Settings'),
];

/// Floating dark pill navigation with a lime highlight on the active tab.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.navSurface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                for (int i = 0; i < _items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: _items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 34,
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              item.icon,
              size: 22,
              color: selected ? AppColors.onAccent : const Color(0xFF8A8C96),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: AppTextStyles.navLabel.copyWith(
              color: selected ? AppColors.accent : const Color(0xFF8A8C96),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
