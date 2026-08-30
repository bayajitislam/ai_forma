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

  /// Submit Daily Brief Answer to POST or PATCH /api/checkins/daily/ and refresh Home
  Future<({bool success, String message})> submitDailyBriefAnswer({
    required String questionKey,
    required String selectedOption,
    double? weightKg,
    bool? alreadyAnswered,
  }) async {
    isSubmittingAnswer(true);
    try {
      final isAlreadyAnswered = alreadyAnswered ??
          homeData.value?.dailyBrief?.alreadyAnswered ??
          homeData.value?.todayPriority?.alreadyAnswered ??
          false;

      final result = await repository.submitDailyAnswer(
        questionKey: questionKey,
        selectedOption: selectedOption,
        weightKg: weightKg,
        alreadyAnswered: isAlreadyAnswered,
      );

      return result.fold(
        (failure) {
          return (success: false, message: failure.message);
        },
        (data) {
          fetchHomeData(force: true);
          return (success: true, message: 'Response saved successfully');
        },
      );
    } catch (e) {
      return (success: false, message: 'Failed to submit answer.');
    } finally {
      isSubmittingAnswer(false);
    }
  }

  /// Submit Scan Day Weight to POST /api/checkins/cycle-weight/ and refresh Home
  Future<({bool success, String message})> submitScanDayWeight({
    required double weightKg,
    int? cycleId,
  }) async {
    isSubmittingAnswer(true);
    try {
      final result = await repository.submitScanDayWeight(
        weightKg: weightKg,
        cycleId: cycleId,
      );

      return result.fold(
        (failure) {
          return (success: false, message: failure.message);
        },
        (data) {
          fetchHomeData(force: true);
          return (
            success: true,
            message: 'Scan day weight recorded successfully.'
          );
        },
      );
    } catch (e) {
      return (success: false, message: 'Failed to record weight.');
    } finally {
      isSubmittingAnswer(false);
    }
  }
}
