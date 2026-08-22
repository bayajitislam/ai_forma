import 'package:get/get.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/repositories/timeline_repository.dart';

class TimelineBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TimelineController>()) {
      Get.put<TimelineController>(
        TimelineController(
          repository: TimelineRepository(
            Get.isRegistered<DioClient>()
                ? Get.find<DioClient>()
                : DioClient(),
          ),
        ),
      );
    }
  }
}
