import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goHome() =>
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(gradient: AppGradients.authBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
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
                    'Welcome back',
                    style: GoogleFonts.montserrat(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AuthField(
                  label: 'Email',
                  hint: 'Email *',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                AuthField(
                  label: 'Password',
                  hint: 'Password *',
                  controller: _password,
                  obscure: true,
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
                          color: const Color(0xFFEA6D0A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                GradientButton(
                  label: 'Sign In',
                  onPressed: _goHome,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF8BD00), Color(0xFFFB7A05)],
                  ),
                ),
                const SizedBox(height: 26),
                Center(
                  child: Text(
                    'or login with',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
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
