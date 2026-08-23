import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import '../../../shared/widgets/stat_progress_bar.dart';
import '../models/meal.dart';

/// Detail view for a single logged meal. Every value here comes straight off
/// the [Meal] document — calories, macros and time logged — so it's an honest
/// expansion of the list row, not a mock.
///
/// The leading icon carries the same [Hero] tag as the row's icon, so tapping
/// a meal makes its badge fly up and grow into the header.
class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key, required this.meal});

  final Meal meal;

  /// Shared tag so the tile icon and this header animate as one element.
  static String heroTag(String id) => 'meal-icon-$id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PullToRefresh(
        onRefresh: () async {}, // nothing to refetch; keep the gesture consistent
        child: StaggerReveal(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          step: const Duration(milliseconds: 55),
          children: [
            Row(
              children: [
                _circleButton(
                  context,
                  Icons.arrow_back,
                  () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Meal details',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
            const SizedBox(height: 24),

            // Header: hero icon + name + logged time.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: heroTag(meal.id),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(meal.icon, color: meal.iconColor, size: 34),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meal.name, style: AppTextStyles.screenTitle),
                      const SizedBox(height: 4),
                      Text(meal.subtitle, style: AppTextStyles.caption),
                      const SizedBox(height: 6),
                      Text(_loggedLabel(meal.loggedAt),
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Calories headline card.
            DarkCard(
              color: AppColors.surfaceMuted,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Calories', style: AppTextStyles.cardTitle),
                  Text('${meal.calories} cal',
                      style: AppTextStyles.statValue
                          .copyWith(color: AppColors.accentText)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Macronutrients', style: AppTextStyles.cardTitle),
            const SizedBox(height: 16),
            if (!meal.hasMacros)
              Text(
                'No macros were logged for this meal.',
                style: AppTextStyles.caption,
              )
            else ...[
              for (final m in _macros(meal))
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StatProgressBar(
                    label: m.label,
                    valueText: '${m.grams} g',
                    valueColor: AppColors.textSecondary,
                    progress: m.fraction,
                    fillColor: m.color,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  List<_MacroRow> _macros(Meal meal) {
    final total = (meal.carbsG + meal.proteinG + meal.fatG).clamp(1, 1 << 30);
    return [
      _MacroRow('Carbs', meal.carbsG, meal.carbsG / total, AppColors.chartYellow),
      _MacroRow('Protein', meal.proteinG, meal.proteinG / total, AppColors.chartRed),
      _MacroRow('Fat', meal.fatG, meal.fatG / total, AppColors.chartBlue),
    ];
  }

  static String _loggedLabel(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour < 12 ? 'AM' : 'PM';
    return 'Logged at $h:$m $ampm';
  }

  Widget _circleButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}

class _MacroRow {
  final String label;
  final int grams;
  final double fraction;
  final Color color;
  const _MacroRow(this.label, this.grams, this.fraction, this.color);
}
