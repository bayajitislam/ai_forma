import 'package:flutter/material.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_analysis_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_metric_scaffold.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_score_section.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_stats_card.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_trend_chart.dart';

class FatLossView extends StatelessWidget {
  const FatLossView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightMetricScaffold(
      title: InsightsStrings.fatLoss,
      children: [
        const InsightScoreSection(
          scoreLabel: InsightsStrings.fatLossScoreLabel,
          score: 75,
          badge: InsightsStrings.progressingWell,
          badgeType: InsightScoreBadgeType.positive,
          summary: InsightsStrings.fatLossSummary,
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
              value: '18.2%',
              label: InsightsStrings.bodyFatPercent,
              change: '2.4%',
              changeDirection: InsightStatChangeDirection.down,
              changeIsPositive: true,
            ),
            InsightStatRowData(
              value: '15.9 kg',
              label: InsightsStrings.fatMass,
              change: '2.1 kg',
              changeDirection: InsightStatChangeDirection.down,
              changeIsPositive: true,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const InsightAnalysisSection(
          detected: InsightsStrings.fatLossDetected,
          why: InsightsStrings.fatLossWhy,
          nextSteps: InsightsStrings.fatLossNextSteps,
        ),
        const SizedBox(height: 16),
        const InsightPrioritiesCard(
          priorities: [
            InsightsStrings.fatLossPriority1,
            InsightsStrings.fatLossPriority2,
            InsightsStrings.fatLossPriority3,
          ],
        ),
      ],
    );
  }
}
