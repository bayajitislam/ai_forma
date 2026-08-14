import 'package:ai_forma/features/auth/controllers/login_controller.dart';
import 'package:ai_forma/features/auth/repositories/login_repository.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginRepository(Get.find()));
    Get.lazyPut(() => LoginController(loginRepository: Get.find()));
  }
}
