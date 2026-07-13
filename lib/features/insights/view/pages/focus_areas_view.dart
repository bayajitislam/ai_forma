import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/widgets/insight_detail_item.dart';
import 'package:ai_forma/features/insights/view/widgets/insights_detail_scaffold.dart';

class FocusAreasView extends StatelessWidget {
  const FocusAreasView({super.key});

  @override
  Widget build(BuildContext context) {
    return InsightsDetailScaffold(
      title: InsightsStrings.focusAreasTitle,
      subtitle: InsightsStrings.focusAreasSubtitle,
      children: const [
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
      ],
    );
  }
}
