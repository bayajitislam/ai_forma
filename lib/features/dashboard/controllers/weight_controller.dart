import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/models/weight_record.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:uuid/uuid.dart';

enum TimeRange { week1, month1, month3, month6, year1 }

class WeightController extends GetxController {
  final DioClient _dio;
  WeightController(this._dio);

  final _uuid = const Uuid();

  // Observable list of weight records
  final RxList<WeightRecord> records = <WeightRecord>[].obs;

  // Selected time range for the chart
  final Rx<TimeRange> selectedRange = TimeRange.month1.obs;

  // Touched chart spot index (-1 defaults to latest)
  final RxInt touchedChartIndex = (-1).obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingTrends = false.obs;
  final RxBool isLoadingProgress = false.obs;
  final RxString errorMessage = ''.obs;

  void setTouchedChartIndex(int index) {
    touchedChartIndex.value = index;
  }

  // Weekly progress summary observables
  final RxString progressLabel = DashboardStrings.monthlyChangeCaps.obs;
  final RxString progressChangeKg = '0.0'.obs;
  final RxString progressStatusLabel = DashboardStrings.onTarget.obs;
  final RxString progressStatusTone = 'positive'.obs;
  final RxString progressPreviousWeight = '--'.obs;
  final RxString progressPreviousDate = ''.obs;
  final RxString progressCurrentWeight = '--'.obs;
  final RxString progressCurrentDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeightTrends();
  }

  String _timeRangeToQuery(TimeRange range) {
    switch (range) {
      case TimeRange.week1:
        return '1w';
      case TimeRange.month1:
        return '1m';
      case TimeRange.month3:
        return '3m';
      case TimeRange.month6:
        return '6m';
      case TimeRange.year1:
        return '1y';
    }
  }

  /// Fetch Weight Trends from GET /api/checkins/weight-trends/
  Future<void> fetchWeightTrends({TimeRange? range}) async {
    final activeRange = range ?? selectedRange.value;
    selectedRange.value = activeRange;

    isLoadingTrends(true);
    isLoading(true);
    errorMessage('');

    try {
      final response = await _dio.get(
        ApiEndpoint.weightTrends,
        queryParameters: {'range': _timeRangeToQuery(activeRange)},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        _parsePayload(data);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoadingTrends(false);
      isLoading(isLoadingProgress.value);
    }
  }

  /// Fetch Weekly Progress from GET /api/checkins/weight-progress/
  Future<void> fetchWeightProgress({TimeRange? range}) async {
    final activeRange = range ?? selectedRange.value;
    selectedRange.value = activeRange;

    isLoadingProgress(true);
    isLoading(true);
    errorMessage('');

    try {
      final response = await _dio.get(
        ApiEndpoint.weightProgress,
        queryParameters: {'range': _timeRangeToQuery(activeRange)},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        _parsePayload(data);
        _parseSummary(data['summary']);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoadingProgress(false);
      isLoading(isLoadingTrends.value);
    }
  }

  void _parsePayload(Map<String, dynamic> data) {
    final parsedRecords = <WeightRecord>[];

    // Check history list
    if (data['history'] is List) {
      for (final item in data['history'] as List) {
        if (item is Map<String, dynamic>) {
          final dateStr = item['date']?.toString() ?? '';
          final timeStr = item['recorded_at']?.toString();
          final weightVal = double.tryParse(item['weight_kg']?.toString() ?? '') ?? 0.0;
          final idStr = item['id']?.toString() ?? _uuid.v4();

          DateTime dt;
          if (timeStr != null && timeStr.isNotEmpty) {
            dt = DateTime.tryParse(timeStr)?.toLocal() ?? DateTime.now();
          } else if (dateStr.isNotEmpty) {
            dt = DateTime.tryParse(dateStr) ?? DateTime.now();
          } else {
            dt = DateTime.now();
          }

          parsedRecords.add(
            WeightRecord(
              id: idStr,
              weightKg: weightVal,
              date: dt,
            ),
          );
        }
      }
    }

    // Check chart series if history is empty
    if (parsedRecords.isEmpty && data['chart'] is Map<String, dynamic>) {
      final chartMap = data['chart'] as Map<String, dynamic>;
      if (chartMap['series'] is List) {
        for (final item in chartMap['series'] as List) {
          if (item is Map<String, dynamic>) {
            final dateStr = item['date']?.toString() ?? '';
            final weightVal = double.tryParse(item['weight_kg']?.toString() ?? '') ?? 0.0;
            final dt = DateTime.tryParse(dateStr) ?? DateTime.now();
            parsedRecords.add(
              WeightRecord(
                id: _uuid.v4(),
                weightKg: weightVal,
                date: dt,
              ),
            );
          }
        }
      }
    }

    records.assignAll(parsedRecords);
    _sortRecords();
  }

  void _parseSummary(dynamic summaryData) {
    if (summaryData is! Map<String, dynamic>) return;

    progressLabel.value = summaryData['label']?.toString().toUpperCase() ??
        DashboardStrings.monthlyChangeCaps;
    progressChangeKg.value = summaryData['change_kg']?.toString() ?? '0.0';
    progressStatusLabel.value =
        summaryData['status_label']?.toString() ?? DashboardStrings.onTarget;
    progressStatusTone.value =
        summaryData['status_tone']?.toString() ?? 'positive';

    final prev = summaryData['previous'];
    if (prev is Map<String, dynamic>) {
      progressPreviousWeight.value = prev['weight_kg']?.toString() ?? '--';
      final dtStr = prev['date']?.toString() ?? '';
      progressPreviousDate.value = AppDateFormatter.toDayMonthYear(dtStr);
    } else if (prev != null) {
      progressPreviousWeight.value = prev.toString();
      progressPreviousDate.value = '';
    }

    final curr = summaryData['current'];
    if (curr is Map<String, dynamic>) {
      progressCurrentWeight.value = curr['weight_kg']?.toString() ?? '--';
      final dtStr = curr['date']?.toString() ?? '';
      progressCurrentDate.value = AppDateFormatter.toDayMonthYear(dtStr);
    } else if (curr != null) {
      progressCurrentWeight.value = curr.toString();
      progressCurrentDate.value = '';
    }
  }

  void _sortRecords() {
    records.sort((a, b) => b.date.compareTo(a.date));
  }

  // Getters for Dashboard
  WeightRecord? get currentWeight => records.isNotEmpty ? records.first : null;

  double get weightChangeSinceLast {
    if (records.length < 2) return 0.0;
    return records[0].weightKg - records[1].weightKg;
  }

  String get weightChangeSinceLastString {
    final change = weightChangeSinceLast;
    final sign = change > 0 ? '+' : (change < 0 ? '' : '');
    return '$sign${change.toStringAsFixed(1)} ${DashboardStrings.kgUnit}';
  }

  WeightRecord? get previousWeight {
    if (records.length < 2) return null;
    return records[1];
  }

  String get comparisonPeriodString {
    final data = chartData;
    if (data.length >= 2) {
      final start = data.first.date;
      final end = data.last.date;
      final startStr = DateFormat('d MMM').format(start);
      final endStr = DateFormat('d MMM').format(end);
      return '$startStr – $endStr';
    } else if (records.isNotEmpty) {
      final end = records.first.date;
      final start = end.subtract(const Duration(days: 7));
      return '${DateFormat('d MMM').format(start)} – ${DateFormat('d MMM').format(end)}';
    }
    final now = DateTime.now();
    return '${DateFormat('d MMM').format(now.subtract(const Duration(days: 7)))} – ${DateFormat('d MMM').format(now)}';
  }

  String get weeklyProgressStatus {
    if (progressStatusLabel.value.isNotEmpty) {
      return progressStatusLabel.value;
    }
    if (records.length < 2) return DashboardStrings.insufficientData;
    final change = weightChangeSinceLast;
    if (change.abs() < 0.1) return DashboardStrings.maintaining;
    if (change <= -0.3 && change >= -0.8) return DashboardStrings.onTarget;
    if (change < -0.8) return DashboardStrings.fasterThanTarget;
    if (change > -0.3 && change < 0) return DashboardStrings.slowerThanTarget;
    return DashboardStrings.onTarget;
  }

  double getWeightChangeFromPrevious(int chartIndex) {
    final data = chartData;
    if (chartIndex <= 0 || chartIndex >= data.length) return 0.0;
    return data[chartIndex].weightKg - data[chartIndex - 1].weightKg;
  }

  // Filtered records for chart
  List<WeightRecord> get chartData {
    final now = DateTime.now();
    DateTime startDate;
    switch (selectedRange.value) {
      case TimeRange.week1:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.month1:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case TimeRange.month3:
        startDate = now.subtract(const Duration(days: 90));
        break;
      case TimeRange.month6:
        startDate = now.subtract(const Duration(days: 180));
        break;
      case TimeRange.year1:
        startDate = now.subtract(const Duration(days: 365));
        break;
    }

    var filtered = records.where((r) => r.date.isAfter(startDate)).toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  // Actions
  void setTimeRange(TimeRange range, {bool isProgressMode = false}) {
    selectedRange.value = range;
    touchedChartIndex.value = -1;
    if (isProgressMode) {
      fetchWeightProgress(range: range);
    } else {
      fetchWeightTrends(range: range);
    }
  }

  Future<void> addRecord(double weight) async {
    final roundedWeight = double.parse(weight.toStringAsFixed(1));
    isLoading(true);

    try {
      final response = await _dio.post(
        ApiEndpoint.weightTrends,
        data: {
          'weight_kg': roundedWeight,
          'source': 'manual',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          _parsePayload(response.data as Map<String, dynamic>);
        }
      }

      // Re-sync with backend to get updated charts and calculations concurrently
      await Future.wait([
        fetchWeightProgress(range: selectedRange.value),
        fetchWeightTrends(range: selectedRange.value),
      ]);

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData(force: true);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateRecord(String id, double newWeight) async {
    final roundedWeight = double.parse(newWeight.toStringAsFixed(1));
    isLoading(true);

    try {
      final response = await _dio.patch(
        '${ApiEndpoint.weightHistory}$id/',
        data: {
          'weight_kg': roundedWeight,
          'source': 'manual',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          _parsePayload(response.data as Map<String, dynamic>);
        }
      }

      // Re-sync with backend to get updated charts and calculations concurrently
      await Future.wait([
        fetchWeightProgress(range: selectedRange.value),
        fetchWeightTrends(range: selectedRange.value),
      ]);

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData(force: true);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteRecord(String id) async {
    // Keep a backup for rollback in case the server call fails
    final backup = records.firstWhereOrNull((r) => r.id == id);

    records.removeWhere((r) => r.id == id);
    _sortRecords();

    try {
      try {
        await _dio.delete('${ApiEndpoint.weightTrends}$id/');
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          // Try alternate endpoint
          await _dio.delete('/api/checkins/weight-history/$id/');
        } else {
          rethrow;
        }
      }

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData(force: true);
      }
    } catch (_) {
      // Rollback: restore the record so the user doesn't lose data silently
      if (backup != null) {
        records.add(backup);
        _sortRecords();
      }
      errorMessage('Failed to delete record. Please try again.');
    }
  }
}
