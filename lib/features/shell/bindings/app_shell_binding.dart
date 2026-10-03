import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/profile/controllers/profile_controller.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/repositories/timeline_repository.dart';
import 'package:ai_forma/features/shell/controllers/app_shell_controller.dart';
import 'package:get/get.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppShellController>()) {
      Get.lazyPut<AppShellController>(() => AppShellController());
    }

    // 1. Dashboard
    if (!Get.isRegistered<DashboardRepository>()) {
      Get.lazyPut<DashboardRepository>(
        () => DashboardRepository(Get.find<DioClient>()),
      );
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(repository: Get.find<DashboardRepository>()),
      );
    }

    // 2. Check-In
    if (!Get.isRegistered<CheckInRepository>()) {
      Get.lazyPut<CheckInRepository>(
        () => CheckInRepository(Get.find<DioClient>()),
      );
    }
    if (!Get.isRegistered<CheckInController>()) {
      Get.lazyPut<CheckInController>(
        () => CheckInController(repository: Get.find<CheckInRepository>()),
      );
    }

    // 3. Insights
    if (!Get.isRegistered<InsightsRepository>()) {
      Get.lazyPut<InsightsRepository>(
        () => InsightsRepository(Get.find<DioClient>()),
      );
    }
    if (!Get.isRegistered<InsightsController>()) {
      Get.lazyPut<InsightsController>(
        () => InsightsController(repository: Get.find<InsightsRepository>()),
      );
    }
    // 4. Timeline
    if (!Get.isRegistered<TimelineRepository>()) {
      Get.lazyPut<TimelineRepository>(
        () => TimelineRepository(Get.find<DioClient>()),
      );
    }
    if (!Get.isRegistered<TimelineController>()) {
      Get.lazyPut<TimelineController>(
        () => TimelineController(repository: Get.find<TimelineRepository>()),
      );
    }

    // 5. Profile
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
  }
}
