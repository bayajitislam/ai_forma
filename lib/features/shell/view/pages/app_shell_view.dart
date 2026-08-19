import 'dart:io';

import 'package:ai_forma/features/insights/bindings/insights_binding.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
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

class AppShellView extends StatefulWidget {
  final AppNavItem initialTab;
  const AppShellView({super.key, this.initialTab = AppNavItem.home});

  @override
  State<AppShellView> createState() => _AppShellViewState();
}

class _AppShellViewState extends State<AppShellView> {
  late AppNavItem _selectedItem;

  // Tracks whether we've already triggered the first fetch for Insights.
  bool _insightsFetched = false;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialTab;
    if (Get.arguments is AppNavItem) {
      _selectedItem = Get.arguments as AppNavItem;
    }

    // Always register the InsightsController eagerly so InsightsView
    // can always find it on its first build (IndexedStack builds all children).
    // No API call happens here — fetchLatestScan is triggered manually below.
    InsightsBinding().dependencies();

    // If app deep-links directly to Insights tab, fetch immediately.
    if (_selectedItem == AppNavItem.insights) {
      _triggerInsightsFetch();
    }
  }

  /// Triggers fetchLatestScan only once per shell lifetime.
  void _triggerInsightsFetch() {
    if (_insightsFetched) return;
    _insightsFetched = true;
    Get.find<InsightsController>().fetchLatestScan();
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, isAndroid ? 16 : 0),
          child: AppNavbar(
            selectedItem: _selectedItem,
            onItemSelected: (item) {
              if (item == AppNavItem.insights) {
                if (_selectedItem == AppNavItem.insights) {
                  // User tapped Insights tab again while already on it → refresh
                  Get.find<InsightsController>().fetchLatestScan();
                } else {
                  // First time navigating to Insights → trigger initial fetch
                  _triggerInsightsFetch();
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
