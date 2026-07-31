import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/charts/line_chart.dart';
import '../widgets/heatmap_grid.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  // Deterministic placeholder heatmap intensities (15 weeks × 7 days).
  static final List<int> _heat =
      List.generate(15 * 7, (i) => (i * 7 + i ~/ 3) % 5);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const AppLogo(),
          const SizedBox(height: 12),
          Text('Detailed statistics', style: AppTextStyles.screenTitle),
          const SizedBox(height: 18),

          DarkCard(
            color: AppColors.surfaceMuted,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monthly Overview', style: AppTextStyles.cardTitle),
                const SizedBox(height: 12),
                LineChart(
                  values: const [4200, 5100, 4800, 6200, 5600, 7100, 6500, 8745],
                  xLabels: const ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8'],
                  yTicks: const [0, 3000, 6000, 9000],
                  minY: 0,
                  maxY: 9000,
                  lineColor: AppColors.accentBlue,
                  showDots: true,
                  height: 170,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Average Steps',
                  value: '8745',
                  delta: '+12% vs last month',
                  valueColor: AppColors.accentText,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  label: 'Total Distance',
                  value: '164.3 km',
                  delta: '+8% vs last month',
                  valueColor: AppColors.chartRed,
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
                Text('Activity Heatmap', style: AppTextStyles.cardTitle),
                const SizedBox(height: 16),
                HeatmapGrid(intensities: _heat),
              ],
            ),
          ),
        ],
      ),
    );
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
