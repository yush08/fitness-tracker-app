import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/animations/pressable.dart';
import '../../../shared/widgets/clay.dart';

/// Shared bottom action row for the onboarding flow:
/// a gradient "continue" pill plus a circular profile button.
/// Keeps the three onboarding screens visually identical.
class OnboardingBottomBar extends StatelessWidget {
  final String label;
  final VoidCallback onContinue;
  final VoidCallback? onProfile;

  const OnboardingBottomBar({
    super.key,
    required this.label,
    required this.onContinue,
    this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
      child: Row(
        children: [
          Expanded(
            child: Pressable(
              onTap: onContinue,
              child: Container(
                height: 66,
                decoration: Clay.decoration(AppColors.accent, radius: 36),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const ClayGloss(radius: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.keyboard_double_arrow_right,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Pressable(
            onTap: onProfile,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.38),
                    Colors.white.withOpacity(0.18),
                  ],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.55)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: -4,
                    offset: const Offset(-5, -5),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }
}
