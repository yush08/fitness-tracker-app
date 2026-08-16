import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wraps a tappable element so it springs down slightly while pressed and
/// eases back on release — the tactile "squish" used on well-crafted buttons
/// (designspells.com). Keeps all existing hit behaviour; just add feedback.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.94,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Scale factor while the finger is down. Lower = deeper squish.
  final double scale;
  final Duration duration;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Gently bobs its child up and down forever — for decorative, "floating"
/// cards and badges. Subtle by default so it reads as life, not motion sickness.
class Floating extends StatefulWidget {
  const Floating({
    super.key,
    required this.child,
    this.amplitude = 6,
    this.period = const Duration(seconds: 3),
    this.phase = 0,
  });

  final Widget child;

  /// Peak vertical travel in logical pixels.
  final double amplitude;
  final Duration period;

  /// 0..1 offset into the cycle, so multiple floats don't bob in lockstep.
  final double phase;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating>
    with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = (_controller.value + widget.phase) * 2 * math.pi;
        return Transform.translate(
          offset: Offset(0, widget.amplitude * math.sin(t)),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
