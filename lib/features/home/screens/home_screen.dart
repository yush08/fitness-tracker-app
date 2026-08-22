import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/utils/app_share.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/async_view.dart';
import '../../activity/services/activity_repository.dart';
import '../../main/shell_controller.dart';
import '../../nutrition/models/meal.dart';
import '../../nutrition/services/meal_repository.dart';
import '../../profile/models/user_profile.dart';
import '../../profile/services/user_repository.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/charts/bar_chart.dart';
import '../widgets/achievement_card.dart';
import '../widgets/summary_gauge_card.dart';

/// The dashboard. Every figure here is derived from the user's own logged data
/// (meals + activities) and goals — nothing is hardcoded. Body-sensor metrics
/// (steps, heart rate, sleep) are intentionally absent: they need a Health
/// Connect / HealthKit integration, not user entry, so showing them here would
/// only ever be fake.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            AsyncView<UserProfile>(
              stream: UserRepository.instance.watchProfile(),
              builder: (profile) {
                final name = profile.displayName.trim().isEmpty
                    ? 'Athlete'
                    : profile.displayName.trim().split(' ').first;
                return AsyncView<ActivitySummary>(
                  stream: ActivityRepository.instance.summary(),
                  builder: (summary) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Welcome, $name', style: AppTextStyles.body),
                      const SizedBox(height: 18),
                      Text('Daily Summary', style: AppTextStyles.screenTitle),
                      const SizedBox(height: 14),
                      // Calories come from today's meals; active-minutes and
                      // distance from today's activities.
                      AsyncView<List<Meal>>(
                        stream: MealRepository.instance.todaysMeals(),
                        builder: (meals) => _summaryRow(
                          profile,
                          meals.fold<int>(0, (s, m) => s + m.calories),
                          summary,
                        ),
                      ),
                      const SizedBox(height: 26),
                      SectionHeader(
                        title: 'Weekly Distance',
                        actionLabel: 'View All',
                        onAction: () => ShellController.goTo(AppTab.stats),
                      ),
                      const SizedBox(height: 14),
                      DarkCard(
                        color: AppColors.surfaceMuted,
                        child: _weeklyChart(summary),
                      ),
                      const SizedBox(height: 26),
                      Text('Achievements', style: AppTextStyles.screenTitle),
                      const SizedBox(height: 14),
                      _achievements(context, summary),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Today's three gauges — all real: calories eaten, active minutes and
  /// distance covered today.
  Widget _summaryRow(UserProfile profile, int consumed, ActivitySummary s) {
    final calorieGoal = profile.goals.dailyCalories;
    return Row(
      children: [
        Expanded(
          child: SummaryGaugeCard(
            value: '${s.todayActiveMinutes}',
            sub: 'min',
            label: 'active',
            progress: (s.todayActiveMinutes / 60).clamp(0.0, 1.0),
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryGaugeCard(
            value: '$consumed',
            sub: '/$calorieGoal',
            label: 'calories',
            progress:
                calorieGoal == 0 ? 0 : (consumed / calorieGoal).clamp(0.0, 1.0),
            color: AppColors.violet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryGaugeCard(
            value: s.todayKm.toStringAsFixed(1),
            sub: 'km',
            label: 'distance',
            progress: (s.todayKm / 10).clamp(0.0, 1.0),
            color: AppColors.chartRed,
          ),
        ),
      ],
    );
  }

  /// Distance (km) per day over the last 7 days, from logged activities.
  Widget _weeklyChart(ActivitySummary s) {
    final peak = s.weekKm.fold<double>(0, (m, v) => v > m ? v : m);
    final maxY = peak <= 0 ? 5.0 : peak * 1.25;
    return BarChart(
      values: s.weekKm,
      xLabels: s.weekLabels,
      yTicks: [0, maxY * 0.25, maxY * 0.5, maxY * 0.75, maxY],
      maxY: maxY,
      barColor: AppColors.accent,
    );
  }

  /// Milestone badges unlocked from real all-time activity totals.
  Widget _achievements(BuildContext context, ActivitySummary s) {
    void share(String title) => AppShare.text(
          context,
          "I'm working toward the '$title' badge on GoFit — "
          "${s.totalKm.toStringAsFixed(1)} km across ${s.totalCount} "
          "${s.totalCount == 1 ? 'activity' : 'activities'}! 🏅",
          subject: 'GoFit achievement',
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AchievementCard(
            onShare: () => share('First Activity'),
            data: AchievementData(
              tierLabel: 'Bronze',
              tierColor: AppColors.bronze,
              icon: Icons.flag_rounded,
              title: 'First Activity',
              streak: '${s.totalCount} logged',
              progress: s.totalCount >= 1 ? 1 : 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AchievementCard(
            onShare: () => share('10 km Club'),
            data: AchievementData(
              tierLabel: 'Silver',
              tierColor: AppColors.silver,
              icon: Icons.directions_run,
              title: '10 km Club',
              streak: '${s.totalKm.toStringAsFixed(1)} / 10 km',
              progress: (s.totalKm / 10).clamp(0.0, 1.0),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AchievementCard(
            onShare: () => share('Marathon'),
            data: AchievementData(
              tierLabel: 'Gold',
              tierColor: AppColors.gold,
              icon: Icons.emoji_events,
              title: 'Marathon',
              streak: '${s.totalKm.toStringAsFixed(1)} / 42.2 km',
              progress: (s.totalKm / 42.2).clamp(0.0, 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
