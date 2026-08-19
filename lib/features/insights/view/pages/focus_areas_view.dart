import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_detail_item.dart';
import 'package:ai_forma/features/insights/view/widgets/insights_detail_scaffold.dart';

class FocusAreasView extends StatelessWidget {
  final List<InsightTitleSubtitleItem>? items;

  const FocusAreasView({super.key, this.items});

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
            icon: AppIcons.fire,
            title: items![i].title,
            subtitle: items![i].subtitle,
          ),
        );
      }
    } else {
      contentChildren = const [
        InsightDetailItem(
          icon: AppIcons.fire,
          title: InsightsStrings.lowerAbs,
          subtitle: InsightsStrings.lowerAbsSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.pulse,
          title: InsightsStrings.gluteDevelopment,
          subtitle: InsightsStrings.gluteDevelopmentSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.footprint,
          title: InsightsStrings.calves,
          subtitle: InsightsStrings.calvesSubtitle,
        ),
        SizedBox(height: 12),
        InsightDetailItem(
          icon: AppIcons.user,
          title: InsightsStrings.postureFocus,
          subtitle: InsightsStrings.postureFocusSubtitle,
        ),
      ];
    }

    return InsightsDetailScaffold(
      title: InsightsStrings.focusAreasTitle,
      subtitle: InsightsStrings.focusAreasSubtitle,
      children: contentChildren,
    );
  }
}
