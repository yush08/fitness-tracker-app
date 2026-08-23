import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/animations/skeletons.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/charts/donut_chart.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../profile/models/user_profile.dart';
import '../../profile/services/user_repository.dart';
import '../models/meal.dart';
import '../services/meal_repository.dart';
import '../widgets/meal_tile.dart';
import 'meal_detail_screen.dart';

class CalorieTrackingScreen extends StatelessWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      child: StaggerReveal(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        step: const Duration(milliseconds: 55),
        children: [
          const AppLogo(),
          const SizedBox(height: 12),
          Text('Calorie tracking', style: AppTextStyles.screenTitle),
          const SizedBox(height: 16),

          // Live goal + meals. Both depend on the user's daily calorie goal,
          // so the goal (profile) stream wraps the meals stream.
          AsyncView<UserProfile>(
            stream: UserRepository.instance.watchProfile(),
            loading: const CalorieSkeleton(),
            builder: (profile) => AsyncView<List<Meal>>(
              stream: MealRepository.instance.todaysMeals(),
              loading: const CalorieSkeleton(),
              builder: (meals) =>
                  _LiveSection(goal: profile.goals.dailyCalories, meals: meals),
            ),
          ),
        ],
      ),
    );
  }
}

/// The live goal card + today's meal list. Recomputes whenever a meal is added
/// or removed, since it is rebuilt by its parent [AsyncView] streams.
class _LiveSection extends StatelessWidget {
  final int goal;
  final List<Meal> meals;

  const _LiveSection({required this.goal, required this.meals});

  @override
  Widget build(BuildContext context) {
    final consumed = meals.fold<int>(0, (sum, m) => sum + m.calories);
    final remaining = (goal - consumed).clamp(0, goal);
    final progress = goal == 0 ? 0.0 : (consumed / goal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Daily goal card
        DarkCard(
          color: AppColors.surfaceMuted,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _goalColumn('Daily Goal', '$goal cal',
                      AppColors.textPrimary, CrossAxisAlignment.start),
                  _goalColumn('Remaining', '$remaining cal',
                      AppColors.accentText, CrossAxisAlignment.end),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.textMuted,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today', style: AppTextStyles.screenTitle),
            _AddButton(onTap: () => _showAddMeal(context)),
          ],
        ),
        const SizedBox(height: 14),

        DarkCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Meals ($consumed cal)",
                  style: AppTextStyles.cardTitle),
              const SizedBox(height: 6),
              if (meals.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text('No meals logged yet. Tap Add to log one.',
                      style: AppTextStyles.caption),
                )
              else
                for (final meal in meals)
                  Dismissible(
                    key: ValueKey(meal.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.delete_outline,
                          color: AppColors.chartRed, size: 22),
                    ),
                    onDismissed: (_) => _deleteWithUndo(context, meal),
                    child: MealTile(
                      meal: meal,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MealDetailScreen(meal: meal),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _breakdownCard(),
      ],
    );
  }

  /// Live macro split from today's meals. Only meals logged with macros count;
  /// until any exist it shows a prompt instead of a fabricated chart.
  Widget _breakdownCard() {
    final carbs = meals.fold<int>(0, (s, m) => s + m.carbsG);
    final protein = meals.fold<int>(0, (s, m) => s + m.proteinG);
    final fat = meals.fold<int>(0, (s, m) => s + m.fatG);
    final total = carbs + protein + fat;
    int pct(int v) => total == 0 ? 0 : ((v / total) * 100).round();

    return DarkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nutrition Breakdown', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          if (total == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Add carbs, protein & fat when logging a meal to see your '
                'macro split here.',
                style: AppTextStyles.caption,
              ),
            )
          else ...[
            Center(
              child: DonutChart(
                segments: [
                  DonutSegment(carbs.toDouble(), AppColors.chartYellow),
                  DonutSegment(protein.toDouble(), AppColors.chartRed),
                  DonutSegment(fat.toDouble(), AppColors.chartBlue),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Macro(label: 'Carbs', value: '${pct(carbs)}%'),
                _Macro(label: 'Protein', value: '${pct(protein)}%'),
                _Macro(label: 'Fat', value: '${pct(fat)}%'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _deleteWithUndo(BuildContext context, Meal meal) {
    MealRepository.instance.deleteMeal(meal.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${meal.name} removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => MealRepository.instance.addMeal(
              type: meal.type,
              subtitle: meal.subtitle,
              calories: meal.calories,
              carbsG: meal.carbsG,
              proteinG: meal.proteinG,
              fatG: meal.fatG,
            ),
          ),
        ),
      );
  }

  Future<void> _showAddMeal(BuildContext context) async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => const _AddMealDialog(),
    );
    if (added == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal logged')),
      );
    }
  }

  Widget _goalColumn(
      String label, String value, Color valueColor, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.statValue.copyWith(color: valueColor)),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: AppColors.onAccent, size: 16),
            const SizedBox(width: 4),
            Text(
              'Add',
              style: AppTextStyles.small.copyWith(
                color: AppColors.onAccent,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for logging a meal — type, a short description, and the calories.
/// Pops `true` once the meal is written so the caller can confirm.
class _AddMealDialog extends StatefulWidget {
  const _AddMealDialog();

  @override
  State<_AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<_AddMealDialog> {
  final _desc = TextEditingController();
  final _calories = TextEditingController();
  final _carbs = TextEditingController();
  final _protein = TextEditingController();
  final _fat = TextEditingController();
  MealType _type = MealType.breakfast;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _desc.dispose();
    _calories.dispose();
    _carbs.dispose();
    _protein.dispose();
    _fat.dispose();
    super.dispose();
  }

  int _grams(TextEditingController c) =>
      int.tryParse(c.text.trim())?.clamp(0, 100000) ?? 0;

  Future<void> _save() async {
    if (_saving) return;
    final calories = int.tryParse(_calories.text.trim());
    if (calories == null || calories <= 0) {
      setState(() => _error = 'Enter a calorie amount.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await MealRepository.instance.addMeal(
        type: _type,
        subtitle: _desc.text.trim().isEmpty ? _type.label : _desc.text.trim(),
        calories: calories,
        carbsG: _grams(_carbs),
        proteinG: _grams(_protein),
        fatG: _grams(_fat),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save. Check your connection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Log a meal', style: AppTextStyles.cardTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final t in MealType.values)
                ChoiceChip(
                  label: Text(t.label),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                  labelStyle: AppTextStyles.small.copyWith(
                    color: _type == t
                        ? AppColors.onAccent
                        : AppColors.textSecondary,
                  ),
                  selectedColor: AppColors.accent,
                  backgroundColor: AppColors.surface,
                  showCheckmark: false,
                ),
            ],
          ),
          const SizedBox(height: 14),
          CustomTextField(
            hint: 'Description (e.g. Oatmeal)',
            controller: _desc,
            dark: true,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hint: 'Calories',
            controller: _calories,
            dark: true,
            keyboardType: TextInputType.number,
            errorText: _error,
          ),
          const SizedBox(height: 12),
          Text('Macros (optional, grams)', style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hint: 'Carbs',
                  controller: _carbs,
                  dark: true,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  hint: 'Protein',
                  controller: _protein,
                  dark: true,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  hint: 'Fat',
                  controller: _fat,
                  dark: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: _saving ? 'Saving…' : 'Add Meal',
            color: AppColors.accent,
            height: 52,
            onPressed: _save,
          ),
        ],
      ),
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
