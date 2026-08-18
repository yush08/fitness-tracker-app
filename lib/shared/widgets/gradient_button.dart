import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import 'animations/pressable.dart';
import 'clay.dart';

/// Full-width claymorphic action button with a centered label.
///
/// Renders a soft, puffy "clay" pill: a diagonal fill derived from [color]
/// (or the middle of [gradient]), layered clay shadows and a glossy top
/// highlight. The [gradient]/[color] API is kept for back-compat — the base
/// tint is taken from whichever is supplied.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? color;
  final Color? foreground;
  final double height;
  final double radius;

  /// Optional icon shown before the label.
  final Widget? icon;

  /// Optional icon shown after the label (e.g. a chevron on "Next").
  final Widget? trailingIcon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.color,
    this.foreground,
    this.height = 62,
    this.radius = 34,
    this.icon,
    this.trailingIcon,
  });

  /// Best-effort base tint from either a solid [color] or a [gradient].
  Color get _base {
    if (color != null) return color!;
    if (gradient is LinearGradient) {
      final cols = (gradient as LinearGradient).colors;
      return cols[cols.length ~/ 2];
    }
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final base = _base;
    final fg = foreground ?? AppColors.onAccent;
    return Pressable(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        height: height,
        width: double.infinity,
        decoration: Clay.decoration(base, radius: radius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClayGloss(radius: radius),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 10)],
                Text(label, style: AppTextStyles.button.copyWith(color: fg)),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 10),
                  trailingIcon!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
