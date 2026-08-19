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

  static String formatDateLabel(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final monthStr = months[parsed.month - 1];
    return '$monthStr ${parsed.day}';
  }

  static String formatYValue(double val) {
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final double maxVal = dataPoints.isNotEmpty
        ? dataPoints.reduce((a, b) => a > b ? a : b)
        : 0;
    final double minVal = dataPoints.isNotEmpty
        ? dataPoints.reduce((a, b) => a < b ? a : b)
        : 0;
    final double midVal = (maxVal + minVal) / 2;

    final String maxStr = formatYValue(maxVal);
    final String midStr = formatYValue(midVal);
    final String minStr = formatYValue(minVal);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.insightChartBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Y-axis labels column
              SizedBox(
                height: 120,
                width: 26,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: dataPoints.length <= 1
                      ? [
                          const Spacer(),
                          Text(
                            dataPoints.isNotEmpty
                                ? formatYValue(dataPoints.first)
                                : '',
                            style: const TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                        ]
                      : [
                          Text(
                            maxStr,
                            style: const TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            midStr,
                            style: const TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            minStr,
                            style: const TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                ),
              ),
              const SizedBox(width: 8),
              // Chart area
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: CustomPaint(
                    painter: _TrendChartPainter(
                      dataPoints: dataPoints,
                      trendUp: trendUp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // X-axis date labels
          Row(
            children: [
              const SizedBox(width: 44), // Y-axis offset alignment (36 + 8)
              Expanded(
                child: Row(
                  mainAxisAlignment: labels.length == 1
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: labels
                      .map(
                        (label) => Text(
                          formatDateLabel(label),
                          style: const TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  _TrendChartPainter({required this.dataPoints, required this.trendUp});

  final List<double> dataPoints;
  final bool trendUp;

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final gridPaint = Paint()
      ..color = AppColors.cardBorder
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.brandTealDark
      ..style = PaintingStyle.fill;

    // Single data point: Draw a horizontal line and a centered point
    if (dataPoints.length == 1) {
      final centerY = size.height / 2;
      final centerX = size.width / 2;

      final linePaint = Paint()
        ..color = AppColors.brandTealDark.withValues(alpha: 0.3)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(0, centerY),
        Offset(size.width, centerY),
        linePaint,
      );

      final centerPoint = Offset(centerX, centerY);
      canvas.drawCircle(centerPoint, 5, dotPaint);
      canvas.drawCircle(
        centerPoint,
        5,
        Paint()
          ..color = AppColors.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawCircle(centerPoint, 6, dotPaint);
      return;
    }

    // Grid lines for multi-point chart
    canvas.drawLine(
      Offset(0, size.height * 0.1),
      Offset(size.width, size.height * 0.1),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.9),
      Offset(size.width, size.height * 0.9),
      gridPaint,
    );

    // Multiple data points: Draw trend line and points
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
