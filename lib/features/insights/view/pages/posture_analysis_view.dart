import 'package:flutter/material.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_posture_widgets.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';

class PostureAnalysisView extends StatelessWidget {
  const PostureAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightMetricScaffold(
      title: InsightsStrings.postureAnalysis,
      children: [
        const InsightScoreSection(
          scoreLabel: InsightsStrings.postureScoreLabel,
          score: 72,
          badge: InsightsStrings.needsAttention,
          badgeType: InsightScoreBadgeType.warning,
          summary: InsightsStrings.postureSummary,
        ),
        const SizedBox(height: 20),
        const InsightPostureComparison(
          beforeLabel: InsightsStrings.postureBefore,
          afterLabel: InsightsStrings.postureAfter,
        ),
        const SizedBox(height: 16),
        const InsightStatusList(
          items: [
            InsightStatusItem(
              label: InsightsStrings.headPosition,
              status: InsightsStrings.headPositionStatus,
              tone: InsightStatusTone.positive,
            ),
            InsightStatusItem(
              label: InsightsStrings.shoulderPosition,
              status: InsightsStrings.shoulderPositionStatus,
              tone: InsightStatusTone.warning,
            ),
            InsightStatusItem(
              label: InsightsStrings.spinalPosition,
              status: InsightsStrings.spinalPositionStatus,
              tone: InsightStatusTone.positive,
            ),
            InsightStatusItem(
              label: InsightsStrings.pelvicTilt,
              status: InsightsStrings.pelvicTiltStatus,
              tone: InsightStatusTone.neutral,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const InsightAnalysisSection(
          detected: InsightsStrings.postureDetected,
          why: InsightsStrings.postureWhy,
          nextSteps: InsightsStrings.postureNextSteps,
        ),
        const SizedBox(height: 16),
        const InsightPrioritiesCard(
          priorities: [
            InsightsStrings.posturePriority1,
            InsightsStrings.posturePriority2,
            InsightsStrings.posturePriority3,
          ],
        ),
      ],
    );
  }
}
