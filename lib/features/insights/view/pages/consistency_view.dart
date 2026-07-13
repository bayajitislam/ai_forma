import 'package:flutter/material.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_consistency_widgets.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';

class ConsistencyView extends StatelessWidget {
  const ConsistencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightMetricScaffold(
      title: InsightsStrings.consistency,
      children: [
        const InsightScoreSection(
          scoreLabel: InsightsStrings.consistencyScoreLabel,
          score: 90,
          badge: InsightsStrings.excellent,
          badgeType: InsightScoreBadgeType.excellent,
          summary: InsightsStrings.consistencySummary,
        ),
        const SizedBox(height: 20),
        const InsightConsistencyGrid(),
        const SizedBox(height: 16),
        const InsightConsistencyStatsCard(),
        const SizedBox(height: 24),
        const InsightAnalysisSection(
          detected: InsightsStrings.consistencyDetected,
          why: InsightsStrings.consistencyWhy,
          nextSteps: InsightsStrings.consistencyNextSteps,
        ),
        const SizedBox(height: 16),
        const InsightPrioritiesCard(
          priorities: [
            InsightsStrings.consistencyPriority1,
            InsightsStrings.consistencyPriority2,
            InsightsStrings.consistencyPriority3,
          ],
        ),
      ],
    );
  }
}
