import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/pressable.dart';
import '../../../shared/utils/app_share.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/async_view.dart';
import '../models/activity_post.dart';
import '../services/activity_repository.dart';
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
                Icons.add,
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
                'Share',
                Icons.ios_share,
                () => AppShare.text(
                  context,
                  'Follow my fitness progress on GoFit! 💪',
                  subject: 'GoFit',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AsyncView<List<ActivityPost>>(
            stream: ActivityRepository.instance.feed(),
            isEmpty: (posts) => posts.isEmpty,
            empty: const EmptyState(
              icon: Icons.directions_run_rounded,
              text: 'No activities yet.\nTap "Start Activity" to log your first.',
            ),
            builder: (posts) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final post in posts) ...[
                  ActivityFeedCard(key: ValueKey(post.id), post: post),
                  const SizedBox(height: 18),
                ],
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _pillButton(String label, IconData icon, VoidCallback onTap) {
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
            Icon(icon, color: AppColors.onAccent, size: 16),
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
