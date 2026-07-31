import 'package:flutter/material.dart';

/// A single activity in the social feed.
class ActivityPost {
  final String user;
  final String time;
  final String title;
  final String distance;
  final String duration;
  final String pace;
  final int likes;
  final int comments;
  final Color routeColor;

  const ActivityPost({
    required this.user,
    required this.time,
    required this.title,
    required this.distance,
    required this.duration,
    required this.pace,
    required this.likes,
    required this.comments,
    required this.routeColor,
  });
}
