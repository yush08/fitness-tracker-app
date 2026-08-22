import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/data/firestore_service.dart';
import '../models/meal.dart';

/// Read/write access to the signed-in user's logged meals.
///
/// Everything is a live [Stream] off Firestore, so a meal logged on one screen
/// shows up on Home and Calorie Tracking the instant it is written — no manual
/// refresh, no passing data around.
class MealRepository {
  MealRepository._();
  static final MealRepository instance = MealRepository._();

  final FirestoreService _svc = FirestoreService.instance;

  /// Meals logged since local midnight, oldest first.
  ///
  /// A range filter plus an order on the same field (`loggedAt`) needs no
  /// composite index, so this works against a fresh Firestore project.
  Stream<List<Meal>> todaysMeals() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return _svc.meals
        .where('loggedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('loggedAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('loggedAt')
        .snapshots()
        .map((snap) => snap.docs.map(Meal.fromDoc).toList());
  }

  Future<void> addMeal({
    required MealType type,
    required String subtitle,
    required int calories,
    int carbsG = 0,
    int proteinG = 0,
    int fatG = 0,
  }) {
    final meal = Meal(
      id: '',
      subtitle: subtitle,
      calories: calories,
      type: type,
      loggedAt: DateTime.now(),
      carbsG: carbsG,
      proteinG: proteinG,
      fatG: fatG,
    );
    return _svc.meals.add(meal.toMap());
  }

  Future<void> deleteMeal(String id) => _svc.meals.doc(id).delete();
}
