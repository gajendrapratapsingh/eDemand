import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class DashedRect extends StatelessWidget {

  const DashedRect({super.key, this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0});
  final Color color;
  final double strokeWidth;
  final double gap;

  @override
  Widget build(final BuildContext context) => Padding(
      padding: EdgeInsets.all(strokeWidth / 2),
      child: CustomPaint(
        painter: DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
      ),
    );
}

class DashRectPainter extends CustomPainter {

  DashRectPainter({this.strokeWidth = 2.0, this.color = Colors.red, this.gap = 5.0});
  double strokeWidth;
  Color color;
  double gap;

  @override
  void paint(final Canvas canvas, final Size size) {
      final Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double x = size.width;
      final double y = size.height;

      final Path topPath = getDashedPath(
      a: const Point(0, 0),
      b: Point(x, 0),
      gap: gap,
    );

     final Path rightPath = getDashedPath(
      a: Point(x, 0),
      b: Point(x, y),
      gap: gap,
    );

    final Path bottomPath = getDashedPath(
      a: Point(0, y),
      b: Point(x, y),
      gap: gap,
    );

    final Path leftPath = getDashedPath(
      a: const Point(0, 0),
      b: Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);
  }

  Path getDashedPath({
    required final Point<double> a,
    required final Point<double> b,
    @required final gap,
  }) {
    final Size size = Size(b.x - a.x, b.y - a.y);
    final  path = Path();
    path.moveTo(a.x, a.y);

    bool shouldDraw = true;
    Point<double> currentPoint = Point<double>(a.x, a.y);

    final num radians = atan(size.height / size.width);

    final num dx = cos(radians) * gap < 0 ? cos(radians) * gap * -1 : cos(radians) * gap;

    final num dy = sin(radians) * gap < 0 ? sin(radians) * gap * -1 : sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);

      shouldDraw = !shouldDraw;
      currentPoint = Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => true;
}
