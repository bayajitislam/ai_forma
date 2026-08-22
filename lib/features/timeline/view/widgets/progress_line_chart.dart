import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';
import 'package:intl/intl.dart' hide TextDirection;

class ProgressLineChart extends StatelessWidget {
  const ProgressLineChart({
    super.key,
    this.seriesPoints = const [],
  });

  final List<TimelineChartSeriesItemModel> seriesPoints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(
        painter: _ProgressChartPainter(seriesPoints: seriesPoints),
      ),
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  final List<TimelineChartSeriesItemModel> seriesPoints;

  _ProgressChartPainter({required this.seriesPoints});

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
      // Fallback default points if empty
      final defaultData = [
        _ChartPoint(xRatio: 0.1, yRatio: 0.25, label: 'Apr 27'),
        _ChartPoint(xRatio: 0.36, yRatio: 0.4, label: 'May 4'),
        _ChartPoint(xRatio: 0.63, yRatio: 0.55, label: 'May 11'),
        _ChartPoint(xRatio: 0.9, yRatio: 0.7, label: 'May 18'),
      ];
      _drawChartPoints(canvas, size, defaultData, linePaint, pointPaint);
      return;
    }

    // Min and Max calculation
    final minY = seriesPoints
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final maxY = seriesPoints
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final rangeY = (maxY - minY) == 0 ? 1.0 : (maxY - minY);

    final chartData = <_ChartPoint>[];
    for (int i = 0; i < seriesPoints.length; i++) {
      final xRatio = seriesPoints.length == 1
          ? 0.5
          : 0.1 + (i / (seriesPoints.length - 1)) * 0.8;
      final normalizedY = (seriesPoints[i].value - minY) / rangeY;
      final yRatio = 0.2 + normalizedY * 0.6;
      final label = _formatDateLabel(seriesPoints[i].date);

      chartData.add(
        _ChartPoint(xRatio: xRatio, yRatio: yRatio, label: label),
      );
    }

    _drawChartPoints(canvas, size, chartData, linePaint, pointPaint);
  }

  void _drawChartPoints(
    Canvas canvas,
    Size size,
    List<_ChartPoint> data,
    Paint linePaint,
    Paint pointPaint,
  ) {
    final path = Path();
    final points = <Offset>[];
    const chartHeightOffset = 40.0;

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final x = size.width * d.xRatio;
      final y = size.height -
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

    if (data.length > 1) {
      canvas.drawPath(path, linePaint);
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final point = points[i];
      final d = data[i];

      canvas.drawCircle(point, 7.0, pointPaint);

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
