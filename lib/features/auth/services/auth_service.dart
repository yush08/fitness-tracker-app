import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper around [FirebaseAuth] (plus Google sign-in) so the UI never
/// touches the Firebase SDK directly. Every method either completes or throws
/// an [AuthFailure] with a human-readable [AuthFailure.message] ready to show.
///
/// A single shared instance is exposed as [AuthService.instance]; the screens
/// call into that rather than constructing their own.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Web OAuth client ID from your Firebase project
  /// (Firebase console → Authentication → Sign-in method → Google → Web SDK
  /// configuration → "Web client ID"). Required for native Google sign-in so
  /// the returned ID token is accepted by Firebase. Leave empty to let the
  /// platform default apply (works on iOS via the plist; Android usually needs
  /// this set).
  static const String _googleServerClientId = '';

  /// Emits the current user on every sign-in / sign-out. Drives [AuthGate].
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ---- Email / password -----------------------------------------------------

  Future<User> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    }
  }

  Future<User> signUpWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    }
  }

  /// Attaches a display name to the freshly-created account (used by the
  /// sign-up details step). Safe to call with a null/blank name.
  Future<void> updateDisplayName(String? name) async {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return;
    await _auth.currentUser?.updateDisplayName(trimmed);
  }

  // ---- Google ---------------------------------------------------------------

  bool _googleInitialized = false;

  /// Signs in with Google and bridges the credential into Firebase.
  /// Returns null if the user dismisses the Google account picker.
  Future<User?> signInWithGoogle() async {
    try {
      final google = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await google.initialize(
          serverClientId:
              _googleServerClientId.isEmpty ? null : _googleServerClientId,
        );
        _googleInitialized = true;
      }

      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthFailure('Google did not return an ID token.');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final cred = await _auth.signInWithCredential(credential);
      return cred.user;
    } on GoogleSignInException catch (e) {
      // User cancelling the picker is not an error worth surfacing.
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw AuthFailure('Google sign-in failed. (${e.code.name})');
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    }
  }

  // ---- Session --------------------------------------------------------------

  Future<void> signOut() async {
    // Best-effort Google sign-out so the next Google login re-prompts.
    try {
      if (_googleInitialized) await GoogleSignIn.instance.signOut();
    } catch (_) {/* ignore — Firebase sign-out below is what matters */}
    await _auth.signOut();
  }

  // ---- Error copy -----------------------------------------------------------

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password is too weak (min 6 characters).';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this project.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

/// Carries a ready-to-display message for the UI to show in a snackbar.
class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => message;
}
