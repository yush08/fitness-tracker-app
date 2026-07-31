import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

/// Rounded dark container used as the base surface for every dashboard card.
/// Centralises radius / colour / padding so screens never hardcode them.
class DarkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;
  final bool border;

  const DarkCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.radius = AppSizes.cardRadius,
    this.onTap,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(radius),
        border: border || !AppColors.isDark
            ? Border.all(color: AppColors.border)
            : null,
        // Soft lift so white cards read against the light-grey background.
        boxShadow: AppColors.isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
