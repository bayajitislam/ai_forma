import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/posture_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_posture_widgets.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';

class PostureAnalysisView extends StatelessWidget {
  const PostureAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PostureController>()
        ? Get.find<PostureController>()
        : Get.put(
            PostureController(
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

      // First scan check
      final isFirstScan = (data?.checkinNumber ?? 1) <= 1 || data?.comparison?.before == null;

      // Map values with fallback defaults
      final score = data?.score ?? 70;
      final rawStatus = data?.status ?? '';
      final badgeText = rawStatus.isNotEmpty ? rawStatus : InsightsStrings.needsAttention;
      final badgeType = InsightScoreBadgeType.fromTone(
        data?.statusTone,
        data?.status,
        fallback: InsightScoreBadgeType.warning,
      );
      final rawSummary = data?.summary ?? '';
      final summaryText = isFirstScan
          ? (rawSummary.isNotEmpty &&
                  !rawSummary.toLowerCase().contains('improvement') &&
                  !rawSummary.toLowerCase().contains('progress') &&
                  !rawSummary.toLowerCase().contains('stable') &&
                  !rawSummary.toLowerCase().contains('week'))
              ? rawSummary
              : InsightsStrings.postureSummaryFirstScan
          : (rawSummary.isNotEmpty ? rawSummary : InsightsStrings.postureSummary);

      // Analysis
      final rawDetected = data?.analysis?.detected ?? '';
      final rawWhy = data?.analysis?.why ?? '';
      final rawNextStep = data?.analysis?.nextStep ?? '';

      final detectedText = isFirstScan
          ? (rawDetected.isNotEmpty &&
                  !rawDetected.toLowerCase().contains('week')
              ? rawDetected
              : InsightsStrings.postureDetectedFirstScan)
          : (rawDetected.isNotEmpty
              ? rawDetected
              : InsightsStrings.postureDetected);
      final whyText = isFirstScan
          ? InsightsStrings.postureSuggestsFirstScan
          : (rawWhy.isNotEmpty ? rawWhy : InsightsStrings.postureWhy);
      final nextStepText = isFirstScan
          ? InsightsStrings.postureNextStepsFirstScan
          : (rawNextStep.isNotEmpty ? rawNextStep : InsightsStrings.postureNextSteps);

      // Priorities
      final prioritiesList = (data?.weeklyPriorities.isNotEmpty ?? false)
          ? data!.weeklyPriorities.map((e) => e.text).toList()
          : <String>[
              InsightsStrings.posturePriority1,
              InsightsStrings.posturePriority2,
              InsightsStrings.posturePriority3,
            ];

      return InsightMetricScaffold(
        title: InsightsStrings.postureAnalysis,
        children: [
          InsightScoreSection(
            scoreLabel: InsightsStrings.postureScoreLabel,
            score: score,
            badge: badgeText,
            badgeType: badgeType,
            summary: summaryText,
          ),
          const SizedBox(height: 20),
          InsightPostureComparison(
            comparison: data?.comparison,
            onRefreshRequested: controller.fetchDetail,
          ),
          const SizedBox(height: 16),
          InsightPostureMetricsList(
            alignment: data?.alignment,
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
