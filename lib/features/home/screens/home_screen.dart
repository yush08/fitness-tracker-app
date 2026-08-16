import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../main/shell_controller.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/charts/bar_chart.dart';
import '../../../shared/widgets/charts/line_chart.dart';
import '../../../shared/widgets/charts/segmented_bar.dart';
import '../widgets/achievement_card.dart';
import '../widgets/summary_gauge_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: StaggerReveal(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        step: const Duration(milliseconds: 55),
        children: [
          const AppLogo(),
          const SizedBox(height: 10),
          Text('Welcome, Ayush', style: AppTextStyles.body),
          const SizedBox(height: 18),

          Text('Daily Summary', style: AppTextStyles.screenTitle),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SummaryGaugeCard(
                  value: '7500',
                  sub: '/10,000',
                  label: 'steps',
                  progress: 0.75,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryGaugeCard(
                  value: '1200',
                  sub: '/2000',
                  label: 'calories',
                  progress: 0.6,
                  color: AppColors.violet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryGaugeCard(
                  value: '8.5',
                  sub: 'km',
                  label: 'distance',
                  progress: 0.55,
                  color: AppColors.chartRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),

          SectionHeader(
            title: 'Weekly Activity',
            actionLabel: 'View All',
            onAction: () => ShellController.goTo(AppTab.stats),
          ),
          const SizedBox(height: 14),
          DarkCard(
            color: AppColors.surfaceMuted,
            child: BarChart(
              values: const [5300, 6800, 8900, 6800, 8000, 5100, 9900],
              xLabels: _weekLabels,
              yTicks: const [0, 2000, 4000, 6000, 8000, 10000],
              maxY: 10500,
              goalValue: 10000,
            ),
          ),
          const SizedBox(height: 26),

          SectionHeader(
            title: 'Heart Rate',
            actionLabel: '94 BPM',
            style: AppTextStyles.screenTitle,
          ),
          const SizedBox(height: 14),
          DarkCard(
            color: AppColors.surfaceMuted,
            child: LineChart(
              values: const [90, 82, 100, 140, 150, 120, 85, 78, 105, 120, 95],
              xLabels: const ['4 AM', '8 AM', '12 PM', '4 PM', '8 PM', 'Now'],
              yTicks: const [0, 40, 80, 120, 160, 200],
              minY: 0,
              maxY: 200,
              lineColor: AppColors.chartRed,
            ),
          ),
          const SizedBox(height: 26),

          SectionHeader(
            title: 'Sleep',
            actionLabel: '7h 24 m',
          ),
          const SizedBox(height: 14),
          _sleepCard(),
          const SizedBox(height: 26),

          Text('Achievements', style: AppTextStyles.screenTitle),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AchievementCard(
                  data: const AchievementData(
                    tierLabel: 'Bronze',
                    tierColor: AppColors.bronze,
                    icon: Icons.military_tech,
                    title: '5,000 steps',
                    streak: '3-day streak',
                    progress: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AchievementCard(
                  data: const AchievementData(
                    tierLabel: 'Silver',
                    tierColor: AppColors.silver,
                    icon: Icons.local_fire_department,
                    title: '2,500 calories',
                    streak: '3-day streak',
                    progress: 0.7,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AchievementCard(
                  data: const AchievementData(
                    tierLabel: 'Gold',
                    tierColor: AppColors.gold,
                    icon: Icons.directions_run,
                    title: 'Marathon',
                    streak: '3-day streak',
                    progress: 0.85,
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _sleepCard() {
    return DarkCard(
      color: AppColors.surfaceMuted,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sleepLabel('Bedtime', '11:32 PM', CrossAxisAlignment.start),
              _sleepLabel('Wake Up', '6:56 AM', CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 14),
          SegmentedBar(
            segments: [
              BarSegment(2, AppColors.textMuted),
              const BarSegment(3, AppColors.chartRed),
              const BarSegment(3, AppColors.violet),
              const BarSegment(3, AppColors.chartRed),
              BarSegment(2, AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Legend(color: AppColors.textMuted, label: 'Awake'),
              _Legend(color: AppColors.chartRed, label: 'Light'),
              _Legend(color: AppColors.violet, label: 'Deep'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sleepLabel(String title, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 2),
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
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
