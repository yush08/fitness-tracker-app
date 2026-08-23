import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Sweeps a soft highlight across its subtree forever — the "content is
/// loading" shimmer. Wrap a tree of [SkeletonBox]es in a single [Shimmer] so
/// they all catch the same moving light, instead of each pulsing on its own.
///
/// One controller drives the whole subtree via a [ShaderMask], so a full
/// skeleton screen costs a single repaint per frame.
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.period = const Duration(milliseconds: 1350),
  });

  final Widget child;
  final Duration period;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Base is the skeleton fill; highlight is a lighter band that travels.
    final base = AppColors.surfaceMuted;
    final highlight = Color.alphaBlend(
      AppColors.textMuted.withValues(alpha: AppColors.isDark ? 0.18 : 0.10),
      base,
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            // Slide a diagonal band of `highlight` from left to right.
            final dx = bounds.width * (t * 2 - 0.5);
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(dx),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Horizontal translation for the shimmer gradient.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

/// A single rounded placeholder rectangle. Colour comes from the enclosing
/// [Shimmer]; here it just needs to be opaque so the shader shows through.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 8,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
