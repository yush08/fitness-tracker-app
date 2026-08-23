import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animations/shimmer.dart';

/// Loading placeholder for the dashboard. Mirrors the real layout — three
/// gauge tiles, a chart card, two achievement badges — so when the live data
/// arrives it fades in over the same shapes instead of the page jumping.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SkeletonBox(width: 140, height: 16),
          const SizedBox(height: 18),
          const SkeletonBox(width: 180, height: 22),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: _Tile()),
              SizedBox(width: 12),
              Expanded(child: _Tile()),
              SizedBox(width: 12),
              Expanded(child: _Tile()),
            ],
          ),
          const SizedBox(height: 26),
          const SkeletonBox(width: 160, height: 18),
          const SizedBox(height: 14),
          _card(const SizedBox(height: 200)),
          const SizedBox(height: 26),
          const SkeletonBox(width: 150, height: 22),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: _Badge()),
              SizedBox(width: 12),
              Expanded(child: _Badge()),
              SizedBox(width: 12),
              Expanded(child: _Badge()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(28),
        ),
        child: child,
      );
}

/// Just the three-gauge row — used while the innermost (meals) stream resolves,
/// so only the summary tiles shimmer rather than the whole page reloading.
class SummaryRowSkeleton extends StatelessWidget {
  const SummaryRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Row(
        children: const [
          Expanded(child: _Tile()),
          SizedBox(width: 12),
          Expanded(child: _Tile()),
          SizedBox(width: 12),
          Expanded(child: _Tile()),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: SkeletonBox(width: 54, height: 54, radius: 27),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
