import 'package:ai_forma/features/insights/models/symmetry_detail_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class SymmetryController extends GetxController {
  final InsightsRepository repository;
  SymmetryController({required this.repository});

  final Rx<SymmetryDetailResponseModel?> detail =
      Rx<SymmetryDetailResponseModel?>(null);
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
      final result = await repository.getSymmetryDetail();
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
