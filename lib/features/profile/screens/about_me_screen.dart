import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_sub_screen.dart';
import '../../../shared/widgets/dark_card.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  static const _stats = [
    ('Workouts', '128'),
    ('Streak', '14d'),
    ('Level', 'Pro'),
  ];

  static const _skills = [
    'Strength Training',
    'Running',
    'Mobility',
    'Cycling',
    'HIIT',
  ];

  @override
  Widget build(BuildContext context) {
    return AppSubScreen(
      title: 'About Me',
      children: [
        // Hero card
        DarkCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                child: Icon(Icons.person, size: 52, color: AppColors.onAccent),
              ),
              const SizedBox(height: 14),
              Text('Kumar Ayush', style: AppTextStyles.screenTitle),
              const SizedBox(height: 4),
              Text(
                'Fitness enthusiast · Building GoFit',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  for (int i = 0; i < _stats.length; i++) ...[
                    Expanded(child: _stat(_stats[i].$1, _stats[i].$2)),
                    if (i != _stats.length - 1)
                      Container(
                        width: 1,
                        height: 34,
                        color: AppColors.border,
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bio
        DarkCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bio', style: AppTextStyles.cardTitle),
              const SizedBox(height: 10),
              Text(
                "Hey, I'm Ayush — I designed and built GoFit to track my own "
                "training and stay consistent. I love clean data, strong "
                "habits and a good leg day.",
                style: AppTextStyles.small.copyWith(height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Interests
        DarkCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Interests', style: AppTextStyles.cardTitle),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in _skills) _chip(s),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.statValue.copyWith(color: AppColors.accentText),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.small.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
