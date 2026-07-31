import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/charts/ring_gauge.dart';

/// A Daily Summary tile: a ring gauge with a value in the middle and a
/// caption label underneath (steps / distance / calories).
class SummaryGaugeCard extends StatelessWidget {
  final String value;
  final String sub;
  final String label;
  final double progress;
  final Color color;

  const SummaryGaugeCard({
    super.key,
    required this.value,
    required this.sub,
    required this.label,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: AppColors.surfaceMuted,
      child: Column(
        children: [
          RingGauge(
            progress: progress,
            size: 74,
            strokeWidth: 6,
            color: color,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                ),
                Text(
                  sub,
                  style: AppTextStyles.caption.copyWith(fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.small.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
