import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_detail_item.dart';
import 'package:ai_forma/features/insights/view/widgets/insights_detail_scaffold.dart';

class NextStepView extends StatelessWidget {
  final List<InsightTitleSubtitleItem>? items;

  const NextStepView({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    final List<Widget> contentChildren;

    if (items != null && items!.isNotEmpty) {
      contentChildren = [];
      for (int i = 0; i < items!.length; i++) {
        if (i > 0) {
          contentChildren.add(const SizedBox(height: 12));
        }
        contentChildren.add(
          InsightDetailItem(
            icon: AppIcons.cpu,
            title: items![i].title,
            subtitle: items![i].subtitle,
          ),
        );
      }
    } else {
      contentChildren = const [
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
      ];
    }

    return InsightsDetailScaffold(
      title: InsightsStrings.nextStepsTitle,
      subtitle: InsightsStrings.nextStepsSubtitle,
      children: contentChildren,
    );
  }
}
