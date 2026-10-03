import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:get/get.dart';

/// Global initial bindings registered for core services across the application.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    init();
  }

  /// Initialize core dependencies permanently.
  static void init() {
    if (!Get.isRegistered<DioClient>()) {
      Get.put(DioClient(), permanent: true);
    }
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController(Get.find<DioClient>()), permanent: true);
    }
  }
}
