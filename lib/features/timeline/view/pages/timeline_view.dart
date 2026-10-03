import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';
import 'package:ai_forma/features/timeline/view/widgets/progress_trend_section.dart';
import 'package:ai_forma/features/timeline/view/widgets/recent_scans_section.dart';
import 'package:ai_forma/features/timeline/view/widgets/scan_history_tab_view.dart';
import 'package:ai_forma/features/timeline/view/widgets/timeline_overview_skeleton.dart';
import 'package:ai_forma/features/timeline/view/widgets/timeline_tab_bar.dart';
import 'package:ai_forma/features/timeline/view/widgets/trends_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TimelineController>();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Tab Bar
          const TimelineTabBar(),
          // Tab Views
          Expanded(
            child: TabBarView(
              children: [
                // Overview View
                Obx(() {
                  final isLoading = controller.isOverviewLoading.value;
                  final overview = controller.overviewData.value;

                  if (isLoading && overview == null) {
                    return const TimelineOverviewSkeleton();
                  }

                  final recentScans = overview?.recentScans ?? [];
                  final progress = overview?.progress;
                  final chart = overview?.chart;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 24, bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RecentScansSection(
                          recentScans: recentScans,
                          onScanTap: (id) {
                            Get.to(() => ScanDetailView(scanId: id));
                          },
                        ),
                        const SizedBox(height: 28),
                        ProgressTrendSection(progress: progress, chart: chart),
                      ],
                    ),
                  );
                }),
                // Trends View
                const TrendsTabView(),
                // Scan History View
                const ScanHistoryTabView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
