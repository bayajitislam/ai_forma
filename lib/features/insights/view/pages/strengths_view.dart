import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_detail_item.dart';
import 'package:ai_forma/features/insights/view/widgets/insights_detail_scaffold.dart';

class StrengthsView extends StatelessWidget {
  final List<InsightTitleSubtitleItem>? items;

  const StrengthsView({super.key, this.items});

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
            icon: AppIcons.shieldCheck,
            title: items![i].title,
            subtitle: items![i].subtitle,
          ),
        );
      }
    } else {
      contentChildren = const [
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
      ];
    }

    return InsightsDetailScaffold(
      title: InsightsStrings.strengthsTitle,
      subtitle: InsightsStrings.strengthsSubtitle,
      children: contentChildren,
    );
  }
}
