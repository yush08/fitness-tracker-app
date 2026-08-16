import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/pressable.dart';
import '../../../shared/widgets/app_logo.dart';
import '../data/sample_activities.dart';
import '../widgets/activity_feed_card.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: StaggerReveal(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        step: const Duration(milliseconds: 60),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppLogo(),
              _pillButton(
                'Start Activity',
                () => Navigator.pushNamed(context, AppRoutes.startActivity),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Feed', style: AppTextStyles.screenTitle),
              _pillButton(
                'share',
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity shared to your feed')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (final post in SampleActivities.posts) ...[
            ActivityFeedCard(post: post),
            const SizedBox(height: 18),
          ],
        ],
        ),
      ),
    );
  }

  Widget _pillButton(String label, VoidCallback onTap) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: AppColors.onAccent, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: AppColors.onAccent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
