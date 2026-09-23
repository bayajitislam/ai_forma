import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class InsightTitleSubtitleItem {
  final String title;
  final String subtitle;

  const InsightTitleSubtitleItem({
    required this.title,
    required this.subtitle,
  });

  factory InsightTitleSubtitleItem.fromJson(Map<String, dynamic> json) {
    return InsightTitleSubtitleItem(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
    };
  }
}

class FatLossModel {
  final int score;
  final String remark;
  final String status;
  final String analysis;
  final double? bodyFatKg;
  final List<String> weeklyPriorities;

  const FatLossModel({
    required this.score,
    required this.remark,
    required this.status,
    required this.analysis,
    this.bodyFatKg,
    required this.weeklyPriorities,
  });

  factory FatLossModel.fromJson(Map<String, dynamic> json) {
    final rawAnalysis = json['analysis']?.toString();
    final legacyJoined = [
      json['detected_summary'],
      json['rationale'],
      json['next_step'],
    ].where((s) => s != null && s.toString().trim().isNotEmpty).join('\n\n');
    return FatLossModel(
      score: safeParseInt(json['score']) ?? 0,
      remark: json['remark']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      analysis: (rawAnalysis != null && rawAnalysis.isNotEmpty)
          ? rawAnalysis
          : legacyJoined,
      bodyFatKg: safeParseDouble(json['body_fat_kg']),
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class MuscleGrowthModel {
  final int score;
  final String remark;
  final String status;
  final String analysis;
  final double? muscleMassKg;
  final List<String> weeklyPriorities;

  const MuscleGrowthModel({
    required this.score,
    required this.remark,
    required this.status,
    required this.analysis,
    this.muscleMassKg,
    required this.weeklyPriorities,
  });

  factory MuscleGrowthModel.fromJson(Map<String, dynamic> json) {
    final rawAnalysis = json['analysis']?.toString();
    final legacyJoined = [
      json['detected_summary'],
      json['rationale'],
      json['next_step'],
    ].where((s) => s != null && s.toString().trim().isNotEmpty).join('\n\n');
    return MuscleGrowthModel(
      score: safeParseInt(json['score']) ?? 0,
      remark: json['remark']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      analysis: (rawAnalysis != null && rawAnalysis.isNotEmpty)
          ? rawAnalysis
          : legacyJoined,
      muscleMassKg: safeParseDouble(json['muscle_mass_kg']),
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class SymmetryScoreModel {
  final int score;
  final String remark;
  final String status;
  final String analysis;
  final List<String> weeklyPriorities;

  const SymmetryScoreModel({
    required this.score,
    required this.remark,
    required this.status,
    required this.analysis,
    required this.weeklyPriorities,
  });

  factory SymmetryScoreModel.fromJson(Map<String, dynamic> json) {
    final rawAnalysis = json['analysis']?.toString();
    final legacyJoined = [
      json['detected_summary'],
      json['rationale'],
      json['next_step'],
    ].where((s) => s != null && s.toString().trim().isNotEmpty).join('\n\n');
    return SymmetryScoreModel(
      score: safeParseInt(json['score']) ?? 0,
      remark: json['remark']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      analysis: (rawAnalysis != null && rawAnalysis.isNotEmpty)
          ? rawAnalysis
          : legacyJoined,
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class PostureAnalysisModel {
  final int score;
  final String remark;
  final String status;
  final String analysis;
  final String pelvicTilt;
  final String headPosition;
  final String spinalPosition;
  final String shoulderPosition;
  final List<String> weeklyPriorities;

  const PostureAnalysisModel({
    required this.score,
    required this.remark,
    required this.status,
    required this.analysis,
    required this.pelvicTilt,
    required this.headPosition,
    required this.spinalPosition,
    required this.shoulderPosition,
    required this.weeklyPriorities,
  });

  factory PostureAnalysisModel.fromJson(Map<String, dynamic> json) {
    final rawAnalysis = json['analysis']?.toString();
    final legacyJoined = [
      json['detected_summary'],
      json['rationale'],
      json['next_step'],
    ].where((s) => s != null && s.toString().trim().isNotEmpty).join('\n\n');
    return PostureAnalysisModel(
      score: safeParseInt(json['score']) ?? 0,
      remark: json['remark']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      analysis: (rawAnalysis != null && rawAnalysis.isNotEmpty)
          ? rawAnalysis
          : legacyJoined,
      pelvicTilt: json['pelvic_tilt']?.toString() ?? '',
      headPosition: json['head_position']?.toString() ?? '',
      spinalPosition: json['spinal_position']?.toString() ?? '',
      shoulderPosition: json['shoulder_position']?.toString() ?? '',
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ConsistencyModel {
  final int score;
  final String remark;
  final String status;
  final String analysis;
  final List<String> weeklyPriorities;

  const ConsistencyModel({
    required this.score,
    required this.remark,
    required this.status,
    required this.analysis,
    required this.weeklyPriorities,
  });

  factory ConsistencyModel.fromJson(Map<String, dynamic> json) {
    final rawAnalysis = json['analysis']?.toString();
    final legacyJoined = [
      json['detected_summary'],
      json['rationale'],
      json['next_step'],
    ].where((s) => s != null && s.toString().trim().isNotEmpty).join('\n\n');
    return ConsistencyModel(
      score: safeParseInt(json['score']) ?? 0,
      remark: json['remark']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      analysis: (rawAnalysis != null && rawAnalysis.isNotEmpty)
          ? rawAnalysis
          : legacyJoined,
      weeklyPriorities: (json['weekly_priorities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class AnalysisResultModel {
  final FatLossModel? fatLoss;
  final MuscleGrowthModel? muscleGrowth;
  final SymmetryScoreModel? symmetryScore;
  final PostureAnalysisModel? postureAnalysis;
  final ConsistencyModel? consistencyAnalysis;
  final List<InsightTitleSubtitleItem> strength;
  final List<InsightTitleSubtitleItem> focusArea;
  final List<InsightTitleSubtitleItem> nextSteps;
  final String overallWeeklyInsight;

  const AnalysisResultModel({
    this.fatLoss,
    this.muscleGrowth,
    this.symmetryScore,
    this.postureAnalysis,
    this.consistencyAnalysis,
    required this.strength,
    required this.focusArea,
    required this.nextSteps,
    required this.overallWeeklyInsight,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      fatLoss: json['fat_loss'] is Map<String, dynamic>
          ? FatLossModel.fromJson(json['fat_loss'] as Map<String, dynamic>)
          : null,
      muscleGrowth: json['muscle_growth'] is Map<String, dynamic>
          ? MuscleGrowthModel.fromJson(
              json['muscle_growth'] as Map<String, dynamic>,
            )
          : null,
      symmetryScore: json['symmetry_score'] is Map<String, dynamic>
          ? SymmetryScoreModel.fromJson(
              json['symmetry_score'] as Map<String, dynamic>,
            )
          : null,
      postureAnalysis: json['posture_analysis'] is Map<String, dynamic>
          ? PostureAnalysisModel.fromJson(
              json['posture_analysis'] as Map<String, dynamic>,
            )
          : null,
      consistencyAnalysis: json['consistency_analysis'] is Map<String, dynamic>
          ? ConsistencyModel.fromJson(
              json['consistency_analysis'] as Map<String, dynamic>,
            )
          : null,
      strength: (json['strength'] as List<dynamic>?)
              ?.map((e) {
                if (e is Map<String, dynamic>) {
                  return InsightTitleSubtitleItem.fromJson(e);
                }
                return InsightTitleSubtitleItem(
                  title: e?.toString() ?? '',
                  subtitle: '',
                );
              })
              .toList() ??
          [],
      focusArea: (json['focus_area'] as List<dynamic>?)
              ?.map((e) {
                if (e is Map<String, dynamic>) {
                  return InsightTitleSubtitleItem.fromJson(e);
                }
                return InsightTitleSubtitleItem(
                  title: e?.toString() ?? '',
                  subtitle: '',
                );
              })
              .toList() ??
          [],
      nextSteps: (json['next_steps'] as List<dynamic>?)
              ?.map((e) {
                if (e is Map<String, dynamic>) {
                  return InsightTitleSubtitleItem.fromJson(e);
                }
                return InsightTitleSubtitleItem(
                  title: e?.toString() ?? '',
                  subtitle: '',
                );
              })
              .toList() ??
          [],
      overallWeeklyInsight: json['overall_weekly_insight']?.toString() ?? '',
    );
  }
}

class ScanLatestResponseModel {
  final String id;
  final String scanDate;
  final String status;
  final int checkinNumber;
  final String source;
  final double? weightKg;
  final String? frontImageUrl;
  final String? backImageUrl;
  final String? sideImageUrl;
  final String? frontThumbUrl;
  final String? backThumbUrl;
  final String? sideThumbUrl;
  final AnalysisResultModel? analysisResult;
  final bool analysisLocked;
  final List<String> analysisHeadings;
  final String? errorMessage;
  final String? createdAt;
  final String? updatedAt;

  const ScanLatestResponseModel({
    required this.id,
    required this.scanDate,
    required this.status,
    required this.checkinNumber,
    required this.source,
    this.weightKg,
    this.frontImageUrl,
    this.backImageUrl,
    this.sideImageUrl,
    this.frontThumbUrl,
    this.backThumbUrl,
    this.sideThumbUrl,
    this.analysisResult,
    this.analysisLocked = false,
    this.analysisHeadings = const [],
    this.errorMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory ScanLatestResponseModel.fromJson(Map<String, dynamic> json) {
    return ScanLatestResponseModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      source: json['source']?.toString() ?? '',
      weightKg: safeParseDouble(json['weight_kg']),
      frontImageUrl: json['front_image_url']?.toString(),
      backImageUrl: json['back_image_url']?.toString(),
      sideImageUrl: json['side_image_url']?.toString(),
      frontThumbUrl: json['front_thumb_url']?.toString(),
      backThumbUrl: json['back_thumb_url']?.toString(),
      sideThumbUrl: json['side_thumb_url']?.toString(),
      analysisResult: json['analysis_result'] is Map<String, dynamic>
          ? AnalysisResultModel.fromJson(
              json['analysis_result'] as Map<String, dynamic>,
            )
          : null,
      analysisLocked: json['analysis_locked'] as bool? ??
          (json['analysis_result'] == null && json['status'] == 'completed'),
      analysisHeadings: (json['analysis_headings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      errorMessage: json['error_message']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
