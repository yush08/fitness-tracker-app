import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Single entry point for Cloud Firestore, scoped to the signed-in user.
///
/// Everything the app stores lives under `users/{uid}/…`, so a user can only
/// ever reach their own documents. That layout is enforced for real by
/// `firestore.rules` — this class just keeps the pathing in one place so the
/// repositories never hand-build a collection path (and never accidentally
/// read someone else's `uid`).
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// The current user's id. Repositories are only used from screens behind
  /// [AuthGate], so a null uid here is a genuine bug — surface it loudly rather
  /// than silently writing to a `users/null/…` path.
  String get uid {
    final id = _uid;
    if (id == null) {
      throw StateError('Firestore was accessed while signed out.');
    }
    return id;
  }

  /// True when there is a signed-in user to scope queries to.
  bool get hasUser => _uid != null;

  DocumentReference<Map<String, dynamic>> get userDoc =>
      db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> get meals =>
      userDoc.collection('meals');

  CollectionReference<Map<String, dynamic>> get activities =>
      userDoc.collection('activities');
}
