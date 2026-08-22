int? safeParseInt(dynamic val) {
  if (val == null) return null;
  if (val is num) return val.toInt();
  if (val is String) return int.tryParse(val) ?? double.tryParse(val)?.toInt();
  return null;
}

double? safeParseDouble(dynamic val) {
  if (val == null) return null;
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val);
  return null;
}

class TimelineOverviewResponseModel {
  final List<TimelineRecentScanModel> recentScans;
  final TimelineNextScanModel? nextScan;
  final TimelineProgressModel? progress;
  final TimelineChartModel? chart;

  const TimelineOverviewResponseModel({
    required this.recentScans,
    this.nextScan,
    this.progress,
    this.chart,
  });

  factory TimelineOverviewResponseModel.fromJson(Map<String, dynamic> json) {
    return TimelineOverviewResponseModel(
      recentScans: (json['recent_scans'] as List<dynamic>?)
              ?.map((e) => TimelineRecentScanModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      nextScan: json['next_scan'] is Map<String, dynamic>
          ? TimelineNextScanModel.fromJson(
              json['next_scan'] as Map<String, dynamic>,
            )
          : null,
      progress: json['progress'] is Map<String, dynamic>
          ? TimelineProgressModel.fromJson(
              json['progress'] as Map<String, dynamic>,
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

class TimelineThumbsModel {
  final String? front;
  final String? side;
  final String? back;

  const TimelineThumbsModel({
    this.front,
    this.side,
    this.back,
  });

  factory TimelineThumbsModel.fromJson(Map<String, dynamic> json) {
    return TimelineThumbsModel(
      front: json['front']?.toString(),
      side: json['side']?.toString(),
      back: json['back']?.toString(),
    );
  }
}

class TimelineRecentScanModel {
  final String id;
  final String scanDate;
  final int checkinNumber;
  final TimelineThumbsModel? thumbs;

  const TimelineRecentScanModel({
    required this.id,
    required this.scanDate,
    required this.checkinNumber,
    this.thumbs,
  });

  factory TimelineRecentScanModel.fromJson(Map<String, dynamic> json) {
    return TimelineRecentScanModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      thumbs: json['thumbs'] is Map<String, dynamic>
          ? TimelineThumbsModel.fromJson(
              json['thumbs'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TimelineNextScanModel {
  final String date;
  final String windowStatus;

  const TimelineNextScanModel({
    required this.date,
    required this.windowStatus,
  });

  factory TimelineNextScanModel.fromJson(Map<String, dynamic> json) {
    return TimelineNextScanModel(
      date: json['date']?.toString() ?? '',
      windowStatus: json['window_status']?.toString() ?? '',
    );
  }
}

class TimelineProgressModel {
  final String? muscleChangeKg;
  final String? bodyFatChangePercent;
  final int? momentumChange;
  final bool analysisLocked;

  const TimelineProgressModel({
    this.muscleChangeKg,
    this.bodyFatChangePercent,
    this.momentumChange,
    this.analysisLocked = false,
  });

  factory TimelineProgressModel.fromJson(Map<String, dynamic> json) {
    return TimelineProgressModel(
      muscleChangeKg: json['muscle_change_kg']?.toString(),
      bodyFatChangePercent: json['body_fat_change_percent']?.toString(),
      momentumChange: safeParseInt(json['momentum_change']),
      analysisLocked: json['analysis_locked'] as bool? ?? false,
    );
  }
}

class TimelineChartSeriesItemModel {
  final String date;
  final double value;

  const TimelineChartSeriesItemModel({
    required this.date,
    required this.value,
  });

  factory TimelineChartSeriesItemModel.fromJson(Map<String, dynamic> json) {
    return TimelineChartSeriesItemModel(
      date: json['date']?.toString() ?? '',
      value: safeParseDouble(json['value']) ?? 0.0,
    );
  }
}

class TimelineChartModel {
  final String metric;
  final List<TimelineChartSeriesItemModel> series;

  const TimelineChartModel({
    required this.metric,
    required this.series,
  });

  factory TimelineChartModel.fromJson(Map<String, dynamic> json) {
    return TimelineChartModel(
      metric: json['metric']?.toString() ?? 'momentum',
      series: (json['series'] as List<dynamic>?)
              ?.map((e) => TimelineChartSeriesItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}
