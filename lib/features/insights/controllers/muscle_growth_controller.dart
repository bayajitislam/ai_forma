import 'package:ai_forma/features/insights/models/muscle_growth_detail_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class MuscleGrowthController extends GetxController {
  final InsightsRepository repository;
  MuscleGrowthController({required this.repository});

  final Rx<MuscleGrowthDetailResponseModel?> detail =
      Rx<MuscleGrowthDetailResponseModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading(true);
    errorMessage('');
    try {
      final result = await repository.getMuscleGrowthDetail();
      result.fold(
        (failure) => errorMessage(failure.message),
        (data) => detail.value = data,
      );
    } catch (e) {
      errorMessage('Something went wrong. Please try again.');
    } finally {
      isLoading(false);
    }
  }
}
