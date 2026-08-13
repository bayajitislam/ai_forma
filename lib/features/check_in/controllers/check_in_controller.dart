import 'package:get/get.dart';

class CheckInController extends GetxController {
  final RxString selectedCheckDay = 'Sunday'.obs;

  void setCheckDay(String day) {
    selectedCheckDay.value = day;
  }
}
