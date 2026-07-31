import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

/// Row with an optional leading icon, a label and a trailing switch.
/// Shared by Start Activity (Track Route / Heart Rate) and Settings
/// (Dark Mode / Notifications).
class LabeledSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  const LabeledSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.textPrimary, size: 20),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.small.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.accentBlue,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: AppColors.surface,
        ),
      ],
    );
  }
}
