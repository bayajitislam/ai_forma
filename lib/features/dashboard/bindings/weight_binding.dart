import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:get/get.dart';

class WeightBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WeightController>()) {
      Get.lazyPut<WeightController>(() => WeightController(Get.find<DioClient>()));
    }
  }
}

class WeeklyProgressBinding extends Bindings {
  @override
  void dependencies() {
    final controller = Get.isRegistered<WeightController>()
        ? Get.find<WeightController>()
        : Get.put<WeightController>(WeightController(Get.find<DioClient>()));
    controller.setTimeRange(TimeRange.week1, isProgressMode: true);
  }
}

