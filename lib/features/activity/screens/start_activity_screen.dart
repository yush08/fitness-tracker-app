import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/labeled_switch_row.dart';
import '../services/activity_repository.dart';
import '../widgets/activity_type_tile.dart';

class StartActivityScreen extends StatefulWidget {
  const StartActivityScreen({super.key});

  @override
  State<StartActivityScreen> createState() => _StartActivityScreenState();
}

class _StartActivityScreenState extends State<StartActivityScreen> {
  final _name = TextEditingController();
  final _distance = TextEditingController();
  final _duration = TextEditingController();
  int _selectedType = 1; // Running
  bool _trackRoute = true;
  bool _heartRate = false;
  bool _saving = false;

  static const _types = [
    (Icons.directions_walk, 'Walking'),
    (Icons.directions_run, 'Running'),
    (Icons.directions_bike, 'Cycling'),
    (Icons.fitness_center, 'Workout'),
    (Icons.pool, 'Swimming'),
    (Icons.more_horiz, 'Other'),
  ];

  @override
  void dispose() {
    _name.dispose();
    _distance.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final type = _types[_selectedType].$2;
    final title = _name.text.trim().isEmpty ? type : _name.text.trim();
    final distanceKm = double.tryParse(_distance.text.trim()) ?? 0;
    final durationSec = ((double.tryParse(_duration.text.trim()) ?? 0) * 60).round();

    setState(() => _saving = true);
    try {
      await ActivityRepository.instance.logActivity(
        title: title,
        type: type,
        distanceKm: distanceKm,
        durationSec: durationSec,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$type logged')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const AppLogo(),
            const SizedBox(height: 14),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back,
                      color: AppColors.textPrimary, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Start Activity',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),

            DarkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity Name', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 14),
                  CustomTextField(
                    hint: 'Enter Activity Name',
                    controller: _name,
                    dark: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: 'Distance (km)',
                          controller: _distance,
                          dark: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hint: 'Duration (min)',
                          controller: _duration,
                          dark: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            DarkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity Type', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _types.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, i) => ActivityTypeTile(
                      icon: _types[i].$1,
                      label: _types[i].$2,
                      selected: _selectedType == i,
                      onTap: () => setState(() => _selectedType = i),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            DarkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Additional Options', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  LabeledSwitchRow(
                    icon: Icons.location_on_outlined,
                    label: 'Track Route',
                    value: _trackRoute,
                    onChanged: (v) => setState(() => _trackRoute = v),
                  ),
                  LabeledSwitchRow(
                    icon: Icons.favorite_border,
                    label: 'Heart Rate',
                    value: _heartRate,
                    onChanged: (v) => setState(() => _heartRate = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            GradientButton(
              label: _saving ? 'Saving…' : 'Start Activity',
              color: AppColors.accentBlue,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
