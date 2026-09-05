import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<InsightsRepository>()) {
      Get.put<InsightsRepository>(
        InsightsRepository(
          Get.isRegistered<DioClient>()
              ? Get.find<DioClient>()
              : Get.put(DioClient(), permanent: true),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<InsightsController>()) {
      Get.put<InsightsController>(
        InsightsController(repository: Get.find<InsightsRepository>()),
        permanent: true,
      );
    }
  }
}
