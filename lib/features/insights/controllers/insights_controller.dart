import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class InsightsController extends GetxController {
  final InsightsRepository repository;
  InsightsController({required this.repository});

  final Rx<ScanLatestResponseModel?> latestScan =
      Rx<ScanLatestResponseModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;


  /// Fetch latest scan insights from backend GET /api/scans/latest/
  Future<void> fetchLatestScan() async {
    isLoading(true);
    errorMessage('');
    try {
      final result = await repository.getLatestScan();
      result.fold(
        (failure) => errorMessage(failure.message),
        (data) => latestScan.value = data,
      );
    } catch (e) {
      errorMessage('Something went wrong. Please try again.');
    } finally {
      isLoading(false);
    }
  }
}
