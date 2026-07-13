import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/timeline/view/widgets/recent_scans_section.dart';
import 'package:ai_forma/features/timeline/view/widgets/progress_trend_section.dart';

import 'package:ai_forma/features/timeline/view/widgets/trends_tab_view.dart';
import 'package:ai_forma/features/timeline/view/widgets/scan_history_tab_view.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.progressInactive, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
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
              Tab(text: 'Overview'),
              Tab(text: 'Trends'),
              Tab(text: 'Scan History'),
            ],
          ),
        ),
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Overview View
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 24, bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecentScansSection(),
                    SizedBox(height: 28),
                    ProgressTrendSection(),
                  ],
                ),
              ),
              // Trends View
              TrendsTabView(),
              // Scan History View
              ScanHistoryTabView(),
            ],
          ),
        ),
      ],
    );
  }
}
