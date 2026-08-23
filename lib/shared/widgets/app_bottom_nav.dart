import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import 'animations/pressable.dart';

/// Muted grey for inactive nav icons/labels (kept dark-pill readable in both
/// themes, so it isn't a theme-aware token).
const Color _inactive = Color(0xFF8A8C96);

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
        child: Align(
          // Cap the pill on tablets/foldables so it lines up with the
          // width-capped body content instead of stretching edge to edge.
          // heightFactor: 1.0 shrink-wraps the height — WITHOUT it, Align/Center
          // expands to fill the Scaffold's bounded bottom-bar slot (the full
          // screen height) and starves the body of vertical space.
          alignment: Alignment.center,
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
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
                  color: Colors.black.withValues(alpha: 0.25),
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
    // Pressable (squish) matches the tactile feedback used everywhere else in
    // the app, instead of the Material ripple this used to have.
    return Pressable(
      scale: 0.9,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The active pill scales up a touch as it lights up — a small "pop".
          AnimatedScale(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            scale: selected ? 1.0 : 0.9,
            child: AnimatedContainer(
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
                color: selected ? AppColors.onAccent : _inactive,
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.navLabel.copyWith(
              color: selected ? AppColors.accent : _inactive,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
