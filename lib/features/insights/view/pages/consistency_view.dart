import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/consistency_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_consistency_widgets.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';

class ConsistencyView extends StatelessWidget {
  const ConsistencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ConsistencyController>()
        ? Get.find<ConsistencyController>()
        : Get.put(
            ConsistencyController(
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
      final score = data?.score ?? 100;
      final badgeText = (data?.status.isNotEmpty ?? false)
          ? data!.status
          : InsightsStrings.excellent;
      final badgeType = (data?.statusTone.toLowerCase() == 'warning')
          ? InsightScoreBadgeType.warning
          : InsightScoreBadgeType.excellent;
      final summaryText = (data?.summary.isNotEmpty ?? false)
          ? data!.summary
          : InsightsStrings.consistencySummary;

      // Consistency Grid & Metrics
      final completedScans = data?.grid.length ?? 1;
      final totalWeeks = data?.window?.weeks ?? 8;

      final streakWeeks = data?.metrics?.currentStreakWeeks;
      final streakStr = streakWeeks != null ? '$streakWeeks weeks' : '1 weeks';

      final onTimePercent = data?.metrics?.onTimePercent;
      final onTimeStr = onTimePercent != null ? '$onTimePercent%' : '100%';

      final momentum = data?.metrics?.momentumGained;
      final momentumStr = momentum != null ? '+$momentum pts' : 'N/A';

      // Analysis
      final detectedText = (data?.analysis?.detected.isNotEmpty ?? false)
          ? data!.analysis!.detected
          : InsightsStrings.consistencyDetected;
      final whyText = (data?.analysis?.why.isNotEmpty ?? false)
          ? data!.analysis!.why
          : InsightsStrings.consistencyWhy;
      final nextStepText = (data?.analysis?.nextStep.isNotEmpty ?? false)
          ? data!.analysis!.nextStep
          : InsightsStrings.consistencyNextSteps;

      // Priorities
      final prioritiesList = (data?.weeklyPriorities.isNotEmpty ?? false)
          ? data!.weeklyPriorities.map((e) => e.text).toList()
          : <String>[
              InsightsStrings.consistencyPriority1,
              InsightsStrings.consistencyPriority2,
              InsightsStrings.consistencyPriority3,
            ];

      return InsightMetricScaffold(
        title: InsightsStrings.consistency,
        children: [
          InsightScoreSection(
            scoreLabel: InsightsStrings.consistencyScoreLabel,
            score: score,
            badge: badgeText,
            badgeType: badgeType,
            summary: summaryText,
          ),
          const SizedBox(height: 20),
          InsightConsistencyGrid(
            completedCount: completedScans,
            totalCount: totalWeeks,
          ),
          const SizedBox(height: 16),
          InsightConsistencyStatsCard(
            currentStreak: streakStr,
            onTimeRate: onTimeStr,
            momentumGained: momentumStr,
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
