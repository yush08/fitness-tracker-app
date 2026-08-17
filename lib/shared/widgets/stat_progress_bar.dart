import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

/// Labelled horizontal progress bar used across the dashboard
/// (daily goal, personal goals, nutrition values).
class StatProgressBar extends StatelessWidget {
  final String label;
  final String? valueText;
  final double progress; // 0.0 - 1.0
  final Color fillColor;
  final Color? valueColor;
  final double height;

  /// Fill animation duration. Set to [Duration.zero] to disable.
  final Duration duration;

  const StatProgressBar({
    super.key,
    required this.label,
    required this.progress,
    required this.fillColor,
    this.valueText,
    this.valueColor,
    this.height = 8,
    this.duration = const Duration(milliseconds: 850),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
            ),
            if (valueText != null)
              Text(
                valueText!,
                style: AppTextStyles.small.copyWith(
                  color: valueColor ?? fillColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: height,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(fillColor),
            ),
          ),
        ),
      ],
    );
  }
}
