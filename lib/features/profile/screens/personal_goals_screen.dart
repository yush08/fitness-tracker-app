import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_sub_screen.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../models/user_profile.dart';
import '../services/user_repository.dart';

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
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final goals = (await UserRepository.instance.getProfile()).goals;
      if (!mounted) return;
      setState(() {
        _steps = goals.dailySteps.toDouble();
        _sleep = goals.sleepHours;
        _calories = goals.dailyCalories.toDouble();
        _water = goals.waterGlasses.toDouble();
      });
    } catch (_) {
      // Keep the defaults if the read fails; the user can still save.
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await UserRepository.instance.updateGoals(Goals(
        dailySteps: _steps.round(),
        sleepHours: _sleep,
        dailyCalories: _calories.round(),
        waterGlasses: _water.round(),
      ));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goals updated')),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Check your connection.')),
      );
    }
  }

  /// Manual entry for a goal — type an exact value instead of dragging.
  Future<void> _editGoal(String label, double current, double min, double max,
      int decimals, ValueChanged<double> onSet) async {
    final result = await showDialog<double>(
      context: context,
      builder: (_) => _GoalEntryDialog(
        label: label,
        current: current,
        min: min,
        max: max,
        decimals: decimals,
      ),
    );
    if (result != null) onSet(result);
  }

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
          onEdit: () => _editGoal('Daily Steps', _steps, 2000, 20000, 0,
              (v) => setState(() => _steps = v)),
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
          onEdit: () => _editGoal('Sleep Hours', _sleep, 4, 12, 1,
              (v) => setState(() => _sleep = v)),
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
          onEdit: () => _editGoal('Calorie Target', _calories, 1200, 3500, 0,
              (v) => setState(() => _calories = v)),
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
          onEdit: () => _editGoal('Water Intake', _water, 4, 15, 0,
              (v) => setState(() => _water = v)),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: _saving ? 'Saving…' : 'Save Goals',
          color: AppColors.accentBlue,
          onPressed: _save,
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
  final VoidCallback onEdit;

  const _GoalSlider({
    required this.label,
    required this.display,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
    required this.onEdit,
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
                Row(
                  children: [
                    Text(
                      display,
                      style: AppTextStyles.small.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Manual entry — type an exact value instead of dragging.
                    GestureDetector(
                      onTap: onEdit,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(Icons.edit_outlined,
                          color: AppColors.textSecondary, size: 16),
                    ),
                  ],
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                inactiveTrackColor: AppColors.surface,
                overlayColor: color.withValues(alpha: 0.15),
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

/// Number-entry dialog for a goal, clamped to [min]..[max]. Supports one
/// decimal place (for Sleep Hours) via [decimals].
class _GoalEntryDialog extends StatefulWidget {
  final String label;
  final double current;
  final double min;
  final double max;
  final int decimals;

  const _GoalEntryDialog({
    required this.label,
    required this.current,
    required this.min,
    required this.max,
    required this.decimals,
  });

  @override
  State<_GoalEntryDialog> createState() => _GoalEntryDialogState();
}

class _GoalEntryDialogState extends State<_GoalEntryDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.current.toStringAsFixed(widget.decimals),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = double.tryParse(_controller.text.trim());
    if (parsed == null) {
      setState(() => _error = 'Enter a number');
      return;
    }
    if (parsed < widget.min || parsed > widget.max) {
      setState(() => _error =
          'Must be ${widget.min.toStringAsFixed(widget.decimals)}'
          '–${widget.max.toStringAsFixed(widget.decimals)}');
      return;
    }
    // Snap to the field's precision so it lines up with the slider steps.
    final factor = widget.decimals == 0 ? 1 : 10;
    final snapped = (parsed * factor).round() / factor;
    Navigator.pop(context, snapped.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Edit ${widget.label}', style: AppTextStyles.cardTitle),
      content: CustomTextField(
        hint: '${widget.min.toStringAsFixed(widget.decimals)}'
            '–${widget.max.toStringAsFixed(widget.decimals)}',
        controller: _controller,
        dark: true,
        keyboardType: TextInputType.numberWithOptions(
            decimal: widget.decimals > 0),
        errorText: _error,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style:
                  AppTextStyles.small.copyWith(color: AppColors.textSecondary)),
        ),
        TextButton(
          onPressed: _submit,
          child: Text('Set',
              style: AppTextStyles.small.copyWith(
                  color: AppColors.accentText, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
