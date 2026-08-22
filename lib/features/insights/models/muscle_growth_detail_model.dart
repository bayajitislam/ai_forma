import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class MuscleGrowthDetailResponseModel {
  final String accessLevel;
  final String scanId;
  final String scanDate;
  final int checkinNumber;
  final MuscleGrowthWindowModel? window;
  final int score;
  final String status;
  final String statusTone;
  final String summary;
  final MuscleGrowthAnalysisModel? analysis;
  final List<MuscleGrowthPriorityItemModel> weeklyPriorities;
  final MuscleGrowthMetricsModel? metrics;
  final MuscleGrowthChartModel? chart;

  const MuscleGrowthDetailResponseModel({
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
    required this.weeklyPriorities,
    this.metrics,
    this.chart,
  });

  factory MuscleGrowthDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return MuscleGrowthDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? MuscleGrowthWindowModel.fromJson(
              json['window'] as Map<String, dynamic>,
            )
          : null,
      score: safeParseInt(json['score']) ?? 0,
      status: json['status']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      analysis: json['analysis'] is Map<String, dynamic>
          ? MuscleGrowthAnalysisModel.fromJson(
              json['analysis'] as Map<String, dynamic>,
            )
          : null,
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => MuscleGrowthPriorityItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      metrics: json['metrics'] is Map<String, dynamic>
          ? MuscleGrowthMetricsModel.fromJson(
              json['metrics'] as Map<String, dynamic>,
            )
          : null,
      chart: json['chart'] is Map<String, dynamic>
          ? MuscleGrowthChartModel.fromJson(
              json['chart'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MuscleGrowthWindowModel {
  final int weeks;
  final String from;
  final String to;

  const MuscleGrowthWindowModel({
    required this.weeks,
    required this.from,
    required this.to,
  });

  factory MuscleGrowthWindowModel.fromJson(Map<String, dynamic> json) {
    return MuscleGrowthWindowModel(
      weeks: safeParseInt(json['weeks']) ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class MuscleGrowthAnalysisModel {
  final String detected;
  final String why;
  final String nextStep;

  const MuscleGrowthAnalysisModel({
    required this.detected,
    required this.why,
    required this.nextStep,
  });

  factory MuscleGrowthAnalysisModel.fromJson(Map<String, dynamic> json) {
    return MuscleGrowthAnalysisModel(
      detected: json['detected']?.toString() ?? '',
      why: json['why']?.toString() ?? '',
      nextStep: json['next_step']?.toString() ?? '',
    );
  }
}

class MuscleGrowthPriorityItemModel {
  final String text;
  final bool completed;

  const MuscleGrowthPriorityItemModel({
    required this.text,
    required this.completed,
  });

  factory MuscleGrowthPriorityItemModel.fromJson(Map<String, dynamic> json) {
    return MuscleGrowthPriorityItemModel(
      text: json['text']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class ValueDeltaItemModel {
  final double value;
  final double delta;

  const ValueDeltaItemModel({
    required this.value,
    required this.delta,
  });

  factory ValueDeltaItemModel.fromJson(Map<String, dynamic> json) {
    return ValueDeltaItemModel(
      value: safeParseDouble(json['value']) ?? 0.0,
      delta: safeParseDouble(json['delta']) ?? 0.0,
    );
  }
}

class MuscleGrowthMetricsModel {
  final ValueDeltaItemModel? muscleMassKg;
  final ValueDeltaItemModel? muscleMassPercent;

  const MuscleGrowthMetricsModel({
    this.muscleMassKg,
    this.muscleMassPercent,
  });

  factory MuscleGrowthMetricsModel.fromJson(Map<String, dynamic> json) {
    return MuscleGrowthMetricsModel(
      muscleMassKg: json['muscle_mass_kg'] is Map<String, dynamic>
          ? ValueDeltaItemModel.fromJson(
              json['muscle_mass_kg'] as Map<String, dynamic>,
            )
          : null,
      muscleMassPercent: json['muscle_mass_percent'] is Map<String, dynamic>
          ? ValueDeltaItemModel.fromJson(
              json['muscle_mass_percent'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MuscleGrowthChartSeriesItemModel {
  final String date;
  final double muscleMassKg;
  final double muscleMassPercent;

  const MuscleGrowthChartSeriesItemModel({
    required this.date,
    required this.muscleMassKg,
    required this.muscleMassPercent,
  });

  factory MuscleGrowthChartSeriesItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MuscleGrowthChartSeriesItemModel(
      date: json['date']?.toString() ?? '',
      muscleMassKg: safeParseDouble(json['muscle_mass_kg']) ?? 0.0,
      muscleMassPercent: safeParseDouble(json['muscle_mass_percent']) ?? 0.0,
    );
  }
}

class MuscleGrowthChartModel {
  final List<MuscleGrowthChartSeriesItemModel> series;

  const MuscleGrowthChartModel({required this.series});

  factory MuscleGrowthChartModel.fromJson(Map<String, dynamic> json) {
    return MuscleGrowthChartModel(
      series: (json['series'] as List<dynamic>?)
              ?.map((e) => MuscleGrowthChartSeriesItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}
