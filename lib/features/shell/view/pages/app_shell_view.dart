import 'dart:io';

import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/insights/bindings/insights_binding.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/profile/view/pages/report_bug_view.dart';
import 'package:ai_forma/features/timeline/bindings/timeline_binding.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/features/dashboard/view/pages/dashboard_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_home_view.dart';
import 'package:ai_forma/features/insights/view/pages/insights_view.dart';
import 'package:ai_forma/features/shell/view/widgets/app_shell_header.dart';
import 'package:ai_forma/features/timeline/view/pages/timeline_view.dart';
import 'package:ai_forma/features/profile/view/pages/profile_view.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class AppShellView extends StatefulWidget {
  final AppNavItem initialTab;
  const AppShellView({super.key, this.initialTab = AppNavItem.home});

  @override
  State<AppShellView> createState() => _AppShellViewState();
}

class _AppShellViewState extends State<AppShellView> {
  late AppNavItem _selectedItem;

  // Tracks whether we've already triggered the first fetch for Insights and Timeline.
  bool _insightsFetched = false;
  bool _timelineFetched = false;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialTab;
    if (Get.arguments is AppNavItem) {
      _selectedItem = Get.arguments as AppNavItem;
    }

    // Always register the InsightsController and TimelineController eagerly.
    InsightsBinding().dependencies();
    TimelineBinding().dependencies();

    // If app deep-links directly to Insights or Timeline tab, fetch immediately.
    if (_selectedItem == AppNavItem.insights) {
      _triggerInsightsFetch();
    } else if (_selectedItem == AppNavItem.timeline) {
      _triggerTimelineFetch();
    }
  }

  /// Triggers fetchLatestScan only once per shell lifetime.
  void _triggerInsightsFetch() {
    if (_insightsFetched) return;
    _insightsFetched = true;
    Get.find<InsightsController>().fetchLatestScan();
  }

  /// Triggers Timeline fetch on demand when navigating to Timeline tab.
  void _triggerTimelineFetch({bool force = false}) {
    if (_timelineFetched && !force) return;
    _timelineFetched = true;
    if (Get.isRegistered<TimelineController>()) {
      Get.find<TimelineController>().fetchTimelineData(force: force);
    }
  }

  void navigateToInsights() {
    _triggerInsightsFetch();
    setState(() {
      _selectedItem = AppNavItem.insights;
    });
  }

  final isAndroid = Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackground,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_selectedItem == AppNavItem.home)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: AppShellHeader(),
              ),
            if (_selectedItem != AppNavItem.home)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: AppShellHeader(),
              ),
            Expanded(
              child: IndexedStack(
                index: _selectedItem.index,
                children: [
                  DashboardView(goInsight: navigateToInsights),
                  CheckInHomeView(goInsightPage: navigateToInsights),
                  const InsightsView(),
                  const TimelineView(),
                  const ProfileView(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: isAndroid ? 72 : 56),
        child: FloatingActionButton.small(
          onPressed: () => Get.to(() => const ReportBugView()),
          backgroundColor: AppColors.brandTeal,
          elevation: 4,
          shape: const CircleBorder(),
          child: const AppIcon(
            icon: Remix.bug_line,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, isAndroid ? 16 : 0),
          child: AppNavbar(
            selectedItem: _selectedItem,
            onItemSelected: (item) {
              if (item == AppNavItem.home) {
                if (_selectedItem == AppNavItem.home &&
                    Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().fetchHomeData(force: true);
                }
              } else if (item == AppNavItem.insights) {
                if (_selectedItem == AppNavItem.insights) {
                  // User tapped Insights tab again while already on it → refresh
                  Get.find<InsightsController>().fetchLatestScan();
                } else {
                  // First time navigating to Insights → trigger initial fetch
                  _triggerInsightsFetch();
                }
              } else if (item == AppNavItem.timeline) {
                if (_selectedItem == AppNavItem.timeline) {
                  // User tapped Timeline tab again while already on it → refresh
                  _triggerTimelineFetch(force: true);
                } else {
                  // First time navigating to Timeline → trigger initial fetch
                  _triggerTimelineFetch();
                }
              }
              setState(() => _selectedItem = item);
            },
          ),
        ),
      ),
    );
  }
}
