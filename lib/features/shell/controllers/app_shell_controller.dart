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
    _insightsFetched = true;
    if (Get.isRegistered<InsightsController>()) {
      Get.find<InsightsController>().fetchLatestScan(scanId: scanId);
    }
  }

  void triggerTimelineFetch({bool force = false}) {
    if (_timelineFetched && !force) return;
    _timelineFetched = true;
    if (Get.isRegistered<TimelineController>()) {
      Get.find<TimelineController>().fetchTimelineData(force: force);
    }
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
