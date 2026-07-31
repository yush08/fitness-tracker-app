import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/dark_card.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  static const _fields = [
    ('Full Name', 'Kumar Ayush'),
    ('Email', 'ayush@example.com'),
    ('Age', '20'),
    ('Height', '160 cm'),
    ('Weight', '66 kg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back,
                      color: AppColors.textPrimary, size: 22),
                ),
                const SizedBox(width: 12),
                const AppLogo(fontSize: 22),
              ],
            ),
            const SizedBox(height: 18),
            DarkCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Personal Details',
                          style: AppTextStyles.cardTitle),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Editing enabled')),
                        ),
                        child: Text(
                          'Edit',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.accentText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(child: _avatar()),
                  const SizedBox(height: 24),
                  for (final f in _fields) ...[
                    _DetailField(label: f.$1, value: f.$2),
                    const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: AppColors.surface,
            child:
                Icon(Icons.person, size: 46, color: AppColors.textSecondary),
          ),
          Positioned(
            right: 0,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt,
                  color: AppColors.onAccent, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;

  const _DetailField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.small.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: AppTextStyles.small),
              Icon(Icons.chevron_right,
                  color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
