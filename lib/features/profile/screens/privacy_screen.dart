import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_sub_screen.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/labeled_switch_row.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final Map<String, bool> _options = {
    'Public Profile': true,
    'Show Activity Status': true,
    'Share Location on Activities': false,
    'Show in Leaderboards': true,
    'Personalized Analytics': false,
  };

  @override
  Widget build(BuildContext context) {
    return AppSubScreen(
      title: 'Privacy',
      children: [
        DarkCard(
          child: Column(
            children: [
              for (final entry in _options.entries) ...[
                LabeledSwitchRow(
                  label: entry.key,
                  value: entry.value,
                  onChanged: (v) => setState(() => _options[entry.key] = v),
                ),
                if (entry.key != _options.keys.last)
                  Divider(color: AppColors.border, height: 20),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'You control what other GoFit members can see. These settings apply '
          'across your profile, feed and leaderboards.',
          style: AppTextStyles.caption.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
