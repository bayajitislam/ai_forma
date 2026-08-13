import 'package:get/get.dart';
import 'package:ai_forma/core/models/weight_record.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

enum TimeRange { week1, month1, month3, month6, year1 }

class WeightController extends GetxController {
  final _uuid = const Uuid();

  // Observable list of weight records
  final RxList<WeightRecord> records = <WeightRecord>[].obs;
  
  // Selected time range for the chart
  final Rx<TimeRange> selectedRange = TimeRange.month1.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    // Generate some mock data based on the design
    final now = DateTime.now();
    records.addAll([
      WeightRecord(id: _uuid.v4(), weightKg: 89.0, date: now.subtract(const Duration(days: 28))),
      WeightRecord(id: _uuid.v4(), weightKg: 88.4, date: now.subtract(const Duration(days: 25))),
      WeightRecord(id: _uuid.v4(), weightKg: 88.2, date: now.subtract(const Duration(days: 21))),
      WeightRecord(id: _uuid.v4(), weightKg: 87.9, date: now.subtract(const Duration(days: 18))),
      WeightRecord(id: _uuid.v4(), weightKg: 88.1, date: now.subtract(const Duration(days: 14))),
      WeightRecord(id: _uuid.v4(), weightKg: 88.3, date: now.subtract(const Duration(days: 10))),
      WeightRecord(id: _uuid.v4(), weightKg: 87.8, date: now.subtract(const Duration(days: 7))),
      WeightRecord(id: _uuid.v4(), weightKg: 87.3, date: now.subtract(const Duration(days: 5))),
      WeightRecord(id: _uuid.v4(), weightKg: 87.0, date: now.subtract(const Duration(days: 3))),
      WeightRecord(id: _uuid.v4(), weightKg: 87.3, date: now.subtract(const Duration(days: 2))),
      WeightRecord(id: _uuid.v4(), weightKg: 87.4, date: now),
    ]);
    // Ensure sorted by date descending for history list
    _sortRecords();
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
    return '$sign${change.toStringAsFixed(1)} kg';
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
    if (records.length < 2) return 'Insufficient data';
    final change = weightChangeSinceLast;
    if (change.abs() < 0.1) return 'Maintaining';
    if (change <= -0.3 && change >= -0.8) return 'On target';
    if (change < -0.8) return 'Faster than target';
    if (change > -0.3 && change < 0) return 'Slower than target';
    return 'On target';
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
    
    // Return sorted ascending for chart
    var filtered = records.where((r) => r.date.isAfter(startDate)).toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  // Actions
  void setTimeRange(TimeRange range) {
    selectedRange.value = range;
  }

  void addRecord(double weight) {
    records.add(WeightRecord(
      id: _uuid.v4(),
      weightKg: weight,
      date: DateTime.now(),
    ));
    _sortRecords();
  }

  void updateRecord(String id, double newWeight) {
    final index = records.indexWhere((r) => r.id == id);
    if (index != -1) {
      final oldRecord = records[index];
      records[index] = oldRecord.copyWith(weightKg: newWeight);
      _sortRecords();
    }
  }
}
