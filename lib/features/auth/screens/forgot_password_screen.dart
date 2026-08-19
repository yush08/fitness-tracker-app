import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../services/auth_service.dart';
import '../widgets/auth_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  String? _emailError;

  static final _emailRegex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _sendLink() async {
    final email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required'
          : (!_emailRegex.hasMatch(email) ? 'Enter a valid email' : null);
    });
    if (_emailError != null || _busy) return;

    setState(() => _busy = true);
    try {
      await AuthService.instance.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent')),
      );
      Navigator.pop(context);
    } on AuthFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            child: StaggerReveal(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  'Reset Password',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the email linked to your account and we\'ll send '
                  'you a link to reset your password.',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 32),
                AuthField(
                  label: 'Email',
                  hint: 'Email *',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: 'Send Reset Link',
                  onPressed: _sendLink,
                  gradient: AppGradients.primaryButtonGradient,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
