import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/fat_loss_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_stats_card.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_trend_chart.dart';

class FatLossView extends StatelessWidget {
  const FatLossView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FatLossController>()
        ? Get.find<FatLossController>()
        : Get.put(
            FatLossController(
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

      // Map values with fallback defaults
      final score = data?.score ?? 60;
      final badgeText = (data?.status.isNotEmpty ?? false)
          ? data!.status
          : InsightsStrings.progressingWell;
      final badgeType = InsightScoreBadgeType.fromTone(
        data?.statusTone,
        data?.status,
      );
      final summaryText = (data?.summary.isNotEmpty ?? false)
          ? data!.summary
          : InsightsStrings.fatLossSummary;

      // Chart
      final series = data?.chart?.series ?? [];
      final dataPoints = series.isNotEmpty
          ? series.map((e) => e.bodyFatKg).toList()
          : <double>[62, 68, 70, 71, 78];
      final labels = series.isNotEmpty
          ? series.map((e) => e.date).toList()
          : InsightsStrings.trendDates;

      // Metrics
      final percentValue = data?.metrics?.bodyFatPercent?.value;
      final percentDelta = data?.metrics?.bodyFatPercent?.delta;
      final kgValue = data?.metrics?.fatMassKg?.value;
      final kgDelta = data?.metrics?.fatMassKg?.delta;

      final percentValueStr = percentValue != null ? '$percentValue%' : '- %';
      final percentDeltaStr = percentDelta != null ? '$percentDelta%' : '- %';
      final percentDirection = (percentDelta ?? 0) <= 0
          ? InsightStatChangeDirection.down
          : InsightStatChangeDirection.up;

      final kgValueStr = kgValue != null ? '$kgValue kg' : '- kg';
      final kgDeltaStr = kgDelta != null ? '$kgDelta kg' : '- kg';
      final kgDirection = (kgDelta ?? 0) <= 0
          ? InsightStatChangeDirection.down
          : InsightStatChangeDirection.up;

      // Analysis
      final detectedText = (data?.analysis?.detected.isNotEmpty ?? false)
          ? data!.analysis!.detected
          : InsightsStrings.fatLossDetected;
      final whyText = (data?.analysis?.why.isNotEmpty ?? false)
          ? data!.analysis!.why
          : InsightsStrings.fatLossWhy;
      final nextStepText = (data?.analysis?.nextStep.isNotEmpty ?? false)
          ? data!.analysis!.nextStep
          : InsightsStrings.fatLossNextSteps;

      // Priorities
      final prioritiesList = (data?.weeklyPriorities.isNotEmpty ?? false)
          ? data!.weeklyPriorities.map((e) => e.text).toList()
          : <String>[
              InsightsStrings.fatLossPriority1,
              InsightsStrings.fatLossPriority2,
              InsightsStrings.fatLossPriority3,
            ];

      return InsightMetricScaffold(
        title: InsightsStrings.fatLoss,
        children: [
          InsightScoreSection(
            scoreLabel: InsightsStrings.fatLossScoreLabel,
            score: score,
            badge: badgeText,
            badgeType: badgeType,
            summary: summaryText,
          ),
          const SizedBox(height: 20),
          InsightTrendChart(
            dataPoints: dataPoints,
            labels: labels,
          ),
          const SizedBox(height: 16),
          InsightStatsCard(
            rows: [
              InsightStatRowData(
                value: percentValueStr,
                label: InsightsStrings.bodyFatPercent,
                change: percentDeltaStr,
                changeDirection: percentDirection,
                changeIsPositive: true,
              ),
              InsightStatRowData(
                value: kgValueStr,
                label: InsightsStrings.fatMass,
                change: kgDeltaStr,
                changeDirection: kgDirection,
                changeIsPositive: true,
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
          InsightPrioritiesCard(
            priorities: prioritiesList,
          ),
        ],
      );
    });
  }
}
