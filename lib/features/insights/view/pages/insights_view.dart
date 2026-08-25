import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/view/pages/compare_scans_view.dart';
import 'package:ai_forma/features/insights/view/pages/consistency_view.dart';
import 'package:ai_forma/features/insights/view/pages/fat_loss_view.dart';
import 'package:ai_forma/features/insights/view/pages/focus_areas_view.dart';
import 'package:ai_forma/features/insights/view/pages/muscle_growth_view.dart';
import 'package:ai_forma/features/insights/view/pages/posture_analysis_view.dart';
import 'package:ai_forma/features/insights/view/pages/next_step_view.dart';
import 'package:ai_forma/features/insights/view/pages/strengths_view.dart';
import 'package:ai_forma/features/insights/view/pages/symmetry_score_view.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_category_card.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_row.dart';

enum InsightCategory { strengths, focusAreas, recommendations }

class InsightsView extends StatefulWidget {
  const InsightsView({super.key});

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  void _openCategory(InsightCategory category, AnalysisResultModel? analysis) {
    final page = switch (category) {
      InsightCategory.strengths => StrengthsView(items: analysis?.strength),
      InsightCategory.focusAreas => FocusAreasView(items: analysis?.focusArea),
      InsightCategory.recommendations => NextStepView(items: analysis?.nextSteps),
    };
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  void _openMetricDetail(Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    // InsightsController is always pre-registered by AppShellView.initState
    // via InsightsBinding().dependencies() before IndexedStack builds this widget.
    final controller = Get.find<InsightsController>();

    return Obx(() {
      // Eagerly capture all observables so Obx subscribes to all on first build.
      final isLoading = controller.isLoading.value;
      final error = controller.errorMessage.value;
      final scan = controller.latestScan.value;

      if (isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.brandTeal),
          ),
        );
      }

      if (error.isNotEmpty && scan == null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: AppNetworkErrorWidget(
            onRetry: controller.fetchLatestScan,
            message: error,
          ),
        );
      }

      final analysis = scan?.analysisResult;

      final muscleSubtitle =
          (analysis?.muscleGrowth?.remark.isNotEmpty ?? false)
          ? analysis!.muscleGrowth!.remark
          : InsightsStrings.muscleGrowthSubtitle;
      final muscleStatus = (analysis?.muscleGrowth?.status.isNotEmpty ?? false)
          ? analysis!.muscleGrowth!.status
          : InsightsStrings.muscleGrowthStatus;

      final fatSubtitle = (analysis?.fatLoss?.remark.isNotEmpty ?? false)
          ? analysis!.fatLoss!.remark
          : InsightsStrings.fatReductionSubtitle;
      final fatStatus = (analysis?.fatLoss?.status.isNotEmpty ?? false)
          ? analysis!.fatLoss!.status
          : InsightsStrings.fatReductionStatus;

      final postureSubtitle =
          (analysis?.postureAnalysis?.remark.isNotEmpty ?? false)
          ? analysis!.postureAnalysis!.remark
          : InsightsStrings.postureSubtitle;
      final postureStatus =
          (analysis?.postureAnalysis?.status.isNotEmpty ?? false)
          ? analysis!.postureAnalysis!.status
          : InsightsStrings.postureStatus;

      final symmetrySubtitle =
          (analysis?.symmetryScore?.remark.isNotEmpty ?? false)
          ? analysis!.symmetryScore!.remark
          : InsightsStrings.symmetrySubtitle;
      final symmetryStatus =
          (analysis?.symmetryScore?.status.isNotEmpty ?? false)
          ? analysis!.symmetryScore!.status
          : InsightsStrings.symmetryStatus;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InsightCategoryCard(
                  label: InsightsStrings.categoryStrengths,
                  icon: AppIcons.shieldCheck,
                  isSelected: false,
                  onTap: () => _openCategory(InsightCategory.strengths, analysis),
                ),
                const SizedBox(width: 10),
                InsightCategoryCard(
                  label: InsightsStrings.categoryFocusAreas,
                  icon: AppIcons.fire,
                  iconColor: AppColors.insightWarning,
                  isSelected: false,
                  onTap: () => _openCategory(InsightCategory.focusAreas, analysis),
                ),
                const SizedBox(width: 10),
                InsightCategoryCard(
                  label: InsightsStrings.categoryNextSteps,
                  icon: AppIcons.cpu,
                  isSelected: false,
                  onTap: () => _openCategory(InsightCategory.recommendations, analysis),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              InsightsStrings.keyInsights,
              style: AppTextStyles.authSectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 14),
            InsightMetricRow(
              icon: AppIcons.heartPulse,
              title: InsightsStrings.muscleGrowth,
              subtitle: muscleSubtitle,
              status: muscleStatus,
              statusType: InsightStatusType.positive,
              onTap: () => _openMetricDetail(const MuscleGrowthView()),
            ),
            const SizedBox(height: 10),
            InsightMetricRow(
              icon: AppIcons.fire,
              title: InsightsStrings.fatReduction,
              subtitle: fatSubtitle,
              status: fatStatus,
              statusType: InsightStatusType.positive,
              onTap: () => _openMetricDetail(const FatLossView()),
            ),
            const SizedBox(height: 10),
            InsightMetricRow(
              icon: AppIcons.alert,
              title: InsightsStrings.posture,
              subtitle: postureSubtitle,
              status: postureStatus,
              statusType: InsightStatusType.warning,
              onTap: () => _openMetricDetail(const PostureAnalysisView()),
            ),
            const SizedBox(height: 10),
            InsightMetricRow(
              icon: AppIcons.checkCircle,
              title: InsightsStrings.symmetryScore,
              subtitle: symmetrySubtitle,
              status: symmetryStatus,
              statusType: InsightStatusType.positive,
              onTap: () => _openMetricDetail(const SymmetryScoreView()),
            ),
            const SizedBox(height: 10),
            InsightMetricRow(
              icon: AppIcons.checkCircle,
              title: InsightsStrings.consistency,
              subtitle: InsightsStrings.consistencySubtitle,
              status: InsightsStrings.consistencyStatus,
              statusType: InsightStatusType.positive,
              onTap: () => _openMetricDetail(const ConsistencyView()),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const CompareScansView(),
                  ),
                );
              },
              label: InsightsStrings.compareScans,
            ),
          ],
        ),
      );
    });
  }
}
