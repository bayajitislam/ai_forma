import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:ai_forma/features/onboarding_assessment/repositories/assessment_repository.dart';
import 'package:get/get.dart';

class AssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssessmentRepository(Get.find()));
    Get.lazyPut(() => AssessmentController(assessmentRepository: Get.find()));
  }
}
