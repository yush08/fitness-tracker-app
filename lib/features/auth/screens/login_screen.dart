import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../widgets/auth_check_row.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_tab_toggle.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goHome() =>
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);

  static final _emailRegex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  void _signIn() {
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
    if (_emailError == null && _passwordError == null) _goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                AuthTabToggle(
                  activeIndex: 0,
                  onLogin: () {},
                  onSignup: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.signup),
                ),
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
                AuthField(
                  label: 'Email',
                  hint: 'Email *',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),
                const SizedBox(height: 20),
                AuthField(
                  label: 'Password',
                  hint: 'Password *',
                  controller: _password,
                  obscure: true,
                  errorText: _passwordError,
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                ),
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
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.forgotPassword),
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
                Center(
                  child: Text(
                    'or login with',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialLoginButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Google',
                      iconColor: const Color(0xFF4285F4),
                      onTap: _goHome,
                    ),
                    SocialLoginButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      onTap: _goHome,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
