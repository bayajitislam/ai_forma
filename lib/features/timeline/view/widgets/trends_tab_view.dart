import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/timeline/constants/timeline_strings.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/models/timeline_trends_model.dart';
import 'package:ai_forma/features/timeline/view/widgets/body_fat_chart_painter.dart';
import 'package:ai_forma/features/timeline/view/widgets/trends_baseline_card.dart';
import 'package:ai_forma/features/timeline/view/widgets/trends_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          : TimelineStrings.placeholderPercent;

      final changePercentVal = trends?.changePercent;
      final changeValStr = changePercentVal != null
          ? '${changePercentVal > 0 ? '+' : ''}${changePercentVal.toStringAsFixed(1)}% ${trends?.changeLabel ?? ''}'
          : TimelineStrings.placeholderValue;

      final trendLabel =
          trends?.trend?.label ?? TimelineStrings.stableTrend;
      final weeklyRateVal = trends?.weeklyRatePercent;
      final rateStr = weeklyRateVal != null
          ? '${weeklyRateVal.toStringAsFixed(2)}% / week'
          : TimelineStrings.placeholderValue;

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
                    TimelineStrings.bodyFatPercentTitle,
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
              const TrendsBaselineCard()
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
                    painter: BodyFatChartPainter(seriesPoints: chartSeries),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Trend Summary Card
              TrendsSummaryCard(
                trendLabel: trendLabel,
                rateStr: rateStr,
              ),
            ],
          ],
        ),
      );
    });
  }
}
