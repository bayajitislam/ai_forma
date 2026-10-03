import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class InsightsController extends GetxController {
  final InsightsRepository repository;
  InsightsController({required this.repository});

  final Rx<ScanLatestResponseModel?> latestScan = Rx<ScanLatestResponseModel?>(
    null,
  );
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Fetch latest scan insights from backend GET /api/scans/latest/ (optional scanId)
  Future<void> fetchLatestScan({String? scanId, bool force = false}) async {
    if (isLoading.value && !force) return;
    try {
      isLoading(true);
      errorMessage('');
      final result = await repository.getLatestScan(scanId: scanId);
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
