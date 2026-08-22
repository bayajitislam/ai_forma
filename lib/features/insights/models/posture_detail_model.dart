class PostureDetailResponseModel {
  final String accessLevel;
  final String scanId;
  final String scanDate;
  final int checkinNumber;
  final PostureWindowModel? window;
  final int score;
  final String status;
  final String statusTone;
  final String summary;
  final PostureAnalysisDataModel? analysis;
  final List<PosturePriorityItemModel> weeklyPriorities;
  final PostureAlignmentModel? alignment;
  final PostureComparisonModel? comparison;

  const PostureDetailResponseModel({
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
    this.alignment,
    this.comparison,
  });

  factory PostureDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return PostureDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: (json['checkin_number'] as num?)?.toInt() ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? PostureWindowModel.fromJson(json['window'] as Map<String, dynamic>)
          : null,
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      analysis: json['analysis'] is Map<String, dynamic>
          ? PostureAnalysisDataModel.fromJson(
              json['analysis'] as Map<String, dynamic>,
            )
          : null,
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => PosturePriorityItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      alignment: json['alignment'] is Map<String, dynamic>
          ? PostureAlignmentModel.fromJson(
              json['alignment'] as Map<String, dynamic>,
            )
          : null,
      comparison: json['comparison'] is Map<String, dynamic>
          ? PostureComparisonModel.fromJson(
              json['comparison'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class PostureWindowModel {
  final int weeks;
  final String from;
  final String to;

  const PostureWindowModel({
    required this.weeks,
    required this.from,
    required this.to,
  });

  factory PostureWindowModel.fromJson(Map<String, dynamic> json) {
    return PostureWindowModel(
      weeks: (json['weeks'] as num?)?.toInt() ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class PostureAnalysisDataModel {
  final String detected;
  final String why;
  final String nextStep;

  const PostureAnalysisDataModel({
    required this.detected,
    required this.why,
    required this.nextStep,
  });

  factory PostureAnalysisDataModel.fromJson(Map<String, dynamic> json) {
    return PostureAnalysisDataModel(
      detected: json['detected']?.toString() ?? '',
      why: json['why']?.toString() ?? '',
      nextStep: json['next_step']?.toString() ?? '',
    );
  }
}

class PosturePriorityItemModel {
  final String text;
  final bool completed;

  const PosturePriorityItemModel({
    required this.text,
    required this.completed,
  });

  factory PosturePriorityItemModel.fromJson(Map<String, dynamic> json) {
    return PosturePriorityItemModel(
      text: json['text']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class PostureAlignmentItemModel {
  final String label;
  final String tone;

  const PostureAlignmentItemModel({
    required this.label,
    required this.tone,
  });

  factory PostureAlignmentItemModel.fromJson(Map<String, dynamic> json) {
    return PostureAlignmentItemModel(
      label: json['label']?.toString() ?? '',
      tone: json['tone']?.toString() ?? '',
    );
  }
}

class PostureAlignmentModel {
  final PostureAlignmentItemModel? headPosition;
  final PostureAlignmentItemModel? shoulderPosition;
  final PostureAlignmentItemModel? spinalPosition;
  final PostureAlignmentItemModel? pelvicTilt;

  const PostureAlignmentModel({
    this.headPosition,
    this.shoulderPosition,
    this.spinalPosition,
    this.pelvicTilt,
  });

  factory PostureAlignmentModel.fromJson(Map<String, dynamic> json) {
    return PostureAlignmentModel(
      headPosition: json['head_position'] is Map<String, dynamic>
          ? PostureAlignmentItemModel.fromJson(
              json['head_position'] as Map<String, dynamic>,
            )
          : null,
      shoulderPosition: json['shoulder_position'] is Map<String, dynamic>
          ? PostureAlignmentItemModel.fromJson(
              json['shoulder_position'] as Map<String, dynamic>,
            )
          : null,
      spinalPosition: json['spinal_position'] is Map<String, dynamic>
          ? PostureAlignmentItemModel.fromJson(
              json['spinal_position'] as Map<String, dynamic>,
            )
          : null,
      pelvicTilt: json['pelvic_tilt'] is Map<String, dynamic>
          ? PostureAlignmentItemModel.fromJson(
              json['pelvic_tilt'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class PostureComparisonItemModel {
  final String scanId;
  final String scanDate;
  final String? imageUrl;
  final String? thumbUrl;
  final String label;

  const PostureComparisonItemModel({
    required this.scanId,
    required this.scanDate,
    this.imageUrl,
    this.thumbUrl,
    required this.label,
  });

  factory PostureComparisonItemModel.fromJson(Map<String, dynamic> json) {
    return PostureComparisonItemModel(
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      thumbUrl: json['thumb_url']?.toString(),
      label: json['label']?.toString() ?? '',
    );
  }
}

class PostureComparisonModel {
  final PostureComparisonItemModel? before;
  final PostureComparisonItemModel? after;

  const PostureComparisonModel({
    this.before,
    this.after,
  });

  factory PostureComparisonModel.fromJson(Map<String, dynamic> json) {
    return PostureComparisonModel(
      before: json['before'] is Map<String, dynamic>
          ? PostureComparisonItemModel.fromJson(
              json['before'] as Map<String, dynamic>,
            )
          : null,
      after: json['after'] is Map<String, dynamic>
          ? PostureComparisonItemModel.fromJson(
              json['after'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
