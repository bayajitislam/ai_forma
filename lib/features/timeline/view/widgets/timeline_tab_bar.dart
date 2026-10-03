import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/timeline/constants/timeline_strings.dart';
import 'package:flutter/material.dart';

class TimelineTabBar extends StatelessWidget {
  final TabController? controller;

  const TimelineTabBar({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.progressInactive, width: 1),
        ),
      ),
      child: TabBar(
        controller: controller,
        indicatorColor: AppColors.brandTeal,
        indicatorWeight: 3,
        labelColor: AppColors.brandTeal,
        unselectedLabelColor: AppColors.textSecondary,
        dividerColor: AppColors.cardBorder,
        labelStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: TimelineStrings.overviewTab),
          Tab(text: TimelineStrings.trendsTab),
          Tab(text: TimelineStrings.scanHistoryTab),
        ],
      ),
    );
  }
}
