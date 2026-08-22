import 'package:ai_forma/features/insights/models/posture_detail_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class PostureController extends GetxController {
  final InsightsRepository repository;
  PostureController({required this.repository});

  final Rx<PostureDetailResponseModel?> detail =
      Rx<PostureDetailResponseModel?>(null);
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
      final result = await repository.getPostureDetail();
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
