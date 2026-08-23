import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Vertical bar chart with y grid, axis labels and an optional dashed goal
/// line (e.g. weekly steps vs a 10,000 goal).
class BarChart extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final List<double> yTicks;
  final double maxY;
  final Color barColor;
  final double? goalValue;
  final Color goalColor;
  final double height;

  /// Grow-in animation duration. Set to [Duration.zero] to disable.
  final Duration duration;

  const BarChart({
    super.key,
    required this.values,
    required this.xLabels,
    required this.yTicks,
    required this.maxY,
    this.barColor = AppColors.chartBlue,
    this.goalValue,
    this.goalColor = AppColors.chartRed,
    this.height = 210,
    this.duration = const Duration(milliseconds: 850),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context, t, _) => CustomPaint(
          painter: _BarPainter(
            values: values,
            xLabels: xLabels,
            yTicks: yTicks,
            maxY: maxY,
            barColor: barColor,
            goalValue: goalValue,
            goalColor: goalColor,
            t: t,
          ),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> values;
  final List<String> xLabels;
  final List<double> yTicks;
  final double maxY;
  final Color barColor;
  final double? goalValue;
  final Color goalColor;

  /// Grow progress 0..1 — bar heights scale up from the baseline.
  final double t;

  static const double _left = 40;
  static const double _right = 10;
  static const double _top = 12;
  static const double _bottom = 24;

  _BarPainter({
    required this.values,
    required this.xLabels,
    required this.yTicks,
    required this.maxY,
    required this.barColor,
    required this.goalValue,
    required this.goalColor,
    this.t = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(
        _left, _top, size.width - _right, size.height - _bottom);
    double toY(double v) => plot.bottom - (v / maxY) * plot.height;

    final grid = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (final t in yTicks) {
      final y = toY(t);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      _text(canvas, t.toStringAsFixed(0),
          Offset(plot.left - 8, y), color: AppColors.textMuted);
    }

    final n = values.length;
    final slot = plot.width / n;
    final barW = slot * 0.5;
    for (int i = 0; i < n; i++) {
      final cx = plot.left + slot * (i + 0.5);
      final fullTop = toY(values[i]);
      // Grow the bar up from the baseline as t goes 0 -> 1.
      final top = plot.bottom - (plot.bottom - fullTop) * t;
      final barRect =
          Rect.fromLTRB(cx - barW / 2, top, cx + barW / 2, plot.bottom);
      final rrect = RRect.fromRectAndCorners(
        barRect,
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [barColor, barColor.withValues(alpha: 0.65)],
          ).createShader(barRect),
      );
      if (i < xLabels.length) {
        _text(canvas, xLabels[i], Offset(cx, plot.bottom + 6),
            center: true, color: AppColors.textMuted);
      }
    }

    if (goalValue != null) {
      final y = toY(goalValue!);
      final paint = Paint()
        ..color = goalColor
        ..strokeWidth = 2;
      const dash = 7.0, gap = 5.0;
      double x = plot.left;
      while (x < plot.right) {
        canvas.drawLine(
            Offset(x, y), Offset((x + dash).clamp(0, plot.right), y), paint);
        x += dash + gap;
      }
    }
  }

  void _text(Canvas canvas, String s, Offset at,
      {bool center = false, required Color color}) {
    final tp = TextPainter(
      text: TextSpan(
          text: s,
          style: GoogleFonts.montserrat(color: color, fontSize: 9)),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = center ? at.dx - tp.width / 2 : at.dx - tp.width;
    tp.paint(canvas, Offset(dx, at.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_BarPainter old) => old.values != values || old.t != t;
}
