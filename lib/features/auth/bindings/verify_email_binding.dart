import 'package:ai_forma/features/auth/controllers/verify_email_controller.dart';
import 'package:ai_forma/features/auth/repositories/verify_email_repository.dart';
import 'package:get/get.dart';

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyEmailRepository(dio: Get.find()));
    Get.lazyPut(() => VerifyEmailController(verifyEmailRepository: Get.find()));
  }
}
