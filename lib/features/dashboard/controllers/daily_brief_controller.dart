import 'package:get/get.dart';

enum SleepQuality { excellent, good, average, poor }

class DailyBriefController extends GetxController {
  // Daily brief response state
  final Rxn<SleepQuality> selectedSleep = Rxn<SleepQuality>();
  final RxBool isAnswered = false.obs;

  // Scan state (toggleable for demo / dynamic flow)
  final RxInt daysUntilScan = 6.obs;
  final RxBool isScanReady = false.obs;
  final RxBool isScanOverdue = false.obs;

  void saveResponse(SleepQuality quality) {
    selectedSleep.value = quality;
    isAnswered.value = true;
  }

  void resetResponse() {
    isAnswered.value = false;
  }
}
