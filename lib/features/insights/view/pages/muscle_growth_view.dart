import 'package:flutter/material.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_stats_card.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_trend_chart.dart';

class MuscleGrowthView extends StatelessWidget {
  const MuscleGrowthView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightMetricScaffold(
      title: InsightsStrings.muscleGrowth,
      children: [
        const InsightScoreSection(
          scoreLabel: InsightsStrings.muscleGrowthScoreLabel,
          score: 78,
          badge: InsightsStrings.progressingWell,
          badgeType: InsightScoreBadgeType.positive,
          summary: InsightsStrings.muscleGrowthSummary,
        ),
        const SizedBox(height: 20),
        const InsightTrendChart(
          dataPoints: [62, 68, 70, 71, 78],
          labels: InsightsStrings.trendDates,
        ),
        const SizedBox(height: 16),
        const InsightStatsCard(
          rows: [
            InsightStatRowData(
              value: '71.5 kg',
              label: InsightsStrings.muscleMass,
              change: '1.8 kg',
              changeDirection: InsightStatChangeDirection.up,
            ),
            InsightStatRowData(
              value: '81.8%',
              label: InsightsStrings.muscleMassPercent,
              change: '1.2%',
              changeDirection: InsightStatChangeDirection.up,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const InsightAnalysisSection(
          detected: InsightsStrings.muscleGrowthDetected,
          why: InsightsStrings.muscleGrowthWhy,
          nextSteps: InsightsStrings.muscleGrowthNextSteps,
        ),
        const SizedBox(height: 16),
        const InsightPrioritiesCard(
          priorities: [
            InsightsStrings.muscleGrowthPriority1,
            InsightsStrings.muscleGrowthPriority2,
            InsightsStrings.muscleGrowthPriority3,
          ],
        ),
      ],
    );
  }
}
