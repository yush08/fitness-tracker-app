import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A single activity in the social feed, backed by a Firestore document at
/// `users/{uid}/activities/{id}`.
///
/// Only raw numbers are stored (`distanceKm`, `durationSec`, `createdAt`); the
/// formatted strings the card renders — distance, pace, elapsed time, the
/// "Today at …" stamp — and the route colour are all *derived* here. That keeps
/// the document small and means changing how a pace is formatted never needs a
/// data migration.
class ActivityPost {
  final String id;
  final String user;
  final String title;
  final String type;
  final double distanceKm;
  final int durationSec;
  final DateTime createdAt;
  final int likes;
  final int comments;

  const ActivityPost({
    required this.id,
    required this.user,
    required this.title,
    required this.type,
    required this.distanceKm,
    required this.durationSec,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  String get distance => '${distanceKm.toStringAsFixed(2)} km';

  String get duration {
    final h = durationSec ~/ 3600;
    final m = (durationSec % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m';
    return '${durationSec}s';
  }

  /// Minutes-per-kilometre, e.g. "6:15/km". Blank when there is no distance.
  String get pace {
    if (distanceKm <= 0 || durationSec <= 0) return '—';
    final secPerKm = durationSec / distanceKm;
    final m = secPerKm ~/ 60;
    final s = (secPerKm % 60).round();
    return "$m:${s.toString().padLeft(2, '0')}/km";
  }

  /// Friendly, human timestamp for the card header.
  String get time {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final days = today.difference(that).inDays;
    final clock = TimeOfDay.fromDateTime(createdAt).format12h();
    if (days == 0) return 'Today at $clock';
    if (days == 1) return 'Yesterday at $clock';
    return '$days days ago';
  }

  /// Stable route colour derived from the activity type.
  Color get routeColor {
    switch (type.toLowerCase()) {
      case 'running':
        return const Color(0xFFF97316);
      case 'cycling':
        return AppColors.chartGreen;
      case 'swimming':
        return AppColors.chartBlue;
      case 'workout':
        return AppColors.violet;
      case 'walking':
        return AppColors.accentBlue;
      default:
        return AppColors.chartBlue;
    }
  }

  factory ActivityPost.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return ActivityPost(
      id: doc.id,
      user: data['user'] as String? ?? 'You',
      title: data['title'] as String? ?? 'Activity',
      type: data['type'] as String? ?? 'Other',
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
      durationSec: (data['durationSec'] as num?)?.toInt() ?? 0,
      // A server timestamp reads back null on the writing client for a beat;
      // fall back to "now" so the card never shows a blank time.
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: (data['likes'] as num?)?.toInt() ?? 0,
      comments: (data['comments'] as num?)?.toInt() ?? 0,
    );
  }
}

extension _Clock on TimeOfDay {
  /// e.g. "8:34 pm" — a small helper so the model has no BuildContext.
  String format12h() {
    final h = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final m = minute.toString().padLeft(2, '0');
    final suffix = period == DayPeriod.am ? 'am' : 'pm';
    return '$h:$m $suffix';
  }
}
