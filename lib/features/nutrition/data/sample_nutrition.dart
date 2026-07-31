import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/meal.dart';

/// Placeholder content for the nutrition screens (UI preview only).
class SampleNutrition {
  static const int dailyGoal = 2000;
  static const int remaining = 852;

  static const List<Meal> todaysMeals = [
    Meal(
      name: 'Breakfast',
      subtitle: 'Oatmeal with fruits',
      calories: 320,
      icon: Icons.wb_sunny_rounded,
      iconColor: AppColors.warning,
    ),
    Meal(
      name: 'Lunch',
      subtitle: 'Pulao with curd',
      calories: 450,
      icon: Icons.wb_sunny_outlined,
      iconColor: Color(0xFFF97316),
    ),
    Meal(
      name: 'Dinner',
      subtitle: 'Black chana with rice',
      calories: 358,
      icon: Icons.nightlight_round,
      iconColor: AppColors.violet,
    ),
  ];

  // Weekly calorie overview (Mon–Sun).
  static const List<String> weekLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];
  static const List<double> weeklyCalories = [
    1400, 1250, 2050, 1400, 1000, 1450, 1200,
  ];
}
