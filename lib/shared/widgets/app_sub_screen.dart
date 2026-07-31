import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

/// Standard scaffold for a pushed detail page: a back button, a title and
/// an optional trailing action, above a scrolling body. Theme-aware.
class AppSubScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? action;

  const AppSubScreen({
    super.key,
    required this.title,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.arrow_back,
                      color: AppColors.textPrimary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(title, style: AppTextStyles.screenTitle),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 22),
            ...children,
          ],
        ),
      ),
    );
  }
}
