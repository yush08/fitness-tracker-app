import 'package:flutter/material.dart';

/// A stylised dark "map" with a coloured GPS route drawn over a faint street
/// network. Deterministic CustomPainter — no map SDK or network involved.
class RouteMapPreview extends StatelessWidget {
  final Color routeColor;
  final double height;

  const RouteMapPreview({
    super.key,
    required this.routeColor,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: height,
        color: const Color(0xFF0C1220),
        child: CustomPaint(
          painter: _RoutePainter(routeColor),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Color routeColor;
  _RoutePainter(this.routeColor);

  // Normalised faint "streets".
  static const List<List<double>> _streets = [
    [0.0, 0.3, 1.0, 0.42],
    [0.0, 0.66, 1.0, 0.58],
    [0.22, 0.0, 0.3, 1.0],
    [0.55, 0.0, 0.62, 1.0],
    [0.8, 0.0, 0.74, 1.0],
    [0.1, 0.85, 0.9, 0.9],
  ];

  // Normalised route waypoints.
  static const List<List<double>> _route = [
    [0.12, 0.72],
    [0.28, 0.6],
    [0.4, 0.66],
    [0.52, 0.48],
    [0.63, 0.5],
    [0.74, 0.38],
    [0.88, 0.42],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final street = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1.4;
    for (final s in _streets) {
      canvas.drawLine(
        Offset(s[0] * size.width, s[1] * size.height),
        Offset(s[2] * size.width, s[3] * size.height),
        street,
      );
    }

    final pts = [
      for (final p in _route) Offset(p[0] * size.width, p[1] * size.height)
    ];
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final mid = Offset(
        (pts[i].dx + pts[i + 1].dx) / 2,
        (pts[i].dy + pts[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = routeColor,
    );

    canvas.drawCircle(pts.first, 4, Paint()..color = Colors.white);
    canvas.drawCircle(pts.last, 4, Paint()..color = routeColor);
  }

  @override
  bool shouldRepaint(_RoutePainter old) => old.routeColor != routeColor;
}
