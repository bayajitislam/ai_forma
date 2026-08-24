import 'package:ai_forma/features/insights/models/compare_result_model.dart';
import 'package:ai_forma/features/insights/models/compare_scans_list_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:get/get.dart';

class CompareScansController extends GetxController {
  final InsightsRepository repository;
  CompareScansController({required this.repository});

  // Scans List State
  final RxList<CompareScanItemModel> scansList = <CompareScanItemModel>[].obs;
  final RxBool isLoadingScans = false.obs;
  final RxString scansError = ''.obs;

  // Selected Scan IDs (up to 2)
  final RxSet<String> selectedIds = <String>{}.obs;

  // Comparison Result State
  final Rx<CompareResultResponseModel?> comparisonResult =
      Rx<CompareResultResponseModel?>(null);
  final RxBool isComparing = false.obs;
  final RxString compareError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchScansList();
  }

  /// Fetch completed scans list from GET /api/scans/
  Future<void> fetchScansList() async {
    isLoadingScans(true);
    scansError('');
    try {
      final result = await repository.getScansList();
      result.fold(
        (failure) => scansError(failure.message),
        (data) {
          // Filter to completed scans only
          final completedScans = data.results
              .where((item) => item.status.toLowerCase() == 'completed')
              .toList();
          scansList.assignAll(completedScans);

          // Auto-select the 2 most recent completed scans if available
          if (completedScans.length >= 2 && selectedIds.isEmpty) {
            selectedIds.addAll([completedScans[0].id, completedScans[1].id]);
          } else if (completedScans.isNotEmpty && selectedIds.isEmpty) {
            selectedIds.add(completedScans[0].id);
          }
        },
      );
    } catch (e) {
      scansError('Failed to load scans list.');
    } finally {
      isLoadingScans(false);
    }
  }

  /// Toggle selection of scan ID (max 2)
  void toggleScanSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      if (selectedIds.length >= 2) {
        selectedIds.remove(selectedIds.first);
      }
      selectedIds.add(id);
    }
  }

  /// Fetch comparison result
  Future<bool> fetchScanComparison() async {
    if (selectedIds.length != 2) return false;

    isComparing(true);
    compareError('');
    comparisonResult.value = null;

    final idList = selectedIds.toList();
    final thenId = idList[0];
    final nowId = idList[1];

    try {
      final result = await repository.getScanComparison(
        thenId: thenId,
        nowId: nowId,
      );

      return result.fold(
        (failure) {
          compareError(failure.message);
          return false;
        },
        (data) {
          comparisonResult.value = data;
          return true;
        },
      );
    } catch (e) {
      compareError('Failed to generate comparison.');
      return false;
    } finally {
      isComparing(false);
    }
  }
}
