import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:get/get.dart';

/// Sole registration site for [CheckInController].
///
/// The check-in tab subscribes for the whole shell session, so this instance
/// stays alive. Scan screens clear the camera and photos on [CheckInController.releaseScanSession].
class CheckInBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CheckInRepository>()) {
      Get.put<CheckInRepository>(CheckInRepository(Get.find()), permanent: true);
    }
    if (!Get.isRegistered<CheckInController>()) {
      Get.put<CheckInController>(
        CheckInController(repository: Get.find()),
        permanent: true,
      );
    }
  }
}
