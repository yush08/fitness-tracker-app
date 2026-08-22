import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// When in the day a meal was eaten. Stored as its [name] (`breakfast` …) so
/// the Firestore document stays a plain string map; the icon/colour are derived
/// in the UI rather than persisted.
enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabel on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }
}

/// A single logged meal shown in the Calorie Tracking list.
///
/// Backed by a Firestore document at `users/{uid}/meals/{id}`. Only plain,
/// serialisable fields are stored; [icon] and [iconColor] are computed from
/// [type] so the theme owns those, not the database.
class Meal {
  final String id;
  final String subtitle;
  final int calories;
  final MealType type;
  final DateTime loggedAt;

  /// Optional macronutrient grams. Default 0 when the meal was logged without
  /// them — the nutrition breakdown only counts meals that have macros.
  final int carbsG;
  final int proteinG;
  final int fatG;

  const Meal({
    required this.id,
    required this.subtitle,
    required this.calories,
    required this.type,
    required this.loggedAt,
    this.carbsG = 0,
    this.proteinG = 0,
    this.fatG = 0,
  });

  bool get hasMacros => carbsG > 0 || proteinG > 0 || fatG > 0;

  /// Label shown as the row title (e.g. "Breakfast").
  String get name => type.label;

  IconData get icon {
    switch (type) {
      case MealType.breakfast:
        return Icons.wb_sunny_rounded;
      case MealType.lunch:
        return Icons.wb_sunny_outlined;
      case MealType.dinner:
        return Icons.nightlight_round;
      case MealType.snack:
        return Icons.bakery_dining_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case MealType.breakfast:
        return AppColors.warning;
      case MealType.lunch:
        return const Color(0xFFF97316);
      case MealType.dinner:
        return AppColors.violet;
      case MealType.snack:
        return AppColors.chartGreen;
    }
  }

  factory Meal.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Meal(
      id: doc.id,
      subtitle: data['subtitle'] as String? ?? '',
      calories: (data['calories'] as num?)?.toInt() ?? 0,
      type: MealType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => MealType.snack,
      ),
      loggedAt:
          (data['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      carbsG: (data['carbsG'] as num?)?.toInt() ?? 0,
      proteinG: (data['proteinG'] as num?)?.toInt() ?? 0,
      fatG: (data['fatG'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'subtitle': subtitle,
        'calories': calories,
        'type': type.name,
        'loggedAt': Timestamp.fromDate(loggedAt),
        'carbsG': carbsG,
        'proteinG': proteinG,
        'fatG': fatG,
      };
}
