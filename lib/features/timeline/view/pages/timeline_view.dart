import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/repositories/timeline_repository.dart';
import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';
import 'package:ai_forma/features/timeline/view/widgets/progress_trend_section.dart';
import 'package:ai_forma/features/timeline/view/widgets/recent_scans_section.dart';
import 'package:ai_forma/features/timeline/view/widgets/scan_history_tab_view.dart';
import 'package:ai_forma/features/timeline/view/widgets/trends_tab_view.dart';

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
    final controller = Get.isRegistered<TimelineController>()
        ? Get.find<TimelineController>()
        : Get.put(
            TimelineController(
              repository: TimelineRepository(
                Get.isRegistered<DioClient>()
                    ? Get.find<DioClient>()
                    : DioClient(),
              ),
            ),
          );

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
            children: [
              // Overview View
              Obx(() {
                final isLoading = controller.isOverviewLoading.value;
                final overview = controller.overviewData.value;

                if (isLoading && overview == null) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 24, bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: 140,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 175,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    width: 96,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 60,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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
    );
  }
}
