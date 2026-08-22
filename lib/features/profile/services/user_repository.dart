import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/data/firestore_service.dart';
import '../models/user_profile.dart';

/// Read/write access to the signed-in user's profile document.
class UserRepository {
  UserRepository._();
  static final UserRepository instance = UserRepository._();

  final FirestoreService _svc = FirestoreService.instance;

  /// Live profile stream — drives the Profile tab and anything showing the
  /// name or goals.
  Stream<UserProfile> watchProfile() =>
      _svc.userDoc.snapshots().map(UserProfile.fromDoc);

  /// One-shot read, for forms that load their initial values once.
  Future<UserProfile> getProfile() async =>
      UserProfile.fromDoc(await _svc.userDoc.get());

  /// Creates the profile document on first sign-in if it does not exist yet,
  /// seeding it from the Firebase Auth record and default goals. Safe to call
  /// on every launch — it only writes when the doc is missing.
  Future<void> ensureUserDoc(User user) async {
    final snap = await _svc.userDoc.get();
    if (snap.exists) return;
    await _svc.userDoc.set({
      'displayName': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL,
      'goals': const Goals().toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateGoals(Goals goals) =>
      _svc.userDoc.set({'goals': goals.toMap()}, SetOptions(merge: true));

  /// Merges the given personal-detail fields; nulls are skipped so a partial
  /// edit never wipes other fields.
  Future<void> updateProfile({
    String? displayName,
    int? age,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
  }) {
    final data = <String, dynamic>{
      if (displayName != null) 'displayName': displayName,
      if (age != null) 'age': age,
      if (heightCm != null) 'heightCm': heightCm,
      if (weightKg != null) 'weightKg': weightKg,
      if (targetWeightKg != null) 'targetWeightKg': targetWeightKg,
    };
    if (data.isEmpty) return Future.value();
    return _svc.userDoc.set(data, SetOptions(merge: true));
  }
}
