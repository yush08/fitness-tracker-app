import 'package:cloud_firestore/cloud_firestore.dart';

/// The daily targets a user sets in Personal Goals. Stored as a nested map on
/// the user document (`users/{uid}.goals`).
class Goals {
  final int dailySteps;
  final int dailyCalories;
  final double sleepHours;
  final int waterGlasses;

  const Goals({
    this.dailySteps = 10000,
    this.dailyCalories = 2000,
    this.sleepHours = 8,
    this.waterGlasses = 8,
  });

  factory Goals.fromMap(Map<String, dynamic>? map) {
    final m = map ?? const <String, dynamic>{};
    const d = Goals();
    return Goals(
      dailySteps: (m['dailySteps'] as num?)?.toInt() ?? d.dailySteps,
      dailyCalories: (m['dailyCalories'] as num?)?.toInt() ?? d.dailyCalories,
      sleepHours: (m['sleepHours'] as num?)?.toDouble() ?? d.sleepHours,
      waterGlasses: (m['waterGlasses'] as num?)?.toInt() ?? d.waterGlasses,
    );
  }

  Map<String, dynamic> toMap() => {
        'dailySteps': dailySteps,
        'dailyCalories': dailyCalories,
        'sleepHours': sleepHours,
        'waterGlasses': waterGlasses,
      };
}

/// The signed-in user's profile document (`users/{uid}`).
///
/// [fromDoc] tolerates a missing/partial document so the UI can render sensible
/// defaults before the doc is first written — the app never blocks on it.
class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final double? targetWeightKg;
  final Goals goals;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.age,
    this.heightCm,
    this.weightKg,
    this.targetWeightKg,
    this.goals = const Goals(),
  });

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      age: (data['age'] as num?)?.toInt(),
      heightCm: (data['heightCm'] as num?)?.toDouble(),
      weightKg: (data['weightKg'] as num?)?.toDouble(),
      targetWeightKg: (data['targetWeightKg'] as num?)?.toDouble(),
      goals: Goals.fromMap(data['goals'] as Map<String, dynamic>?),
    );
  }
}
