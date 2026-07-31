import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/charts/ring_gauge.dart';

class AchievementData {
  final String tierLabel;
  final Color tierColor;
  final IconData icon;
  final String title;
  final String streak;
  final double progress;

  const AchievementData({
    required this.tierLabel,
    required this.tierColor,
    required this.icon,
    required this.title,
    required this.streak,
    required this.progress,
  });
}

/// A single achievement badge card (tier ring + streak + share).
class AchievementCard extends StatelessWidget {
  final AchievementData data;
  final VoidCallback? onShare;

  const AchievementCard({super.key, required this.data, this.onShare});

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      color: AppColors.surfaceMuted,
      child: Column(
        children: [
          SizedBox(
            height: 78,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                RingGauge(
                  progress: data.progress,
                  size: 74,
                  strokeWidth: 5,
                  color: data.tierColor,
                  center: Icon(data.icon, color: data.tierColor, size: 30),
                ),
                Positioned(
                  top: -4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: data.tierColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.tierLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.small.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department,
                  color: AppColors.warning, size: 15),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  data.streak,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.warning, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onShare,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'SHARE',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
