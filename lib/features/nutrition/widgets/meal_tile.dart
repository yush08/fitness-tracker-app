import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/meal.dart';

/// A row in the "Today's Meals" list.
class MealTile extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;

  const MealTile({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Shared element: this badge flies up and grows into the header
            // of MealDetailScreen. Tag mirrors MealDetailScreen.heroTag(id).
            Hero(
              tag: 'meal-icon-${meal.id}',
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(meal.icon, color: meal.iconColor, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    meal.subtitle,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Text(
              '${meal.calories} cal',
              style: AppTextStyles.small.copyWith(
                color: AppColors.accentText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
