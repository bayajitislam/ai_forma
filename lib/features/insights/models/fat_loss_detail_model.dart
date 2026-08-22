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
  final FatLossAnalysisModel? analysis;
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
    required this.weeklyPriorities,
    this.metrics,
    this.chart,
  });

  factory FatLossDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return FatLossDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: (json['checkin_number'] as num?)?.toInt() ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? FatLossWindowModel.fromJson(
              json['window'] as Map<String, dynamic>,
            )
          : null,
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      analysis: json['analysis'] is Map<String, dynamic>
          ? FatLossAnalysisModel.fromJson(
              json['analysis'] as Map<String, dynamic>,
            )
          : null,
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
      weeks: (json['weeks'] as num?)?.toInt() ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class FatLossAnalysisModel {
  final String detected;
  final String why;
  final String nextStep;

  const FatLossAnalysisModel({
    required this.detected,
    required this.why,
    required this.nextStep,
  });

  factory FatLossAnalysisModel.fromJson(Map<String, dynamic> json) {
    return FatLossAnalysisModel(
      detected: json['detected']?.toString() ?? '',
      why: json['why']?.toString() ?? '',
      nextStep: json['next_step']?.toString() ?? '',
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
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      delta: (json['delta'] as num?)?.toDouble() ?? 0.0,
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
      bodyFatKg: (json['body_fat_kg'] as num?)?.toDouble() ?? 0.0,
      bodyFatPercent: (json['body_fat_percent'] as num?)?.toDouble() ?? 0.0,
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
