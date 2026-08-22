import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_trends_model.dart';

class TrendsTabView extends StatelessWidget {
  const TrendsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TimelineController>();

    return Obx(() {
      final isLoading = controller.isTrendsLoading.value;
      final trends = controller.trendsData.value;
      final currentRange = controller.selectedRange.value;

      if (isLoading && trends == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.brandTeal),
        );
      }

      final ranges = trends?.ranges ??
          [
            const TimelineRangeItemModel(key: '7d', label: '7D'),
            const TimelineRangeItemModel(key: '4w', label: '4W'),
            const TimelineRangeItemModel(key: '3m', label: '3M'),
            const TimelineRangeItemModel(key: '1y', label: '1Y'),
          ];

      final currentPercentVal = trends?.currentPercent;
      final isBaselineState = currentPercentVal == null;

      final currentValStr = currentPercentVal != null
          ? '${currentPercentVal.toStringAsFixed(1)}%'
          : '--%';

      final changePercentVal = trends?.changePercent;
      final changeValStr = changePercentVal != null
          ? '${changePercentVal > 0 ? '+' : ''}${changePercentVal.toStringAsFixed(1)}% ${trends?.changeLabel ?? ''}'
          : '--';

      final trendLabel = trends?.trend?.label ?? 'Stable';
      final weeklyRateVal = trends?.weeklyRatePercent;
      final rateStr = weeklyRateVal != null
          ? '${weeklyRateVal.toStringAsFixed(2)}% / week'
          : '--';

      final chartSeries = trends?.chart?.series ?? [];

      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title & Timeframe selectors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Body Fat %',
                    style: AppTextStyles.featureTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.insightAnalysisTitle,
                    ),
                  ),
                  Row(
                    children: ranges.map((rangeItem) {
                      final isSelected = rangeItem.key == currentRange;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: GestureDetector(
                          onTap: () {
                            controller.fetchTrends(rangeItem.key);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.brandTealDark
                                  : AppColors.border,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              rangeItem.label,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (isBaselineState)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.brandTeal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.brandTeal.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.brandTeal,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Baseline Captured',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Body fat trends will be ready after your 2nd check-in.',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Large metric & subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currentValStr,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      changeValStr,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandTeal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Trend Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _BodyFatChartPainter(seriesPoints: chartSeries),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Trend Summary Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        AppColors.dashboardBackground.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardBorder.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trend',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trendLabel,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Current Rate',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.trending_down,
                                size: 18,
                                color: AppColors.brandTeal,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rateStr,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _BodyFatChartPainter extends CustomPainter {
  final List<TimelineChartSeriesItemModel> seriesPoints;

  _BodyFatChartPainter({required this.seriesPoints});

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
