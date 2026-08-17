import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import 'animations/pressable.dart';

/// Full-width rounded action button with centered label.
/// Accepts either a [gradient] (orange auth CTAs → white text) or a solid
/// [color] (lime dashboard CTAs → dark text).
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? color;
  final Color? foreground;
  final double height;
  final double radius;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.color,
    this.foreground,
    this.height = 62,
    this.radius = 40,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? (gradient != null ? Colors.white : AppColors.onAccent);
    return Pressable(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        height: height,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? color : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 10)],
            Text(label, style: AppTextStyles.button.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}
