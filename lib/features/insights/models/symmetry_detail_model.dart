import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

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
  final String? analysis;
  final List<String> analysisHeadings;
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
    this.analysisHeadings = const [],
    required this.weeklyPriorities,
    this.visual,
  });

  factory SymmetryDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return SymmetryDetailResponseModel(
      accessLevel: json['access_level']?.toString() ?? '',
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      window: json['window'] is Map<String, dynamic>
          ? SymmetryWindowModel.fromJson(json['window'] as Map<String, dynamic>)
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
      weeks: safeParseInt(json['weeks']) ?? 0,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
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
