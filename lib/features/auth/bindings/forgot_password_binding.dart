import 'package:ai_forma/features/auth/controllers/forgot_password_controller.dart';
import 'package:ai_forma/features/auth/repositories/forgot_password_repository.dart';
import 'package:get/get.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordRepository(Get.find()));
    Get.lazyPut(() => ForgotPasswordController(repository: Get.find()));
  }
}
