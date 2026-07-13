import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';

class InsightTrendChart extends StatelessWidget {
  const InsightTrendChart({
    super.key,
    required this.dataPoints,
    required this.labels,
    this.trendUp = true,
  });

  final List<double> dataPoints;
  final List<String> labels;
  final bool trendUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.insightChartBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrendChartPainter(
                dataPoints: dataPoints,
                trendUp: trendUp,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map(
                  (label) => Text(
                    label,
                    style: const TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  _TrendChartPainter({
    required this.dataPoints,
    required this.trendUp,
  });

  final List<double> dataPoints;
  final bool trendUp;

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final min = dataPoints.reduce((a, b) => a < b ? a : b);
    final max = dataPoints.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1.0 : max - min;

    final points = <Offset>[];
    for (var i = 0; i < dataPoints.length; i++) {
      final x = size.width * i / (dataPoints.length - 1);
      final normalized = (dataPoints[i] - min) / range;
      final y = trendUp
          ? size.height * (1 - normalized) * 0.8 + size.height * 0.1
          : size.height * normalized * 0.8 + size.height * 0.1;
      points.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..color = AppColors.brandTealDark
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = AppColors.brandTealDark
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = AppColors.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawCircle(point, 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) =>
      oldDelegate.dataPoints != dataPoints;
}
