import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Smooth (Catmull-Rom) line chart with y grid lines, axis labels and an
/// optional highlighted point + tooltip. Pure CustomPainter, no packages.
class LineChart extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final List<double> yTicks;
  final double minY;
  final double maxY;
  final Color lineColor;
  final bool showDots;
  final int? highlightIndex;
  final String? tooltipTitle;
  final String? tooltipValue;
  final double height;

  /// Line-draw animation duration. Set to [Duration.zero] to disable.
  final Duration duration;

  const LineChart({
    super.key,
    required this.values,
    required this.xLabels,
    required this.yTicks,
    required this.minY,
    required this.maxY,
    this.lineColor = AppColors.chartRed,
    this.showDots = false,
    this.highlightIndex,
    this.tooltipTitle,
    this.tooltipValue,
    this.height = 190,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: Curves.easeInOutCubic,
        builder: (context, t, _) => CustomPaint(
          painter: _LinePainter(
            values: values,
            xLabels: xLabels,
            yTicks: yTicks,
            minY: minY,
            maxY: maxY,
            lineColor: lineColor,
            showDots: showDots,
            highlightIndex: highlightIndex,
            tooltipTitle: tooltipTitle,
            tooltipValue: tooltipValue,
            t: t,
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  final List<String> xLabels;
  final List<double> yTicks;
  final double minY;
  final double maxY;
  final Color lineColor;
  final bool showDots;
  final int? highlightIndex;
  final String? tooltipTitle;
  final String? tooltipValue;

  /// Draw progress 0..1 — the line traces out and dots/tooltip fade in at the end.
  final double t;

  static const double _left = 36;
  static const double _right = 10;
  static const double _top = 12;
  static const double _bottom = 24;

  _LinePainter({
    required this.values,
    required this.xLabels,
    required this.yTicks,
    required this.minY,
    required this.maxY,
    required this.lineColor,
    required this.showDots,
    this.highlightIndex,
    this.tooltipTitle,
    this.tooltipValue,
    this.t = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(
      _left,
      _top,
      size.width - _right,
      size.height - _bottom,
    );
    final span = (maxY - minY) == 0 ? 1 : (maxY - minY);

    double toX(int i) => plot.left + (i / (values.length - 1)) * plot.width;
    double toY(double v) =>
        plot.bottom - ((v - minY) / span) * plot.height;

    // Grid lines + y labels.
    final grid = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (final t in yTicks) {
      final y = toY(t);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      _text(canvas, t.toStringAsFixed(0), Offset(plot.left - 8, y),
          align: _Align.right, color: AppColors.textMuted, size: 9);
    }

    // x labels spread evenly across the plot.
    for (int i = 0; i < xLabels.length; i++) {
      final x = plot.left +
          (xLabels.length == 1 ? 0 : i / (xLabels.length - 1)) * plot.width;
      _text(canvas, xLabels[i], Offset(x, plot.bottom + 6),
          align: _Align.center, color: AppColors.textMuted, size: 9);
    }

    if (values.length < 2) return;

    // Build smooth path.
    final pts = [
      for (int i = 0; i < values.length; i++) Offset(toX(i), toY(values[i]))
    ];
    final path = _smoothPath(pts);

    // Trace the line out: extract just the first `t` fraction of its length.
    final drawPath = t >= 1 ? path : _trim(path, t);
    canvas.drawPath(
      drawPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = lineColor,
    );

    // Overlays (dots, highlight, tooltip) fade in once the trace is nearly done.
    final overlay = ((t - 0.7) / 0.3).clamp(0.0, 1.0);
    if (overlay <= 0) return;

    if (showDots) {
      final dot = Paint()..color = lineColor.withValues(alpha: overlay);
      for (final p in pts) {
        canvas.drawCircle(p, 3.2, dot);
      }
    }

    // Highlight + tooltip.
    if (highlightIndex != null &&
        highlightIndex! >= 0 &&
        highlightIndex! < pts.length) {
      final p = pts[highlightIndex!];
      _dashedLine(canvas, Offset(p.dx, plot.top), Offset(p.dx, plot.bottom),
          AppColors.textSecondary);
      canvas.drawCircle(p, 5, Paint()..color = lineColor);
      canvas.drawCircle(
          p, 5, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white);
      if (tooltipTitle != null) {
        _tooltip(canvas, p, plot);
      }
    }
  }

  /// Returns the first [fraction] (0..1) of [path] by arc length.
  Path _trim(Path path, double fraction) {
    final out = Path();
    for (final metric in path.computeMetrics()) {
      out.addPath(
        metric.extractPath(0, metric.length * fraction.clamp(0.0, 1.0)),
        Offset.zero,
      );
    }
    return out;
  }

  Path _smoothPath(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = i == 0 ? pts[i] : pts[i - 1];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = i + 2 < pts.length ? pts[i + 2] : p2;
      final cp1 = Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
      final cp2 = Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    const dash = 5.0, gap = 4.0;
    final total = (b - a).distance;
    final dir = (b - a) / total;
    double d = 0;
    while (d < total) {
      final start = a + dir * d;
      final end = a + dir * (d + dash).clamp(0, total);
      canvas.drawLine(start, end, paint);
      d += dash + gap;
    }
  }

  void _tooltip(Canvas canvas, Offset p, Rect plot) {
    final title = _painter(tooltipTitle!, Colors.white, 11, FontWeight.w600);
    final legendDot = 12.0;
    final value = _painter(tooltipValue ?? '', Colors.white, 11, FontWeight.w400);
    final labelValue = _painter('Calories', AppColors.textSecondary, 11, FontWeight.w400);

    final w = 24 + legendDot + labelValue.width + 12 + value.width;
    final h = 44.0;
    var left = p.dx - w / 2;
    left = left.clamp(plot.left, plot.right - w);
    var top = p.dy - h - 14;
    if (top < plot.top) top = p.dy + 14;
    final rect = Rect.fromLTWH(left, top, w, h);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()..color = AppColors.surfaceMuted,
    );
    title.paint(canvas, Offset(left + 12, top + 8));
    final rowY = top + 24;
    canvas.drawCircle(
        Offset(left + 12 + 4, rowY + 6), 4, Paint()..color = lineColor);
    labelValue.paint(canvas, Offset(left + 12 + legendDot + 6, rowY));
    value.paint(canvas, Offset(rect.right - value.width - 12, rowY));
  }

  TextPainter _painter(String s, Color c, double size, FontWeight w) {
    final tp = TextPainter(
      text: TextSpan(
          text: s,
          style: GoogleFonts.montserrat(color: c, fontSize: size, fontWeight: w)),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp;
  }

  void _text(Canvas canvas, String s, Offset at,
      {required _Align align, required Color color, required double size}) {
    final tp = _painter(s, color, size, FontWeight.w500);
    double dx = at.dx;
    if (align == _Align.center) dx -= tp.width / 2;
    if (align == _Align.right) dx -= tp.width;
    tp.paint(canvas, Offset(dx, at.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.values != values ||
      old.highlightIndex != highlightIndex ||
      old.t != t;
}

enum _Align { center, right }
