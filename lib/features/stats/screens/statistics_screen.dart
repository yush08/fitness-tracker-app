import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/skeletons.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/charts/line_chart.dart';
import '../../activity/services/activity_repository.dart';
import '../widgets/heatmap_grid.dart';

/// Detailed statistics — every figure is derived from the user's logged
/// activities (see [ActivitySummary]); nothing here is hardcoded.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      child: StaggerReveal(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          step: const Duration(milliseconds: 60),
          children: [
            const AppLogo(),
            const SizedBox(height: 12),
            Text('Detailed statistics', style: AppTextStyles.screenTitle),
            const SizedBox(height: 18),
            AsyncView<ActivitySummary>(
              stream: ActivityRepository.instance.summary(),
              loading: const StatsSkeleton(),
              builder: (s) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DarkCard(
                    color: AppColors.surfaceMuted,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Weekly Distance · last 8 weeks',
                            style: AppTextStyles.cardTitle),
                        const SizedBox(height: 12),
                        _monthlyChart(s),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Total Distance',
                          value: '${s.totalKm.toStringAsFixed(1)} km',
                          delta: '${s.totalCount} '
                              '${s.totalCount == 1 ? 'activity' : 'activities'}',
                          valueColor: AppColors.chartRed,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          label: 'Active Time',
                          value: _formatMinutes(s.totalActiveMinutes),
                          delta: 'all time',
                          valueColor: AppColors.accentText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DarkCard(
                    color: AppColors.surfaceMuted,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Activity Heatmap · last 15 weeks',
                            style: AppTextStyles.cardTitle),
                        const SizedBox(height: 16),
                        HeatmapGrid(intensities: s.heat),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _monthlyChart(ActivitySummary s) {
    final peak = s.weeks8Km.fold<double>(0, (m, v) => v > m ? v : m);
    final maxY = peak <= 0 ? 5.0 : peak * 1.25;
    return LineChart(
      values: s.weeks8Km,
      xLabels: const ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8'],
      yTicks: [0, maxY * 0.5, maxY],
      minY: 0,
      maxY: maxY,
      lineColor: AppColors.accentBlue,
      showDots: true,
      height: 170,
    );
  }

  static String _formatMinutes(int totalMin) {
    final h = totalMin ~/ 60;
    final m = totalMin % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String delta;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.delta,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.statValue.copyWith(color: valueColor),
          ),
          const SizedBox(height: 8),
          Text(delta, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
