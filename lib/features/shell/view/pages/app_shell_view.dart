import 'dart:io';

import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_home_view.dart';
import 'package:ai_forma/features/dashboard/view/pages/dashboard_view.dart';
import 'package:ai_forma/features/insights/view/pages/insights_view.dart';
import 'package:ai_forma/features/profile/view/pages/profile_view.dart';
import 'package:ai_forma/features/profile/view/pages/report_bug_view.dart';
import 'package:ai_forma/features/shell/controllers/app_shell_controller.dart';
import 'package:ai_forma/features/shell/view/widgets/app_shell_header.dart';
import 'package:ai_forma/features/timeline/view/pages/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class AppShellView extends StatelessWidget {
  final AppNavItem initialTab;
  const AppShellView({super.key, this.initialTab = AppNavItem.home});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AppShellController>()
        ? Get.find<AppShellController>()
        : Get.put(AppShellController());

    if (initialTab != AppNavItem.home &&
        controller.selectedItem.value == AppNavItem.home) {
      controller.selectedItem.value = initialTab;
    }

    final isAndroid = Platform.isAndroid;

    return Obx(() {
      final selectedItem = controller.selectedItem.value;

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
                  selectedItem == AppNavItem.home ? 0 : 16,
                ),
                child: AppShellHeader(
                  showProfileOption: selectedItem == AppNavItem.home,
                  onProfileTap: () {
                    controller.selectedItem.value = AppNavItem.profile;
                  },
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: selectedItem.index,
                  children: [
                    DashboardView(
                      goInsight: ({scanId}) =>
                          controller.navigateToInsights(scanId: scanId),
                    ),
                    CheckInHomeView(
                      goInsightPage: () => controller.navigateToInsights(),
                    ),
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
              selectedItem: selectedItem,
              onItemSelected: controller.onTabSelected,
            ),
          ),
        ),
      );
    });
  }
}
