import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/stat_progress_bar.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  static const _ingredients = [
    ('Poha', 'Rich in fiber'),
    ('Peanuts', 'Healthy fats & protein'),
    ('Onion', 'Antioxidants'),
    ('Curry leaves', 'Iron & vitamin A'),
  ];
  int _ingredient = 0;

  void _cycle(int delta) => setState(() => _ingredient =
      (_ingredient + delta + _ingredients.length) % _ingredients.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            CustomTextField(
              hint: 'Poha',
              dark: true,
              pill: true,
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),

            // Title row
            Row(
              children: [
                _circleButton(Icons.arrow_back, () => Navigator.pop(context)),
                Expanded(
                  child: Text(
                    'Details',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 20),
                  ),
                ),
                _circleButton(
                  Icons.more_horiz,
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to your log')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Food summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF6C445), Color(0xFFE38A1B)],
                    ),
                  ),
                  child: const Icon(Icons.rice_bowl,
                      color: Colors.white, size: 34),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Poha', style: AppTextStyles.cardTitle),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('340 cal', style: AppTextStyles.small),
                          Text('100 gm', style: AppTextStyles.small),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: const [
                          _Tag('Rich in proteins', AppColors.chartGreen),
                          _Tag('Rich in Anti Oxidants', AppColors.chartBlue),
                          _Tag('Rich in B vitamins', AppColors.chartYellow),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            Text('Nutrition Values', style: AppTextStyles.cardTitle),
            const SizedBox(height: 18),
            ..._nutrition.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StatProgressBar(
                    label: n.label,
                    valueText: '${n.grams} g',
                    valueColor: AppColors.textSecondary,
                    progress: n.progress,
                    fillColor: n.color,
                  ),
                )),
            const SizedBox(height: 10),

            Text('Ingredients Identified', style: AppTextStyles.cardTitle),
            const SizedBox(height: 16),
            Row(
              children: [
                _circleButton(Icons.chevron_left, () => _cycle(-1), size: 30),
                const SizedBox(width: 8),
                Expanded(
                  child: DarkCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE9D8A6), Color(0xFFCDB278)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_ingredients[_ingredient].$1,
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                )),
                            Text(_ingredients[_ingredient].$2,
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _circleButton(Icons.chevron_right, () => _cycle(1), size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {double size = 44}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: size * 0.5),
      ),
    );
  }

  static const List<_Nutrient> _nutrition = [
    _Nutrient('Protein', 12, 0.4, AppColors.chartGreen),
    _Nutrient('Fats', 10, 0.42, AppColors.chartRed),
    _Nutrient('Fibers', 5, 0.55, AppColors.chartBlue),
    _Nutrient('Sugar', 16, 0.3, AppColors.chartYellow),
    _Nutrient('Vitamins', 17, 0.72, AppColors.chartRed),
    _Nutrient('Carbohydrates', 56, 0.55, AppColors.chartBlue),
  ];
}

class _Nutrient {
  final String label;
  final int grams;
  final double progress;
  final Color color;
  const _Nutrient(this.label, this.grams, this.progress, this.color);
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
