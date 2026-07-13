import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/pages/compare_scans_view.dart';
import 'package:ai_forma/features/insights/view/pages/consistency_view.dart';
import 'package:ai_forma/features/insights/view/pages/fat_loss_view.dart';
import 'package:ai_forma/features/insights/view/pages/focus_areas_view.dart';
import 'package:ai_forma/features/insights/view/pages/muscle_growth_view.dart';
import 'package:ai_forma/features/insights/view/pages/posture_analysis_view.dart';
import 'package:ai_forma/features/insights/view/pages/next_step_view.dart';
import 'package:ai_forma/features/insights/view/pages/strengths_view.dart';
import 'package:ai_forma/features/insights/view/pages/symmetry_score_view.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_category_card.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_row.dart';

enum InsightCategory { strengths, focusAreas, recommendations }

class InsightsView extends StatefulWidget {
  const InsightsView({super.key});

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  InsightCategory _selectedCategory = InsightCategory.strengths;

  void _openCategory(InsightCategory category) {
    setState(() => _selectedCategory = category);

    final page = switch (category) {
      InsightCategory.strengths => const StrengthsView(),
      InsightCategory.focusAreas => const FocusAreasView(),
      InsightCategory.recommendations => const NextStepView(),
    };

    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  void _openMetricDetail(Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
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
                isSelected: _selectedCategory == InsightCategory.strengths,
                onTap: () => _openCategory(InsightCategory.strengths),
              ),
              const SizedBox(width: 10),
              InsightCategoryCard(
                label: InsightsStrings.categoryFocusAreas,
                icon: AppIcons.fire,
                iconColor: AppColors.insightWarning,
                isSelected: _selectedCategory == InsightCategory.focusAreas,
                onTap: () => _openCategory(InsightCategory.focusAreas),
              ),
              const SizedBox(width: 10),
              InsightCategoryCard(
                label: InsightsStrings.categoryNextSteps,
                icon: AppIcons.cpu,
                isSelected:
                    _selectedCategory == InsightCategory.recommendations,
                onTap: () => _openCategory(InsightCategory.recommendations),
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
            subtitle: InsightsStrings.muscleGrowthSubtitle,
            status: InsightsStrings.muscleGrowthStatus,
            statusType: InsightStatusType.positive,
            onTap: () => _openMetricDetail(const MuscleGrowthView()),
          ),
          const SizedBox(height: 10),
          InsightMetricRow(
            icon: AppIcons.fire,
            title: InsightsStrings.fatReduction,
            subtitle: InsightsStrings.fatReductionSubtitle,
            status: InsightsStrings.fatReductionStatus,
            statusType: InsightStatusType.positive,
            onTap: () => _openMetricDetail(const FatLossView()),
          ),
          const SizedBox(height: 10),
          InsightMetricRow(
            icon: AppIcons.alert,
            title: InsightsStrings.posture,
            subtitle: InsightsStrings.postureSubtitle,
            status: InsightsStrings.postureStatus,
            statusType: InsightStatusType.warning,
            onTap: () => _openMetricDetail(const PostureAnalysisView()),
          ),
          const SizedBox(height: 10),
          InsightMetricRow(
            icon: AppIcons.checkCircle,
            title: InsightsStrings.symmetryScore,
            subtitle: InsightsStrings.symmetrySubtitle,
            status: InsightsStrings.symmetryStatus,
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
  }
}
