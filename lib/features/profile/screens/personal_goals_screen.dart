import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_sub_screen.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/gradient_button.dart';

class PersonalGoalsScreen extends StatefulWidget {
  const PersonalGoalsScreen({super.key});

  @override
  State<PersonalGoalsScreen> createState() => _PersonalGoalsScreenState();
}

class _PersonalGoalsScreenState extends State<PersonalGoalsScreen> {
  double _steps = 10000;
  double _sleep = 8;
  double _calories = 2000;
  double _water = 8;

  @override
  Widget build(BuildContext context) {
    return AppSubScreen(
      title: 'Personal Goals',
      children: [
        _GoalSlider(
          label: 'Daily Steps',
          value: _steps,
          min: 2000,
          max: 20000,
          divisions: 18,
          display: '${_steps.round()}',
          color: AppColors.accentBlue,
          onChanged: (v) => setState(() => _steps = v),
        ),
        _GoalSlider(
          label: 'Sleep Hours',
          value: _sleep,
          min: 4,
          max: 12,
          divisions: 16,
          display: '${_sleep.toStringAsFixed(1)} h',
          color: AppColors.chartRed,
          onChanged: (v) => setState(() => _sleep = v),
        ),
        _GoalSlider(
          label: 'Calorie Target',
          value: _calories,
          min: 1200,
          max: 3500,
          divisions: 23,
          display: '${_calories.round()} cal',
          color: AppColors.chartYellow,
          onChanged: (v) => setState(() => _calories = v),
        ),
        _GoalSlider(
          label: 'Water Intake',
          value: _water,
          min: 4,
          max: 15,
          divisions: 11,
          display: '${_water.round()} glasses',
          color: AppColors.chartGreen,
          onChanged: (v) => setState(() => _water = v),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: 'Save Goals',
          color: AppColors.accentBlue,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Goals updated')),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final String label;
  final String display;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;

  const _GoalSlider({
    required this.label,
    required this.display,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DarkCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  display,
                  style: AppTextStyles.small.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                inactiveTrackColor: AppColors.surface,
                overlayColor: color.withOpacity(0.15),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
