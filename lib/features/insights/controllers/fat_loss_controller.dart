import 'package:ai_forma/features/insights/models/fat_loss_detail_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class FatLossController extends GetxController {
  final InsightsRepository repository;
  FatLossController({required this.repository});

  final Rx<FatLossDetailResponseModel?> detail =
      Rx<FatLossDetailResponseModel?>(null);
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
      final result = await repository.getFatLossDetail();
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
