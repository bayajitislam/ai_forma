import 'package:ai_forma/features/timeline/models/timeline_history_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_scan_detail_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_trends_model.dart';
import 'package:ai_forma/features/timeline/repositories/timeline_repository.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final TimelineRepository repository;
  TimelineController({required this.repository});

  // Overview State
  final Rx<TimelineOverviewResponseModel?> overviewData =
      Rx<TimelineOverviewResponseModel?>(null);
  final RxBool isOverviewLoading = false.obs;
  final RxString overviewError = ''.obs;

  // Trends State
  final Rx<TimelineTrendsResponseModel?> trendsData =
      Rx<TimelineTrendsResponseModel?>(null);
  final RxBool isTrendsLoading = false.obs;
  final RxString trendsError = ''.obs;
  final RxString selectedRange = '4w'.obs;

  // History State
  final RxList<TimelineHistoryScanItemModel> historyList =
      <TimelineHistoryScanItemModel>[].obs;
  final RxBool isHistoryLoading = false.obs;
  final RxString historyError = ''.obs;
  int _currentPage = 1;
  bool _hasMoreHistory = true;

  // Scan Detail State
  final Rx<TimelineScanDetailResponseModel?> scanDetailData =
      Rx<TimelineScanDetailResponseModel?>(null);
  final RxBool isScanDetailLoading = false.obs;
  final RxString scanDetailError = ''.obs;

  /// Explicitly triggered when user navigates to Timeline tab (same behavior as Insights)
  void fetchTimelineData({bool force = false}) {
    if (overviewData.value == null || force) {
      fetchOverview();
    }
    if (trendsData.value == null || force) {
      fetchTrends(selectedRange.value);
    }
    if (historyList.isEmpty || force) {
      fetchHistory(isRefresh: true);
    }
  }

  /// Fetch Overview tab data (`GET /api/timeline/overview/?weeks=8`)
  Future<void> fetchOverview({int weeks = 8}) async {
    isOverviewLoading(true);
    overviewError('');
    try {
      final result = await repository.getOverview(weeks: weeks);
      result.fold(
        (failure) => overviewError(failure.message),
        (data) => overviewData.value = data,
      );
    } catch (e) {
      overviewError('Failed to load overview data.');
    } finally {
      isOverviewLoading(false);
    }
  }

  /// Fetch Trends tab data (`GET /api/timeline/trends/?range=4w`)
  Future<void> fetchTrends(String range) async {
    selectedRange.value = range;
    isTrendsLoading(true);
    trendsError('');
    try {
      final result = await repository.getTrends(range: range);
      result.fold(
        (failure) => trendsError(failure.message),
        (data) => trendsData.value = data,
      );
    } catch (e) {
      trendsError('Failed to load trends data.');
    } finally {
      isTrendsLoading(false);
    }
  }

  /// Fetch Scan History tab data (`GET /api/timeline/history/?page=1`)
  Future<void> fetchHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreHistory = true;
      historyList.clear();
    }

    if (!_hasMoreHistory && !isRefresh) return;

    isHistoryLoading(true);
    historyError('');
    try {
      final result = await repository.getHistory(page: _currentPage);
      result.fold(
        (failure) => historyError(failure.message),
        (data) {
          if (isRefresh) {
            historyList.assignAll(data.results);
          } else {
            historyList.addAll(data.results);
          }
          if (data.next == null || data.results.isEmpty) {
            _hasMoreHistory = false;
          } else {
            _currentPage++;
          }
        },
      );
    } catch (e) {
      historyError('Failed to load scan history.');
    } finally {
      isHistoryLoading(false);
    }
  }

  /// Fetch Scan Detail (`GET /api/timeline/scans/{id}/`)
  Future<void> fetchScanDetail(String id) async {
    isScanDetailLoading(true);
    scanDetailError('');
    scanDetailData.value = null;
    try {
      final result = await repository.getScanDetail(id);
      result.fold(
        (failure) => scanDetailError(failure.message),
        (data) => scanDetailData.value = data,
      );
    } catch (e) {
      scanDetailError('Failed to load scan details.');
    } finally {
      isScanDetailLoading(false);
    }
  }
}
