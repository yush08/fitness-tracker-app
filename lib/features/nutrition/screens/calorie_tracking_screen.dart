import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/charts/donut_chart.dart';
import '../../../shared/widgets/charts/line_chart.dart';
import '../data/sample_nutrition.dart';
import '../widgets/meal_tile.dart';

class CalorieTrackingScreen extends StatelessWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const consumed = SampleNutrition.dailyGoal - SampleNutrition.remaining;
    const progress = consumed / SampleNutrition.dailyGoal;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const AppLogo(),
          const SizedBox(height: 12),
          Text('Calorie tracking', style: AppTextStyles.screenTitle),
          const SizedBox(height: 16),

          // Daily goal card
          DarkCard(
            color: AppColors.surfaceMuted,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _goalColumn('Daily Goal', '2000 cal',
                        AppColors.textPrimary, CrossAxisAlignment.start),
                    _goalColumn('Remaining', '852 cal', AppColors.accentText,
                        CrossAxisAlignment.end),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.textMuted,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Weekly Activity', style: AppTextStyles.screenTitle),
          const SizedBox(height: 14),

          // Today's meals
          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Meals", style: AppTextStyles.cardTitle),
                const SizedBox(height: 6),
                for (final meal in SampleNutrition.todaysMeals)
                  MealTile(
                    meal: meal,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.foodDetails),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Nutrition breakdown
          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nutrition Breakdown', style: AppTextStyles.cardTitle),
                const SizedBox(height: 16),
                const Center(
                  child: DonutChart(
                    segments: [
                      DonutSegment(35, AppColors.chartYellow),
                      DonutSegment(32, AppColors.chartRed),
                      DonutSegment(33, AppColors.chartBlue),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Macro(label: 'Carbs', value: '35%'),
                    _Macro(label: 'Protein', value: '32%'),
                    _Macro(label: 'Fat', value: '33%'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Weekly overview line chart
          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Overview', style: AppTextStyles.cardTitle),
                const SizedBox(height: 12),
                LineChart(
                  values: SampleNutrition.weeklyCalories,
                  xLabels: SampleNutrition.weekLabels,
                  yTicks: const [0, 500, 1000, 1500, 2000, 2500],
                  minY: 0,
                  maxY: 2500,
                  lineColor: AppColors.chartRed,
                  showDots: true,
                  highlightIndex: 3,
                  tooltipTitle: 'Thursday',
                  tooltipValue: '1400',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalColumn(
      String label, String value, Color valueColor, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.statValue.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _Macro extends StatelessWidget {
  final String label;
  final String value;

  const _Macro({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
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
