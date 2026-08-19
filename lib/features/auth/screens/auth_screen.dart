import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../services/auth_service.dart';
import '../widgets/auth_check_row.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_tab_toggle.dart';
import '../widgets/social_login_button.dart';

/// Combined Log In / Sign Up screen.
///
/// Login and sign-up used to be two separate routes, so tapping the toggle
/// pushed a whole new page. Here they live in one screen: the toggle flips
/// [_index] in place and the form body cross-slides between the two panels via
/// an [AnimatedSwitcher] — it reads as switching tabs, not navigating away.
/// The email/password controllers are shared, so anything typed survives a flip.
class AuthScreen extends StatefulWidget {
  /// 0 = Log In, 1 = Sign Up.
  final int initialIndex;

  const AuthScreen({super.key, this.initialIndex = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late int _index = widget.initialIndex;

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;
  bool _busy = false;
  String? _emailError;
  String? _passwordError;

  static final _emailRegex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (_index == index) return;
    HapticFeedback.selectionClick();
    FocusScope.of(context).unfocus();
    setState(() {
      _index = index;
      // Clear stale validation so the incoming panel starts clean.
      _emailError = null;
      _passwordError = null;
    });
  }

  /// Runs the shared email/password validation; returns true when both pass.
  bool _validate() {
    final email = _email.text.trim();
    final password = _password.text;
    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required'
          : (!_emailRegex.hasMatch(email) ? 'Enter a valid email' : null);
      _passwordError = password.isEmpty
          ? 'Password is required'
          : (password.length < 6 ? 'Minimum 6 characters' : null);
    });
    return _emailError == null && _passwordError == null;
  }

  void _goHome() =>
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Runs [action] with the busy flag set so the form locks and the loading
  /// overlay shows, surfacing any [AuthFailure] as a snackbar.
  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on AuthFailure catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _signIn() {
    if (!_validate()) return;
    _run(() async {
      await AuthService.instance
          .signInWithEmail(_email.text, _password.text);
      // The AuthGate reacts to the session too, but pushing here gives an
      // immediate transition instead of waiting for the stream tick.
      if (mounted) _goHome();
    });
  }

  void _signUp() {
    if (!_validate()) return;
    _run(() async {
      await AuthService.instance
          .signUpWithEmail(_email.text, _password.text);
      if (mounted) Navigator.pushNamed(context, AppRoutes.signupDetails);
    });
  }

  void _googleSignIn() {
    _run(() async {
      final user = await AuthService.instance.signInWithGoogle();
      if (user != null && mounted) _goHome();
    });
  }

  void _appleSignIn() {
    // Sign in with Apple needs an Apple Developer account and platform
    // entitlements that aren't wired up yet; surface that instead of a
    // silent no-op.
    _showError('Apple sign-in isn\'t set up yet.');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Dark background → light status-bar icons.
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
      body: Stack(
        children: [
          Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(gradient: AppGradients.authBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: StaggerReveal(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTabToggle(activeIndex: _index, onSelect: _select),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Welcome',
                    style: GoogleFonts.montserrat(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // The panel that swaps as the tab flips.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 340),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ...previousChildren,
                      ?currentChild,
                    ],
                  ),
                  transitionBuilder: (child, animation) {
                    // Each panel is tied to its own side: the Log In panel
                    // enters/exits left, Sign Up enters/exits right. Because
                    // AnimatedSwitcher runs the outgoing child's animation in
                    // reverse, this yields correct directional motion both ways.
                    final isLogin =
                        child.key == const ValueKey(0);
                    final begin = Offset(isLogin ? -0.18 : 0.18, 0);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: begin, end: Offset.zero)
                            .animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _index == 0
                      ? _loginPanel(const ValueKey(0))
                      : _signupPanel(const ValueKey(1)),
                ),
              ],
            ),
          ),
        ),
      ),
          // Locks the form and shows a spinner while an auth call is in flight.
          if (_busy)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x88000000),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }

  // ---- Panels ---------------------------------------------------------------

  Widget _loginPanel(Key key) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _emailField(),
        const SizedBox(height: 20),
        _passwordField(obscure: true),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AuthCheckRow(
              value: _rememberMe,
              label: 'Remember Me',
              onChanged: (v) => setState(() => _rememberMe = v),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.forgotPassword),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9C8BF5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        GradientButton(
          label: 'Sign In',
          onPressed: _signIn,
          gradient: AppGradients.primaryButtonGradient,
        ),
        const SizedBox(height: 26),
        _dividerLabel('or login with'),
        const SizedBox(height: 22),
        _socialRow(onGoogle: _googleSignIn, onApple: _appleSignIn),
      ],
    );
  }

  Widget _signupPanel(Key key) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _emailField(),
        const SizedBox(height: 20),
        _passwordField(obscure: !_showPassword),
        const SizedBox(height: 12),
        AuthCheckRow(
          value: _showPassword,
          label: 'Show Password',
          onChanged: (v) => setState(() => _showPassword = v),
        ),
        const SizedBox(height: 28),
        GradientButton(
          label: 'Sign Up',
          onPressed: _signUp,
          gradient: AppGradients.primaryButtonGradient,
        ),
        const SizedBox(height: 26),
        _dividerLabel('or sign up with'),
        const SizedBox(height: 22),
        _socialRow(onGoogle: _googleSignIn, onApple: _appleSignIn),
      ],
    );
  }

  // ---- Shared pieces --------------------------------------------------------

  Widget _emailField() => AuthField(
        label: 'Email',
        hint: 'Email *',
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        errorText: _emailError,
        onChanged: (_) {
          if (_emailError != null) setState(() => _emailError = null);
        },
      );

  Widget _passwordField({required bool obscure}) => AuthField(
        label: 'Password',
        hint: 'Password *',
        controller: _password,
        obscure: obscure,
        errorText: _passwordError,
        onChanged: (_) {
          if (_passwordError != null) setState(() => _passwordError = null);
        },
      );

  Widget _dividerLabel(String text) => Center(
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );

  Widget _socialRow({
    required VoidCallback onGoogle,
    required VoidCallback onApple,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SocialLoginButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            iconColor: const Color(0xFF4285F4),
            onTap: onGoogle,
          ),
          SocialLoginButton(
            icon: Icons.apple,
            label: 'Apple',
            onTap: onApple,
          ),
        ],
      );
}
