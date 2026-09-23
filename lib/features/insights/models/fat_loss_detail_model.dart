import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class FatLossDetailResponseModel {
  final String accessLevel;
  final String scanId;
  final String scanDate;
  final int checkinNumber;
  final FatLossWindowModel? window;
  final int score;
  final String status;
  final String statusTone;
  final String summary;
  final String? analysis;
  final List<String> analysisHeadings;
  final List<FatLossPriorityItemModel> weeklyPriorities;
  final FatLossMetricsModel? metrics;
  final FatLossChartModel? chart;

  const FatLossDetailResponseModel({
    required this.accessLevel,
    required this.scanId,
    required this.scanDate,
    required this.checkinNumber,
    this.window,
    required this.score,
    required this.status,
    required this.statusTone,
    required this.summary,
    this.analysis,
    this.analysisHeadings = const [],
    required this.weeklyPriorities,
    this.metrics,
    this.chart,
  });

  factory FatLossDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return FatLossDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? FatLossWindowModel.fromJson(
              json['window'] as Map<String, dynamic>,
            )
          : null,
      score: safeParseInt(json['score']) ?? 0,
      status: json['status']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      analysis: json['analysis'] is String
          ? json['analysis'] as String
          : (json['analysis'] is Map<String, dynamic>
              ? [
                  json['analysis']['detected'],
                  json['analysis']['why'],
                  json['analysis']['next_step'],
                ]
                  .where((s) => s != null && s.toString().trim().isNotEmpty)
                  .join('\n\n')
              : null),
      analysisHeadings: (json['analysis_headings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => FatLossPriorityItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      metrics: json['metrics'] is Map<String, dynamic>
          ? FatLossMetricsModel.fromJson(
              json['metrics'] as Map<String, dynamic>,
            )
          : null,
      chart: json['chart'] is Map<String, dynamic>
          ? FatLossChartModel.fromJson(
              json['chart'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class FatLossWindowModel {
  final int weeks;
  final String from;
  final String to;

  const FatLossWindowModel({
    required this.weeks,
    required this.from,
    required this.to,
  });

  factory FatLossWindowModel.fromJson(Map<String, dynamic> json) {
    return FatLossWindowModel(
      weeks: safeParseInt(json['weeks']) ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class FatLossPriorityItemModel {
  final String text;
  final bool completed;

  const FatLossPriorityItemModel({
    required this.text,
    required this.completed,
  });

  factory FatLossPriorityItemModel.fromJson(Map<String, dynamic> json) {
    return FatLossPriorityItemModel(
      text: json['text']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class FatLossValueDeltaModel {
  final double value;
  final double delta;

  const FatLossValueDeltaModel({
    required this.value,
    required this.delta,
  });

  factory FatLossValueDeltaModel.fromJson(Map<String, dynamic> json) {
    return FatLossValueDeltaModel(
      value: safeParseDouble(json['value']) ?? 0.0,
      delta: safeParseDouble(json['delta']) ?? 0.0,
    );
  }
}

class FatLossMetricsModel {
  final FatLossValueDeltaModel? bodyFatPercent;
  final FatLossValueDeltaModel? fatMassKg;

  const FatLossMetricsModel({
    this.bodyFatPercent,
    this.fatMassKg,
  });

  factory FatLossMetricsModel.fromJson(Map<String, dynamic> json) {
    return FatLossMetricsModel(
      bodyFatPercent: json['body_fat_percent'] is Map<String, dynamic>
          ? FatLossValueDeltaModel.fromJson(
              json['body_fat_percent'] as Map<String, dynamic>,
            )
          : null,
      fatMassKg: json['fat_mass_kg'] is Map<String, dynamic>
          ? FatLossValueDeltaModel.fromJson(
              json['fat_mass_kg'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class FatLossChartSeriesItemModel {
  final String date;
  final double bodyFatKg;
  final double bodyFatPercent;

  const FatLossChartSeriesItemModel({
    required this.date,
    required this.bodyFatKg,
    required this.bodyFatPercent,
  });

  factory FatLossChartSeriesItemModel.fromJson(Map<String, dynamic> json) {
    return FatLossChartSeriesItemModel(
      date: json['date']?.toString() ?? '',
      bodyFatKg: safeParseDouble(json['body_fat_kg']) ?? 0.0,
      bodyFatPercent: safeParseDouble(json['body_fat_percent']) ?? 0.0,
    );
  }
}

class FatLossChartModel {
  final List<FatLossChartSeriesItemModel> series;

  const FatLossChartModel({required this.series});

  factory FatLossChartModel.fromJson(Map<String, dynamic> json) {
    return FatLossChartModel(
      series: (json['series'] as List<dynamic>?)
              ?.map((e) => FatLossChartSeriesItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}
