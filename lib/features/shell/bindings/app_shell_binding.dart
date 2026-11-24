import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/check_in/bindings/check_in_binding.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/profile/controllers/profile_controller.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/repositories/timeline_repository.dart';
import 'package:ai_forma/features/shell/controllers/app_shell_controller.dart';
import 'package:get/get.dart';

/// Registers everything the app shell and its tabs look up.
///
/// Do not guard these with `Get.isRegistered`. The shell is re-entered with
/// `Get.offAllNamed(appShell)` while the old shell route is still alive (after
/// a weekly scan, from a push notification, and from AppErrorWidget). At that
/// moment the old controllers are still registered but marked for deletion,
/// and GetX deletes them as soon as the old route is disposed.
///
/// An unconditional `lazyPut` is a no-op when a live instance exists, and when
/// the existing one is marked for deletion GetX registers a fresh replacement
/// for the new route. `fenix: true` also rebuilds a controller on its next
/// `Get.find` if it was deleted anyway. A guarded `lazyPut` skips both, so the
/// new shell's tabs threw `"HomeController" not found` and showed the
/// full-screen "Something went wrong" error after every weekly scan.
class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppShellController>(() => AppShellController(), fenix: true);

    // 1. Dashboard
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepository(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(repository: Get.find<DashboardRepository>()),
      fenix: true,
    );

    // 2. Check-In. Owned by CheckInBinding for the whole time the home tab is mounted.
    CheckInBinding().dependencies();

    // 3. Insights
    Get.lazyPut<InsightsRepository>(
      () => InsightsRepository(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<InsightsController>(
      () => InsightsController(repository: Get.find<InsightsRepository>()),
      fenix: true,
    );

    // 4. Timeline
    Get.lazyPut<TimelineRepository>(
      () => TimelineRepository(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<TimelineController>(
      () => TimelineController(repository: Get.find<TimelineRepository>()),
      fenix: true,
    );

    // 5. Profile
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
