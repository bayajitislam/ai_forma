import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/muscle_growth_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_stats_card.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_trend_chart.dart';

class MuscleGrowthView extends StatelessWidget {
  const MuscleGrowthView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MuscleGrowthController>()
        ? Get.find<MuscleGrowthController>()
        : Get.put(
            MuscleGrowthController(
              repository: InsightsRepository(
                Get.isRegistered<DioClient>()
                    ? Get.find<DioClient>()
                    : DioClient(),
              ),
            ),
          );

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final error = controller.errorMessage.value;
      final data = controller.detail.value;

      if (isLoading) {
        return const Scaffold(
          backgroundColor: AppColors.surface,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.brandTeal),
          ),
        );
      }

      if (error.isNotEmpty && data == null) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AppNetworkErrorWidget(
                onRetry: controller.fetchDetail,
                message: error,
              ),
            ),
          ),
        );
      }

      // First scan check: checkin number <= 1 or only single scan series available
      final series = data?.chart?.series ?? [];
      final isFirstScan = (data?.checkinNumber ?? 1) <= 1 || series.length <= 1;

      // Metrics
      final kgValue = data?.metrics?.muscleMassKg?.value;
      final kgDelta = data?.metrics?.muscleMassKg?.delta;
      final percentValue = data?.metrics?.muscleMassPercent?.value;
      final percentDelta = data?.metrics?.muscleMassPercent?.delta;

      final kgValueStr = kgValue != null ? '$kgValue kg' : '- kg';
      final kgDeltaStr = isFirstScan
          ? InsightsStrings.noChangePlaceholder
          : (kgDelta != null ? '$kgDelta kg' : '- kg');
      final kgDirection = isFirstScan
          ? InsightStatChangeDirection.none
          : ((kgDelta ?? 1) >= 0
              ? InsightStatChangeDirection.up
              : InsightStatChangeDirection.down);

      final percentValueStr = percentValue != null ? '$percentValue%' : '- %';
      final percentDeltaStr = isFirstScan
          ? InsightsStrings.noChangePlaceholder
          : (percentDelta != null ? '$percentDelta%' : '- %');
      final percentDirection = isFirstScan
          ? InsightStatChangeDirection.none
          : ((percentDelta ?? 1) >= 0
              ? InsightStatChangeDirection.up
              : InsightStatChangeDirection.down);

      // Score & Badge
      final score = data?.score ?? 78;
      final rawStatus = data?.status ?? '';
      final badgeText = rawStatus.isNotEmpty
          ? rawStatus
          : (isFirstScan ? InsightsStrings.good : InsightsStrings.progressingWell);
      final badgeType = InsightScoreBadgeType.fromTone(
        data?.statusTone,
        data?.status,
        fallback: InsightScoreBadgeType.good,
      );
      final rawSummary = data?.summary ?? '';
      final summaryText = isFirstScan
          ? (rawSummary.isNotEmpty &&
                  !rawSummary.toLowerCase().contains('week') &&
                  !rawSummary.toLowerCase().contains('gain') &&
                  !rawSummary.toLowerCase().contains('stable') &&
                  !rawSummary.toLowerCase().contains('progress'))
              ? rawSummary
              : InsightsStrings.muscleGrowthSummaryFirstScan
          : (rawSummary.isNotEmpty ? rawSummary : InsightsStrings.muscleGrowthSummary);

      // Chart
      final List<double> dataPoints;
      final List<String> labels;

      if (isFirstScan) {
        final currentPoint = kgValue ?? (series.isNotEmpty ? series.first.muscleMassKg : 68.0);
        dataPoints = [currentPoint];
        labels = [
          series.isNotEmpty
              ? series.first.date
              : ((data?.scanDate.isNotEmpty ?? false) ? data!.scanDate : 'Scan 1')
        ];
      } else {
        dataPoints = series.isNotEmpty
            ? series.map((e) => e.muscleMassKg).toList()
            : <double>[62, 68, 70, 71, 78];
        labels = series.isNotEmpty
            ? series.map((e) => e.date).toList()
            : InsightsStrings.trendDates;
      }

      // Analysis
      final rawDetected = data?.analysis?.detected ?? '';
      final rawWhy = data?.analysis?.why ?? '';
      final rawNextStep = data?.analysis?.nextStep ?? '';

      final detectedText = isFirstScan
          ? (rawDetected.isNotEmpty &&
                  !rawDetected.toLowerCase().contains('week')
              ? rawDetected
              : InsightsStrings.muscleGrowthDetectedFirstScan)
          : (rawDetected.isNotEmpty
              ? rawDetected
              : InsightsStrings.muscleGrowthDetected);
      final whyText = isFirstScan
          ? InsightsStrings.muscleGrowthSuggestsFirstScan
          : (rawWhy.isNotEmpty ? rawWhy : InsightsStrings.muscleGrowthWhy);
      final nextStepText = isFirstScan
          ? InsightsStrings.muscleGrowthNextStepsFirstScan
          : (rawNextStep.isNotEmpty ? rawNextStep : InsightsStrings.muscleGrowthNextSteps);

      // Priorities
      final prioritiesList = (data?.weeklyPriorities.isNotEmpty ?? false)
          ? data!.weeklyPriorities.map((e) => e.text).toList()
          : <String>[
              InsightsStrings.muscleGrowthPriority1,
              InsightsStrings.muscleGrowthPriority2,
              InsightsStrings.muscleGrowthPriority3,
            ];

      return InsightMetricScaffold(
        title: InsightsStrings.muscleGrowth,
        children: [
          InsightScoreSection(
            scoreLabel: InsightsStrings.muscleGrowthScoreLabel,
            score: score,
            badge: badgeText,
            badgeType: badgeType,
            summary: summaryText,
          ),
          const SizedBox(height: 20),
          InsightTrendChart(dataPoints: dataPoints, labels: labels),
          const SizedBox(height: 16),
          InsightStatsCard(
            rows: [
              InsightStatRowData(
                value: kgValueStr,
                label: InsightsStrings.muscleMass,
                change: kgDeltaStr,
                changeDirection: kgDirection,
              ),
              InsightStatRowData(
                value: percentValueStr,
                label: InsightsStrings.muscleMassPercent,
                change: percentDeltaStr,
                changeDirection: percentDirection,
              ),
            ],
          ),
          const SizedBox(height: 24),
          InsightAnalysisSection(
            detected: detectedText,
            why: whyText,
            nextSteps: nextStepText,
          ),
          const SizedBox(height: 16),
          InsightPrioritiesCard(priorities: prioritiesList),
        ],
      );
    });
  }
}
