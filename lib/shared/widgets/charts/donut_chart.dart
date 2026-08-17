import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One slice of a [DonutChart].
class DonutSegment {
  final double value;
  final Color color;
  const DonutSegment(this.value, this.color);
}

/// Segmented donut chart (e.g. macro nutrition breakdown).
class DonutChart extends StatelessWidget {
  final List<DonutSegment> segments;
  final double size;
  final double strokeWidth;
  final double gapDegrees;
  final Widget? center;

  /// Sweep-in animation duration. Set to [Duration.zero] to disable.
  final Duration duration;

  const DonutChart({
    super.key,
    required this.segments,
    this.size = 150,
    this.strokeWidth = 26,
    this.gapDegrees = 6,
    this.center,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => CustomPaint(
          painter: _DonutPainter(
            segments: segments,
            strokeWidth: strokeWidth,
            gapDegrees: gapDegrees,
            t: t,
          ),
          child: child,
        ),
        child: Center(child: center),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;
  final double gapDegrees;

  /// Reveal progress 0..1 — arcs sweep clockwise from the top as it grows.
  final double t;

  _DonutPainter({
    required this.segments,
    required this.strokeWidth,
    required this.gapDegrees,
    this.t = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<double>(0, (s, e) => s + e.value);
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gap = gapDegrees * math.pi / 180;

    double start = -math.pi / 2 + gap / 2;
    for (final seg in segments) {
      final sweep = (seg.value / total) * 2 * math.pi - gap;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = seg.color;
      canvas.drawArc(rect, start, sweep * t, false, paint);
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.segments != segments || old.strokeWidth != strokeWidth || old.t != t;
}
