import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class BodyFatChartPainter extends CustomPainter {
  final List<TimelineChartSeriesItemModel> seriesPoints;

  BodyFatChartPainter({required this.seriesPoints});

  String _formatDateLabel(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat('MMM d').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

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

    if (seriesPoints.isEmpty) {
      return;
    }

    final minY = seriesPoints
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final maxY = seriesPoints
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final rangeY = (maxY - minY) == 0 ? 1.0 : (maxY - minY);

    const leftPadding = 36.0;
    const rightPadding = 16.0;
    const bottomPadding = 30.0;
    const topPadding = 10.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw Y axis labels
    final yStep = (maxY - minY) / 3;
    for (int i = 0; i < 4; i++) {
      final val = maxY - (yStep * i);
      final y = topPadding + chartHeight * (i / 3);

      textPainter.text = TextSpan(
        text: val.toStringAsFixed(1),
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito',
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(4, y - textPainter.height / 2));
    }

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < seriesPoints.length; i++) {
      final dp = seriesPoints[i];
      final xRatio = seriesPoints.length == 1
          ? 0.5
          : i / (seriesPoints.length - 1);
      final x = leftPadding + chartWidth * xRatio;

      final yRatio = (dp.value - minY) / rangeY;
      final y = topPadding + chartHeight * (1.0 - yRatio);
      final point = Offset(x, y);
      points.add(point);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (seriesPoints.length > 1) {
      canvas.drawPath(path, linePaint);
    }

    for (int i = 0; i < seriesPoints.length; i++) {
      final point = points[i];
      final dp = seriesPoints[i];

      canvas.drawCircle(point, 7.0, pointPaint);

      textPainter.text = TextSpan(
        text: _formatDateLabel(dp.date),
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(point.dx - textPainter.width / 2, size.height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
