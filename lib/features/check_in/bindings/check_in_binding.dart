import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:get/get.dart';

class CheckInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckInRepository(Get.find()));
    Get.lazyPut(() => CheckInController(repository: Get.find()));
  }
}
