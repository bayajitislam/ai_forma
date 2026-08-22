class ConsistencyDetailResponseModel {
  final String accessLevel;
  final String scanId;
  final String scanDate;
  final int checkinNumber;
  final ConsistencyWindowModel? window;
  final int score;
  final String status;
  final String statusTone;
  final String summary;
  final ConsistencyAnalysisModel? analysis;
  final List<ConsistencyPriorityItemModel> weeklyPriorities;
  final List<ConsistencyGridItemModel> grid;
  final ConsistencyMetricsModel? metrics;

  const ConsistencyDetailResponseModel({
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
    required this.grid,
    this.metrics,
  });

  factory ConsistencyDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: (json['checkin_number'] as num?)?.toInt() ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? ConsistencyWindowModel.fromJson(
              json['window'] as Map<String, dynamic>,
            )
          : null,
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      analysis: json['analysis'] is Map<String, dynamic>
          ? ConsistencyAnalysisModel.fromJson(
              json['analysis'] as Map<String, dynamic>,
            )
          : null,
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => ConsistencyPriorityItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      grid: (json['grid'] as List<dynamic>?)
              ?.map((e) => ConsistencyGridItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      metrics: json['metrics'] is Map<String, dynamic>
          ? ConsistencyMetricsModel.fromJson(
              json['metrics'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ConsistencyWindowModel {
  final int weeks;
  final String from;
  final String to;

  const ConsistencyWindowModel({
    required this.weeks,
    required this.from,
    required this.to,
  });

  factory ConsistencyWindowModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyWindowModel(
      weeks: (json['weeks'] as num?)?.toInt() ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class ConsistencyAnalysisModel {
  final String detected;
  final String why;
  final String nextStep;

  const ConsistencyAnalysisModel({
    required this.detected,
    required this.why,
    required this.nextStep,
  });

  factory ConsistencyAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyAnalysisModel(
      detected: json['detected']?.toString() ?? '',
      why: json['why']?.toString() ?? '',
      nextStep: json['next_step']?.toString() ?? '',
    );
  }
}

class ConsistencyPriorityItemModel {
  final String text;
  final bool completed;

  const ConsistencyPriorityItemModel({
    required this.text,
    required this.completed,
  });

  factory ConsistencyPriorityItemModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyPriorityItemModel(
      text: json['text']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class ConsistencyGridItemModel {
  final String date;
  final int checkinNumber;

  const ConsistencyGridItemModel({
    required this.date,
    required this.checkinNumber,
  });

  factory ConsistencyGridItemModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyGridItemModel(
      date: json['date']?.toString() ?? '',
      checkinNumber: (json['checkin_number'] as num?)?.toInt() ?? 0,
    );
  }
}

class ConsistencyMetricsModel {
  final int currentStreakWeeks;
  final int onTimePercent;
  final dynamic momentumGained;

  const ConsistencyMetricsModel({
    required this.currentStreakWeeks,
    required this.onTimePercent,
    this.momentumGained,
  });

  factory ConsistencyMetricsModel.fromJson(Map<String, dynamic> json) {
    return ConsistencyMetricsModel(
      currentStreakWeeks:
          (json['current_streak_weeks'] as num?)?.toInt() ?? 0,
      onTimePercent: (json['on_time_percent'] as num?)?.toInt() ?? 0,
      momentumGained: json['momentum_gained'],
    );
  }
}
