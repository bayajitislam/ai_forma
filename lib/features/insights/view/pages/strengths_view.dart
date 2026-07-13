import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_detail_item.dart';
import 'package:ai_forma/features/insights/view/widgets/insights_detail_scaffold.dart';

class StrengthsView extends StatelessWidget {
  const StrengthsView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightsDetailScaffold(
      title: InsightsStrings.strengthsTitle,
      subtitle: InsightsStrings.strengthsSubtitle,
      children: const [
        InsightDetailItem(
          icon: AppIcons.shieldCheck,
          title: InsightsStrings.shoulderDevelopment,
          subtitle: InsightsStrings.shoulderDevelopmentSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.refresh,
          title: InsightsStrings.trainingConsistency,
          subtitle: InsightsStrings.trainingConsistencySubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.plant,
          title: InsightsStrings.upperBodyDevelopment,
          subtitle: InsightsStrings.upperBodyDevelopmentSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.heart,
          title: InsightsStrings.recoveryHabits,
          subtitle: InsightsStrings.recoveryHabitsSubtitle,
        ),
      ],
    );
  }
}
