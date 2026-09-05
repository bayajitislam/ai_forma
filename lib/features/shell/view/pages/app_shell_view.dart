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

    // If app deep-links directly to Insights or Timeline tab, fetch after initial frame renders.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_selectedItem == AppNavItem.insights) {
        _triggerInsightsFetch(force: true);
      } else if (_selectedItem == AppNavItem.timeline) {
        _triggerTimelineFetch(force: true);
      }
    });
  }

  /// Triggers fetchLatestScan (supports force refresh and optional scanId).
  void _triggerInsightsFetch({bool force = false, String? scanId}) {
    if (_insightsFetched && !force) return;
    _insightsFetched = true;
    if (!Get.isRegistered<InsightsController>()) {
      InsightsBinding().dependencies();
    }
    if (Get.isRegistered<InsightsController>()) {
      Get.find<InsightsController>().fetchLatestScan(scanId: scanId);
    }
  }

  /// Triggers Timeline fetch on demand when navigating to Timeline tab.
  void _triggerTimelineFetch({bool force = false}) {
    if (_timelineFetched && !force) return;
    _timelineFetched = true;
    if (!Get.isRegistered<TimelineController>()) {
      TimelineBinding().dependencies();
    }
    if (Get.isRegistered<TimelineController>()) {
      Get.find<TimelineController>().fetchTimelineData(force: force);
    }
  }

  void navigateToInsights({String? scanId}) {
    _triggerInsightsFetch(force: true, scanId: scanId);
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                _selectedItem == AppNavItem.home ? 0 : 16,
              ),
              child: AppShellHeader(
                showProfileOption: _selectedItem == AppNavItem.home,
                onProfileTap: () {
                  setState(() => _selectedItem = AppNavItem.profile);
                },
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedItem.index,
                children: [
                  DashboardView(
                    goInsight: ({scanId}) => navigateToInsights(scanId: scanId),
                  ),
                  CheckInHomeView(goInsightPage: () => navigateToInsights()),
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
                  if (Get.isRegistered<InsightsController>()) {
                    Get.find<InsightsController>().fetchLatestScan();
                  } else {
                    _triggerInsightsFetch(force: true);
                  }
                } else {
                  // First time navigating to Insights → trigger initial fetch
                  _triggerInsightsFetch();
                }
              } else if (item == AppNavItem.timeline) {
                if (_selectedItem == AppNavItem.timeline) {
                  // User tapped Timeline tab again while already on it → refresh
                  if (Get.isRegistered<TimelineController>()) {
                    Get.find<TimelineController>().fetchTimelineData(force: true);
                  } else {
                    _triggerTimelineFetch(force: true);
                  }
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
