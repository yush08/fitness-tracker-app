import 'package:flutter/material.dart';

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
            child: GestureDetector(
              onTap: onContinue,
              child: Container(
                height: 66,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.yellow.withOpacity(0.5),
                    width: 1,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF8BD00),
                      Color(0xFFFC900D),
                      Color(0xFFFC940B),
                      Color(0xFFFC900D),
                      Color(0xFFF8BD00),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
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
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.55)),
                color: Colors.white.withOpacity(0.20),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }
}
