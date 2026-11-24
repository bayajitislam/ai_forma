import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppShellController extends GetxController {
  final Rx<AppNavItem> selectedItem = AppNavItem.home.obs;

  bool _insightsFetched = false;
  bool _timelineFetched = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is AppNavItem) {
      selectedItem.value = Get.arguments as AppNavItem;
    }

    // Tabs are built lazily, but Begin Scan on the Check-In tab reads
    // HomeController.homeData to decide whether to ask for scan-day weight.
    // Create it now so /api/home/ starts loading when the shell opens.
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedItem.value == AppNavItem.insights) {
        triggerInsightsFetch(force: true);
      } else if (selectedItem.value == AppNavItem.timeline) {
        triggerTimelineFetch(force: true);
      }
    });
  }

  void triggerInsightsFetch({bool force = false, String? scanId}) {
    if (_insightsFetched && !force) return;
    if (!Get.isRegistered<InsightsController>()) return;
    // Only mark as fetched once a fetch actually started, so a skipped fetch
    // is retried the next time the tab opens instead of leaving it empty.
    _insightsFetched = true;
    Get.find<InsightsController>().fetchLatestScan(scanId: scanId);
  }

  void triggerTimelineFetch({bool force = false}) {
    if (_timelineFetched && !force) return;
    if (!Get.isRegistered<TimelineController>()) return;
    _timelineFetched = true;
    Get.find<TimelineController>().fetchTimelineData(force: force);
  }

  void navigateToInsights({String? scanId}) {
    triggerInsightsFetch(force: true, scanId: scanId);
    selectedItem.value = AppNavItem.insights;
  }

  void onTabSelected(AppNavItem item) {
    if (item == AppNavItem.home) {
      if (selectedItem.value == AppNavItem.home &&
          Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData(force: true);
      }
    } else if (item == AppNavItem.insights) {
      if (selectedItem.value == AppNavItem.insights) {
        if (Get.isRegistered<InsightsController>()) {
          Get.find<InsightsController>().fetchLatestScan();
        } else {
          triggerInsightsFetch(force: true);
        }
      } else {
        triggerInsightsFetch();
      }
    } else if (item == AppNavItem.timeline) {
      if (selectedItem.value == AppNavItem.timeline) {
        if (Get.isRegistered<TimelineController>()) {
          Get.find<TimelineController>().fetchTimelineData(force: true);
        } else {
          triggerTimelineFetch(force: true);
        }
      } else {
        triggerTimelineFetch();
      }
    }
    selectedItem.value = item;
  }
}
