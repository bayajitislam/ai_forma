import 'package:ai_forma/features/auth/controllers/signup_controller.dart';
import 'package:ai_forma/features/auth/repositories/signup_repository.dart';
import 'package:get/get.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupRepository>(() => SignupRepository(dio: Get.find()));
    Get.lazyPut<SignupController>(
      () => SignupController(signupRepository: Get.find()),
    );
  }
}
