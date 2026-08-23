import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'responsive.dart';

/// A scrollable body with a branded pull-to-refresh gesture and a capped,
/// centred content width (via [MaxWidthBody]). Drop-in replacement for the
/// `SafeArea > SingleChildScrollView` pattern the tab screens shared.
///
/// The screens read live Firestore streams, so the pull is a manual "check
/// again" affordance: [onRefresh] is optional and defaults to a short settle
/// so the accent spinner reads as a real refresh without faking data.
class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 24),
    this.onRefresh,
  });

  final Widget child;
  final EdgeInsets padding;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surfaceMuted,
        displacement: 28,
        onRefresh: onRefresh ??
            () => Future<void>.delayed(const Duration(milliseconds: 650)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          child: MaxWidthBody(child: child),
        ),
      ),
    );
  }
}
