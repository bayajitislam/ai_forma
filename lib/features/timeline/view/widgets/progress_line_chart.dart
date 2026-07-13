import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class ProgressLineChart extends StatelessWidget {
  const ProgressLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(painter: _ProgressChartPainter()),
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.brandTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = AppColors.brandTeal
      ..style = PaintingStyle.fill;

    // Data points represented as ratios (x, y) where y goes from 0 (bottom) to 1 (top)
    // We reverse y in calculations so that higher values are drawn higher up.
    final data = [
      _ChartPoint(xRatio: 0.1, yRatio: 0.25, label: 'Apr 27'),
      _ChartPoint(xRatio: 0.36, yRatio: 0.4, label: 'May 4'),
      _ChartPoint(xRatio: 0.63, yRatio: 0.55, label: 'May 11'),
      _ChartPoint(xRatio: 0.9, yRatio: 0.7, label: 'May 18'),
    ];

    final path = Path();
    final points = <Offset>[];

    const chartHeightOffset =
        40.0; // Space for labels at bottom and padding at top

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final x = size.width * d.xRatio;
      final y =
          size.height -
          chartHeightOffset -
          (d.yRatio * (size.height - chartHeightOffset - 10));
      final offset = Offset(x, y);
      points.add(offset);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw connecting line
    canvas.drawPath(path, linePaint);

    // Draw data points & text labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final point = points[i];
      final d = data[i];

      // Draw point circle
      canvas.drawCircle(point, 7.0, pointPaint);

      // Draw date text
      textPainter.text = TextSpan(
        text: d.label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Nunito',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(point.dx - (textPainter.width / 2), size.height - 24),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChartPoint {
  final double xRatio;
  final double yRatio;
  final String label;

  _ChartPoint({
    required this.xRatio,
    required this.yRatio,
    required this.label,
  });
}
