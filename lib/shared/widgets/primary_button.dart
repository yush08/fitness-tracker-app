import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? trailing;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: AppSizes.primaryButtonHeight,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: AppGradients.primaryButtonGradient,
          borderRadius: BorderRadius.circular(
            AppSizes.primaryButtonRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppTextStyles.button,
            ),

            trailing ??
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}