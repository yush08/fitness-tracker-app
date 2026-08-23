import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Horizontal drag-to-select ruler (height / weight pickers).
///
/// Deterministic and dependency-free: a [CustomPaint] renders the ticks and
/// labels around the current value while a horizontal drag shifts it.
class RulerPicker extends StatefulWidget {
  final int min;
  final int max;
  final int initialValue;
  final int majorInterval;
  final double pixelsPerUnit;
  final ValueChanged<int>? onChanged;

  const RulerPicker({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    this.majorInterval = 10,
    this.pixelsPerUnit = 9,
    this.onChanged,
  });

  @override
  State<RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue
        .toDouble()
        .clamp(widget.min.toDouble(), widget.max.toDouble());
  }

  @override
  void didUpdateWidget(RulerPicker old) {
    super.didUpdateWidget(old);
    // React to the parent swapping the value or range (e.g. a unit change),
    // otherwise the ruler keeps showing the pre-conversion number.
    if (old.initialValue != widget.initialValue ||
        old.min != widget.min ||
        old.max != widget.max) {
      _value = widget.initialValue
          .toDouble()
          .clamp(widget.min.toDouble(), widget.max.toDouble());
    }
  }

  void _onDrag(DragUpdateDetails d) {
    final next = (_value - d.delta.dx / widget.pixelsPerUnit)
        .clamp(widget.min.toDouble(), widget.max.toDouble());
    if (next == _value) return;
    final prevInt = _value.round();
    setState(() => _value = next);
    if (_value.round() != prevInt) widget.onChanged?.call(_value.round());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDrag,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: CustomPaint(
          painter: _RulerPainter(
            value: _value,
            min: widget.min,
            max: widget.max,
            majorInterval: widget.majorInterval,
            pixelsPerUnit: widget.pixelsPerUnit,
          ),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double value;
  final int min;
  final int max;
  final int majorInterval;
  final double pixelsPerUnit;

  _RulerPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.majorInterval,
    required this.pixelsPerUnit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    const topY = 6.0;
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 1.4;

    final half = (size.width / 2 / pixelsPerUnit).ceil() + 1;
    final startV = (value.round() - half).clamp(min, max);
    final endV = (value.round() + half).clamp(min, max);

    for (int v = startV; v <= endV; v++) {
      final x = centerX + (v - value) * pixelsPerUnit;
      final isMajor = v % majorInterval == 0;
      final isMid = v % (majorInterval ~/ 2) == 0;
      final tickH = isMajor ? 30.0 : (isMid ? 20.0 : 12.0);
      canvas.drawLine(Offset(x, topY), Offset(x, topY + tickH), tickPaint);
      if (isMajor) {
        _label('$v', x, topY + tickH + 12, AppColors.textSecondary, canvas);
      }
    }

    // Center indicator + current value.
    canvas.drawLine(
      Offset(centerX, topY - 2),
      Offset(centerX, topY + 40),
      Paint()
        ..color = AppColors.accentBlue
        ..strokeWidth = 2.5,
    );
    _label('${value.round()}', centerX, topY + 52, AppColors.accentBlue, canvas,
        bold: true);
  }

  void _label(String s, double cx, double y, Color color, Canvas canvas,
      {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: GoogleFonts.montserrat(
          color: color,
          fontSize: 14,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, y));
  }

  @override
  bool shouldRepaint(_RulerPainter old) => old.value != value;
}
