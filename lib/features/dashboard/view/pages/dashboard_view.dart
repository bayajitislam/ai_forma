import 'package:flutter/material.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_insight_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/latest_check_in_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/metric_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/dashboard_header.dart';
import 'package:ai_forma/features/dashboard/view/widgets/momentum_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/sparkline_chart.dart';
import 'package:ai_forma/features/dashboard/view/widgets/todays_priority_card.dart';

import 'package:get/get.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/view/pages/weight_trends_view.dart';

class DashboardView extends StatelessWidget {
  final void Function()? goInsight;
  const DashboardView({super.key, required this.goInsight});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeightController());
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const SizedBox(height: 16),
          const MomentumCard(),
          const SizedBox(height: 16),
          const TodaysPriorityCard(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WeightTrendsView()),
                    );
                  },
                  child: Obx(() {
                    final currentWeight = controller.currentWeight;
                    return MetricCard(
                      label: DashboardStrings.currentWeight,
                      value: currentWeight != null ? '${currentWeight.weightKg.toStringAsFixed(1)} kg' : '-',
                      trendText: controller.weightChangeSinceLastString,
                    );
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  return MetricCard(
                    label: DashboardStrings.weeklyChange,
                    value: controller.weightChangeSinceLastString,
                    caption: DashboardStrings.weeklyChangeCaption,
                    child: const SparklineChart(),
                  );
                }),
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
