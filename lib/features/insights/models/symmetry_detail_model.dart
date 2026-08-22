class SymmetryDetailResponseModel {
  final String accessLevel;
  final String scanId;
  final String scanDate;
  final int checkinNumber;
  final SymmetryWindowModel? window;
  final int score;
  final String status;
  final String statusTone;
  final String summary;
  final SymmetryAnalysisModel? analysis;
  final List<SymmetryPriorityItemModel> weeklyPriorities;
  final SymmetryVisualModel? visual;

  const SymmetryDetailResponseModel({
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
    this.visual,
  });

  factory SymmetryDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return SymmetryDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: (json['checkin_number'] as num?)?.toInt() ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? SymmetryWindowModel.fromJson(json['window'] as Map<String, dynamic>)
          : null,
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      analysis: json['analysis'] is Map<String, dynamic>
          ? SymmetryAnalysisModel.fromJson(
              json['analysis'] as Map<String, dynamic>,
            )
          : null,
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => SymmetryPriorityItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      visual: json['visual'] is Map<String, dynamic>
          ? SymmetryVisualModel.fromJson(
              json['visual'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SymmetryWindowModel {
  final int weeks;
  final String from;
  final String to;

  const SymmetryWindowModel({
    required this.weeks,
    required this.from,
    required this.to,
  });

  factory SymmetryWindowModel.fromJson(Map<String, dynamic> json) {
    return SymmetryWindowModel(
      weeks: (json['weeks'] as num?)?.toInt() ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class SymmetryAnalysisModel {
  final String detected;
  final String why;
  final String nextStep;

  const SymmetryAnalysisModel({
    required this.detected,
    required this.why,
    required this.nextStep,
  });

  factory SymmetryAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SymmetryAnalysisModel(
      detected: json['detected']?.toString() ?? '',
      why: json['why']?.toString() ?? '',
      nextStep: json['next_step']?.toString() ?? '',
    );
  }
}

class SymmetryPriorityItemModel {
  final String text;
  final bool completed;

  const SymmetryPriorityItemModel({
    required this.text,
    required this.completed,
  });

  factory SymmetryPriorityItemModel.fromJson(Map<String, dynamic> json) {
    return SymmetryPriorityItemModel(
      text: json['text']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class SymmetryVisualModel {
  final String scanId;
  final String scanDate;
  final String? imageUrl;
  final String? thumbUrl;

  const SymmetryVisualModel({
    required this.scanId,
    required this.scanDate,
    this.imageUrl,
    this.thumbUrl,
  });

  factory SymmetryVisualModel.fromJson(Map<String, dynamic> json) {
    return SymmetryVisualModel(
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      thumbUrl: json['thumb_url']?.toString(),
    );
  }
}
