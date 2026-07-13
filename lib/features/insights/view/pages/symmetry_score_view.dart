import 'package:flutter/material.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_symmetry_body_map.dart';

class SymmetryScoreView extends StatelessWidget {
  const SymmetryScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightMetricScaffold(
      title: InsightsStrings.symmetryScore,
      children: [
        const InsightScoreSection(
          scoreLabel: InsightsStrings.symmetryScoreLabel,
          score: 78,
          badge: InsightsStrings.good,
          badgeType: InsightScoreBadgeType.good,
          summary: InsightsStrings.symmetrySummary,
        ),
        const SizedBox(height: 20),
        const InsightSymmetryBodyMap(),
        const SizedBox(height: 24),
        const InsightAnalysisSection(
          detected: InsightsStrings.symmetryDetected,
          why: InsightsStrings.symmetryWhy,
          nextSteps: InsightsStrings.symmetryNextSteps,
        ),
        const SizedBox(height: 16),
        const InsightPrioritiesCard(
          priorities: [
            InsightsStrings.symmetryPriority1,
            InsightsStrings.symmetryPriority2,
            InsightsStrings.symmetryPriority3,
          ],
        ),
      ],
    );
  }
}
