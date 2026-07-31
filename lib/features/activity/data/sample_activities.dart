import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/activity_post.dart';

/// Placeholder activity feed content (UI preview only).
class SampleActivities {
  static const List<ActivityPost> posts = [
    ActivityPost(
      user: 'Kumar Ayush',
      time: 'Today at 8.34 pm',
      title: 'Night walk',
      distance: '5.51 km',
      duration: '1h 3m',
      pace: '6.15/km',
      likes: 42,
      comments: 11,
      routeColor: AppColors.chartBlue,
    ),
    ActivityPost(
      user: 'Kumar Ayush',
      time: 'Today at 6.30 pm',
      title: 'Evening run',
      distance: '7.2 km',
      duration: '45m',
      pace: '5.45/km',
      likes: 28,
      comments: 6,
      routeColor: Color(0xFFF97316),
    ),
  ];
}
