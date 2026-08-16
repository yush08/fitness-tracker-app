import 'package:flutter/material.dart';

/// Reveals a vertical list of children in a staggered cascade — each fades in
/// and slides up shortly after the one above it. Drop-in replacement for a
/// [Column]: pass the same `children`, `crossAxisAlignment` and `mainAxisSize`.
///
/// Uses a single [AnimationController] with per-child [Interval]s, so it stays
/// cheap even with many children (spacers included). This is the workhorse for
/// the app's "content settles into place" entrance (designspells.com).
class StaggerReveal extends StatefulWidget {
  const StaggerReveal({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.step = const Duration(milliseconds: 70),
    this.itemDuration = const Duration(milliseconds: 460),
    this.startDelay = Duration.zero,
    this.offset = const Offset(0, 0.12),
    this.curve = Curves.easeOutCubic,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  /// Delay between consecutive children starting.
  final Duration step;

  /// How long each individual child animates.
  final Duration itemDuration;
  final Duration startDelay;
  final Offset offset;
  final Curve curve;

  @override
  State<StaggerReveal> createState() => _StaggerRevealState();
}

class _StaggerRevealState extends State<StaggerReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final int _count = widget.children.length;
  late final int _totalMs =
      widget.step.inMilliseconds * (_count > 0 ? _count - 1 : 0) +
          widget.itemDuration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _totalMs),
    );
    if (widget.startDelay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.startDelay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        for (var i = 0; i < _count; i++) _wrap(i, widget.children[i]),
      ],
    );
  }

  Widget _wrap(int i, Widget child) {
    final beginMs = widget.step.inMilliseconds * i;
    final begin = beginMs / _totalMs;
    final end = (beginMs + widget.itemDuration.inMilliseconds) / _totalMs;
    final anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end.clamp(0.0, 1.0), curve: widget.curve),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, c) {
        final t = anim.value;
        return Opacity(
          opacity: t,
          child: FractionalTranslation(
            translation: Offset(
              widget.offset.dx * (1 - t),
              widget.offset.dy * (1 - t),
            ),
            child: c,
          ),
        );
      },
      child: child,
    );
  }
}

/// A one-shot entrance animation: the child fades in while sliding up from a
/// small offset. Plays once when first built.
///
/// Chain several with increasing [delay] values to get the staggered "reveal"
/// cascade seen on polished onboarding flows (designspells.com). Because the
/// animation is driven by a [TweenAnimationBuilder] keyed to a single forward
/// pass, it is safe to use inside `const`-free `StatelessWidget` trees.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 550),
    this.offset = const Offset(0, 0.14),
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;

  /// Wait this long after mount before starting — used to stagger siblings.
  final Duration delay;
  final Duration duration;

  /// Starting translation as a fraction of the child's size. Positive dy
  /// slides up into place, positive dx slides in from the right.
  final Offset offset;
  final Curve curve;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        final t = curved.value;
        return Opacity(
          opacity: t,
          child: FractionalTranslation(
            translation: Offset(
              widget.offset.dx * (1 - t),
              widget.offset.dy * (1 - t),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
