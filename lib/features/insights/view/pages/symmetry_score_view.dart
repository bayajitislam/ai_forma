import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/symmetry_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_symmetry_body_map.dart';

class SymmetryScoreView extends StatelessWidget {
  const SymmetryScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SymmetryController>()
        ? Get.find<SymmetryController>()
        : Get.put(
            SymmetryController(
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
      final isFirstScan = (data?.checkinNumber ?? 1) <= 1;

      // Map values with fallback defaults
      final score = data?.score ?? 85;
      final rawStatus = data?.status ?? '';
      final badgeText = rawStatus.isNotEmpty ? rawStatus : InsightsStrings.good;
      final badgeType = InsightScoreBadgeType.fromTone(
        data?.statusTone,
        data?.status,
        fallback: InsightScoreBadgeType.good,
      );
      final rawSummary = data?.summary ?? '';
      final summaryText = isFirstScan
          ? (rawSummary.isNotEmpty &&
                  !rawSummary.toLowerCase().contains('week') &&
                  !rawSummary.toLowerCase().contains('stable') &&
                  !rawSummary.toLowerCase().contains('progress'))
              ? rawSummary
              : InsightsStrings.symmetrySummaryFirstScan
          : (rawSummary.isNotEmpty ? rawSummary : InsightsStrings.symmetrySummary);

      // Visual image
      final visualImage = data?.visual?.imageUrl;
      final visualThumb = data?.visual?.thumbUrl;

      // Analysis
      final isLocked = data?.accessLevel == 'locked_preview' ||
          (data != null && data.analysis == null && data.analysisHeadings.isNotEmpty);
      final rawAnalysis = data?.analysis;
      final analysisText = isLocked
          ? null
          : ((rawAnalysis != null && rawAnalysis.isNotEmpty)
              ? rawAnalysis
              : (isFirstScan
                  ? InsightsStrings.symmetryAnalysisFirstScan
                  : InsightsStrings.symmetryAnalysis));

      // Priorities
      final prioritiesList = (data?.weeklyPriorities.isNotEmpty ?? false)
          ? data!.weeklyPriorities.map((e) => e.text).toList()
          : <String>[
              InsightsStrings.symmetryPriority1,
              InsightsStrings.symmetryPriority2,
              InsightsStrings.symmetryPriority3,
            ];

      return InsightMetricScaffold(
        title: InsightsStrings.symmetryScore,
        children: [
          InsightScoreSection(
            scoreLabel: InsightsStrings.symmetryScoreLabel,
            score: score,
            badge: badgeText,
            badgeType: badgeType,
            summary: summaryText,
          ),
          const SizedBox(height: 20),
          InsightSymmetryBodyMap(
            imageUrl: visualImage,
            thumbUrl: visualThumb,
            onRefreshRequested: controller.fetchDetail,
          ),
          const SizedBox(height: 24),
          InsightAnalysisSection(
            analysis: analysisText,
            analysisHeadings: data?.analysisHeadings,
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
