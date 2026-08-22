import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final DashboardRepository repository;
  HomeController({required this.repository});

  final Rx<HomeResponseModel?> homeData = Rx<HomeResponseModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSubmittingAnswer = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  /// Fetch Home tab data from GET /api/home/
  Future<void> fetchHomeData({bool force = false}) async {
    if (!force && homeData.value != null && !isLoading.value) return;

    isLoading(true);
    errorMessage('');

    try {
      final result = await repository.getHomeData();
      result.fold(
        (failure) => errorMessage(failure.message),
        (data) => homeData.value = data,
      );
    } catch (e) {
      errorMessage('Failed to load Home data.');
    } finally {
      isLoading(false);
    }
  }

  /// Submit Daily Brief Answer to POST /api/checkins/daily/ and refresh Home
  Future<bool> submitDailyBriefAnswer({
    required String questionKey,
    required String selectedOption,
    double? weightKg,
  }) async {
    isSubmittingAnswer(true);
    try {
      final result = await repository.submitDailyAnswer(
        questionKey: questionKey,
        selectedOption: selectedOption,
        weightKg: weightKg,
      );

      return result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
          return false;
        },
        (data) {
          fetchHomeData(force: true);
          return true;
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit answer.');
      return false;
    } finally {
      isSubmittingAnswer(false);
    }
  }
}
