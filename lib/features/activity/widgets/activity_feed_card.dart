import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/utils/app_share.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../models/activity_post.dart';
import 'route_map_preview.dart';

/// A single post in the Activity Feed. Like is interactive; comment/share
/// give feedback via a snackbar.
class ActivityFeedCard extends StatefulWidget {
  final ActivityPost post;

  const ActivityFeedCard({super.key, required this.post});

  @override
  State<ActivityFeedCard> createState() => _ActivityFeedCardState();
}

class _ActivityFeedCardState extends State<ActivityFeedCard> {
  bool _liked = false;

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  void _share() {
    final p = widget.post;
    AppShare.text(
      context,
      "I just completed ${p.title} on GoFit — "
      "${p.distance} in ${p.duration} (${p.pace}). 🏃",
      subject: 'My GoFit activity',
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final likes = post.likes + (_liked ? 1 : 0);

    return DarkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(name: post.user, radius: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.user,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(post.time, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _metric('Distance', post.distance),
                    _metric('Time', post.duration),
                    _metric('Pace', post.pace),
                  ],
                ),
                const SizedBox(height: 14),
                RouteMapPreview(routeColor: post.routeColor),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _stat(
                _liked ? Icons.favorite : Icons.favorite_border,
                '$likes',
                color: _liked ? AppColors.chartRed : AppColors.textSecondary,
                onTap: () => setState(() => _liked = !_liked),
              ),
              const SizedBox(width: 20),
              _stat(
                Icons.mode_comment_outlined,
                '${post.comments}',
                onTap: () => _toast('Comments coming soon'),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _share,
                child: Icon(Icons.share_outlined,
                    color: AppColors.textSecondary, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.small.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _stat(IconData icon, String value,
      {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.textSecondary, size: 20),
          const SizedBox(width: 6),
          Text(value, style: AppTextStyles.small),
        ],
      ),
    );
  }
}
