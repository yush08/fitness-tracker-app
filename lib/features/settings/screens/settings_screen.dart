import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/dropdown_chip.dart';
import '../../../shared/widgets/labeled_switch_row.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  String _distanceUnit = 'Kilometers';
  String _weightUnit = 'Kilograms';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: StaggerReveal(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        step: const Duration(milliseconds: 60),
        children: [
          const AppLogo(),
          const SizedBox(height: 12),
          Text('Settings', style: AppTextStyles.screenTitle),
          const SizedBox(height: 18),

          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Settings', style: AppTextStyles.cardTitle),
                const SizedBox(height: 12),
                LabeledSwitchRow(
                  label: 'Dark Mode',
                  value: ThemeController.isDark,
                  onChanged: (v) => setState(() => ThemeController.setDark(v)),
                ),
                LabeledSwitchRow(
                  label: 'Notifications',
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Units', style: AppTextStyles.cardTitle),
                const SizedBox(height: 16),
                _unitRow(
                  'Distance',
                  _distanceUnit,
                  const ['Kilometers', 'Miles'],
                  (v) => setState(() => _distanceUnit = v),
                ),
                const SizedBox(height: 14),
                _unitRow(
                  'Weight',
                  _weightUnit,
                  const ['Kilograms', 'Pounds'],
                  (v) => setState(() => _weightUnit = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About', style: AppTextStyles.cardTitle),
                const SizedBox(height: 12),
                Text('Version 2.1.0', style: AppTextStyles.caption),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.copyright,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text('2025 GoFit', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _unitRow(String label, String value, List<String> options,
      ValueChanged<String> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.small.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        DropdownChip(value: value, options: options, onSelected: onChanged),
      ],
    );
  }
}
