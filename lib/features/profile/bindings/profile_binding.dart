import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/profile/controllers/bug_report_controller.dart';
import 'package:ai_forma/features/profile/controllers/profile_controller.dart';
import 'package:ai_forma/features/profile/repositories/bug_report_repository.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    if (!Get.isRegistered<BugReportRepository>()) {
      Get.lazyPut<BugReportRepository>(
        () => BugReportRepository(
          Get.isRegistered<DioClient>() ? Get.find<DioClient>() : DioClient(),
        ),
      );
    }
    if (!Get.isRegistered<BugReportController>()) {
      Get.lazyPut<BugReportController>(
        () => BugReportController(
          repository: Get.find<BugReportRepository>(),
        ),
      );
    }
  }
}
