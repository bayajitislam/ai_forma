import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_detail_item.dart';
import 'package:ai_forma/features/insights/view/widgets/insights_detail_scaffold.dart';

class NextStepView extends StatelessWidget {
  const NextStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightsDetailScaffold(
      title: InsightsStrings.nextStepsTitle,
      subtitle: InsightsStrings.nextStepsSubtitle,
      children: const [
        InsightDetailItem(
          icon: AppIcons.apple,
          title: InsightsStrings.nutrition,
          subtitle: InsightsStrings.nutritionSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.plant,
          title: InsightsStrings.training,
          subtitle: InsightsStrings.trainingSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.refresh,
          title: InsightsStrings.cardio,
          subtitle: InsightsStrings.cardioSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.arrowUpRight,
          title: InsightsStrings.recovery,
          subtitle: InsightsStrings.recoverySubtitle,
        ),
      ],
    );
  }
}
