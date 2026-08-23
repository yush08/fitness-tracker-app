import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'shimmer.dart';

/// Reusable loading placeholders that mirror the live screens' layouts, so
/// data fades in over the same shapes instead of the page jumping. All share
/// the app's single [Shimmer] sweep. Pass them to `AsyncView(loading: …)`.

BoxDecoration _panel([double radius = 24]) => BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(radius),
    );

/// A tall rounded block — a stand-in for a card whose contents haven't loaded.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.height = 120, this.radius = 24});
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, decoration: _panel(radius));
}

/// Loading state for the Activity Feed — three post-shaped cards.
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _PostCard(),
          SizedBox(height: 18),
          _PostCard(),
          SizedBox(height: 18),
          _PostCard(),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panel(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SkeletonBox(width: 40, height: 40, radius: 20),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 110, height: 12),
                  SizedBox(height: 6),
                  SkeletonBox(width: 70, height: 10),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const SkeletonBox(width: 160, height: 14),
          const SizedBox(height: 12),
          SkeletonCard(height: 90, radius: 14),
        ],
      ),
    );
  }
}

/// Loading state for the Calorie screen — goal card, list rows, chart card.
class CalorieSkeleton extends StatelessWidget {
  const CalorieSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkeletonCard(height: 96, radius: 28),
          const SizedBox(height: 24),
          const SkeletonBox(width: 120, height: 22),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _panel(28),
            child: Column(
              children: const [
                _Row(),
                SizedBox(height: 14),
                _Row(),
                SizedBox(height: 14),
                _Row(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SkeletonCard(height: 200, radius: 28),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SkeletonBox(width: 40, height: 40, radius: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 120, height: 12),
              SizedBox(height: 6),
              SkeletonBox(width: 80, height: 10),
            ],
          ),
        ),
        SizedBox(width: 12),
        SkeletonBox(width: 44, height: 12),
      ],
    );
  }
}

/// Loading state for the Statistics screen — chart card, two stat cards, heatmap.
class StatsSkeleton extends StatelessWidget {
  const StatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkeletonCard(height: 220, radius: 28),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: SkeletonCard(height: 108, radius: 28)),
              const SizedBox(width: 14),
              Expanded(child: SkeletonCard(height: 108, radius: 28)),
            ],
          ),
          const SizedBox(height: 20),
          SkeletonCard(height: 200, radius: 28),
        ],
      ),
    );
  }
}
