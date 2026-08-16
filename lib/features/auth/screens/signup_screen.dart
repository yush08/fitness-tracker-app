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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
                  activeIndex: 1,
                  onLogin: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.login),
                  onSignup: () {},
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
                ),
                const SizedBox(height: 20),
                AuthField(
                  label: 'Password',
                  hint: 'Password *',
                  controller: _password,
                  obscure: !_showPassword,
                ),
                const SizedBox(height: 12),
                AuthCheckRow(
                  value: _showPassword,
                  label: 'Show Password',
                  onChanged: (v) => setState(() => _showPassword = v),
                ),
                const SizedBox(height: 28),
                GradientButton(
                  label: 'Sign Up',
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.signupDetails),
                  gradient: AppGradients.primaryButtonGradient,
                ),
                const SizedBox(height: 26),
                Center(
                  child: Text(
                    'or sign up with',
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
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.signupDetails),
                    ),
                    SocialLoginButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.signupDetails),
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
