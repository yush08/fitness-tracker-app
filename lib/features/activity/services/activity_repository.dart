import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/data/firestore_service.dart';
import '../models/activity_post.dart';

/// Aggregate view over a user's activities, computed on the client from the
/// full list. Keeping it client-side means Home and Profile need only one
/// activities stream to drive the daily gauges, the weekly chart and the
/// achievement badges — no extra queries, no composite indexes.
class ActivitySummary {
  final double todayKm;
  final int todayActiveMinutes;
  final double totalKm;
  final int totalCount;
  final int totalActiveMinutes;

  /// Distance (km) per day for the last 7 days, oldest → newest, aligned with
  /// [weekLabels].
  final List<double> weekKm;
  final List<String> weekLabels;

  /// Distance (km) per week for the last 8 weeks, oldest → newest (Stats tab).
  final List<double> weeks8Km;

  /// Per-day intensity 0–4 for the last 15×7 days, oldest → newest, driving the
  /// Stats heatmap.
  final List<int> heat;

  const ActivitySummary({
    required this.todayKm,
    required this.todayActiveMinutes,
    required this.totalKm,
    required this.totalCount,
    required this.totalActiveMinutes,
    required this.weekKm,
    required this.weekLabels,
    required this.weeks8Km,
    required this.heat,
  });

  static const _weekdayNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static const _heatDays = 15 * 7; // 105

  factory ActivitySummary.from(List<ActivityPost> all) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    double todayKm = 0;
    int todayMin = 0;
    double totalKm = 0;
    int totalMin = 0;

    final weekKm = List<double>.filled(7, 0);
    final weekLabels = [
      for (int i = 6; i >= 0; i--)
        _weekdayNames[todayStart.subtract(Duration(days: i)).weekday - 1],
    ];
    final weeks8Km = List<double>.filled(8, 0);
    final heatKm = List<double>.filled(_heatDays, 0);

    for (final a in all) {
      totalKm += a.distanceKm;
      totalMin += a.durationSec ~/ 60;

      if (!a.createdAt.isBefore(todayStart)) {
        todayKm += a.distanceKm;
        todayMin += a.durationSec ~/ 60;
      }

      final day =
          DateTime(a.createdAt.year, a.createdAt.month, a.createdAt.day);
      final daysAgo = todayStart.difference(day).inDays;
      if (daysAgo < 0) continue; // future-dated guard

      if (daysAgo < 7) weekKm[6 - daysAgo] += a.distanceKm;
      final weeksAgo = daysAgo ~/ 7;
      if (weeksAgo < 8) weeks8Km[7 - weeksAgo] += a.distanceKm;
      if (daysAgo < _heatDays) heatKm[_heatDays - 1 - daysAgo] += a.distanceKm;
    }

    // Map each day's distance to a 0–4 intensity bucket for the heatmap.
    int bucket(double km) {
      if (km <= 0) return 0;
      if (km < 2) return 1;
      if (km < 5) return 2;
      if (km < 8) return 3;
      return 4;
    }

    return ActivitySummary(
      todayKm: todayKm,
      todayActiveMinutes: todayMin,
      totalKm: totalKm,
      totalCount: all.length,
      totalActiveMinutes: totalMin,
      weekKm: weekKm,
      weekLabels: weekLabels,
      weeks8Km: weeks8Km,
      heat: heatKm.map(bucket).toList(),
    );
  }
}

/// Read/write access to the signed-in user's activities.
class ActivityRepository {
  ActivityRepository._();
  static final ActivityRepository instance = ActivityRepository._();

  final FirestoreService _svc = FirestoreService.instance;

  /// The activity feed, newest first.
  Stream<List<ActivityPost>> feed() {
    return _svc.activities
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ActivityPost.fromDoc).toList());
  }

  /// Live aggregate stats derived from the full activity list — drives Home's
  /// gauges, weekly chart and achievements, and Profile's progress.
  Stream<ActivitySummary> summary() => feed().map(ActivitySummary.from);

  Future<void> logActivity({
    required String title,
    required String type,
    required double distanceKm,
    required int durationSec,
  }) {
    final name = FirebaseAuth.instance.currentUser?.displayName;
    return _svc.activities.add({
      'user': (name == null || name.trim().isEmpty) ? 'You' : name.trim(),
      'title': title,
      'type': type,
      'distanceKm': distanceKm,
      'durationSec': durationSec,
      'likes': 0,
      'comments': 0,
      // Server-authoritative time so ordering is consistent across devices.
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
