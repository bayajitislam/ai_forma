import 'package:flutter/material.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_insight_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/latest_check_in_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/metric_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/momentum_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/sparkline_chart.dart';
import 'package:ai_forma/features/dashboard/view/widgets/todays_priority_card.dart';

class DashboardView extends StatelessWidget {
  final void Function()? goInsight;
  const DashboardView({super.key, required this.goInsight});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MomentumCard(),
          const SizedBox(height: 16),
          const TodaysPriorityCard(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MetricCard(
                  label: DashboardStrings.currentWeight,
                  value: DashboardStrings.currentWeightValue,
                  trendText: DashboardStrings.weightChange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: DashboardStrings.weeklyChange,
                  value:DashboardStrings.weeklyChangeValue ,
                  caption: DashboardStrings.weeklyChangeCaption,
                  child: const SparklineChart(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LatestCheckInCard(),
          const SizedBox(height: 16),
          AiInsightCard(goInsightPage: goInsight),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
