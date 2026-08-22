import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class TimelineTrendsResponseModel {
  final List<TimelineRangeItemModel> ranges;
  final double? currentPercent;
  final double? changePercent;
  final String? changeLabel;
  final double? weeklyRatePercent;
  final TimelineTrendInfoModel? trend;
  final TimelineChartModel? chart;

  const TimelineTrendsResponseModel({
    required this.ranges,
    this.currentPercent,
    this.changePercent,
    this.changeLabel,
    this.weeklyRatePercent,
    this.trend,
    this.chart,
  });

  factory TimelineTrendsResponseModel.fromJson(Map<String, dynamic> json) {
    return TimelineTrendsResponseModel(
      ranges: (json['ranges'] as List<dynamic>?)
              ?.map((e) => TimelineRangeItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      currentPercent: safeParseDouble(json['current_percent']),
      changePercent: safeParseDouble(json['change_percent']),
      changeLabel: json['change_label']?.toString(),
      weeklyRatePercent: safeParseDouble(json['weekly_rate_percent']),
      trend: json['trend'] is Map<String, dynamic>
          ? TimelineTrendInfoModel.fromJson(
              json['trend'] as Map<String, dynamic>,
            )
          : null,
      chart: json['chart'] is Map<String, dynamic>
          ? TimelineChartModel.fromJson(
              json['chart'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TimelineRangeItemModel {
  final String key;
  final String label;

  const TimelineRangeItemModel({
    required this.key,
    required this.label,
  });

  factory TimelineRangeItemModel.fromJson(Map<String, dynamic> json) {
    return TimelineRangeItemModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class TimelineTrendInfoModel {
  final String key;
  final String label;

  const TimelineTrendInfoModel({
    required this.key,
    required this.label,
  });

  factory TimelineTrendInfoModel.fromJson(Map<String, dynamic> json) {
    return TimelineTrendInfoModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}
