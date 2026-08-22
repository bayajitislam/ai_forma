import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class TimelineScanDetailResponseModel {
  final String id;
  final String scanDate;
  final int checkinNumber;
  final bool isLatest;
  final bool analysisLocked;
  final TimelineDetailSummaryModel? summary;
  final TimelineDetailPhotosModel? photos;
  final TimelineDetailComparisonModel? comparison;

  const TimelineScanDetailResponseModel({
    required this.id,
    required this.scanDate,
    required this.checkinNumber,
    required this.isLatest,
    required this.analysisLocked,
    this.summary,
    this.photos,
    this.comparison,
  });

  factory TimelineScanDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return TimelineScanDetailResponseModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      isLatest: json['is_latest'] as bool? ?? false,
      analysisLocked: json['analysis_locked'] as bool? ?? false,
      summary: json['summary'] is Map<String, dynamic>
          ? TimelineDetailSummaryModel.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
      photos: json['photos'] is Map<String, dynamic>
          ? TimelineDetailPhotosModel.fromJson(
              json['photos'] as Map<String, dynamic>,
            )
          : null,
      comparison: json['comparison'] is Map<String, dynamic>
          ? TimelineDetailComparisonModel.fromJson(
              json['comparison'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MetricValueChangeModel {
  final double? value;
  final String? change;

  const MetricValueChangeModel({
    this.value,
    this.change,
  });

  factory MetricValueChangeModel.fromJson(Map<String, dynamic> json, String valueKey, String changeKey) {
    return MetricValueChangeModel(
      value: safeParseDouble(json[valueKey]),
      change: json[changeKey]?.toString(),
    );
  }
}

class DetailMomentumModel {
  final int score;

  const DetailMomentumModel({required this.score});

  factory DetailMomentumModel.fromJson(Map<String, dynamic> json) {
    return DetailMomentumModel(
      score: safeParseInt(json['score']) ?? 0,
    );
  }
}

class TimelineDetailSummaryModel {
  final MetricValueChangeModel? bodyFat;
  final MetricValueChangeModel? muscle;
  final MetricValueChangeModel? weight;
  final DetailMomentumModel? momentum;

  const TimelineDetailSummaryModel({
    this.bodyFat,
    this.muscle,
    this.weight,
    this.momentum,
  });

  factory TimelineDetailSummaryModel.fromJson(Map<String, dynamic> json) {
    return TimelineDetailSummaryModel(
      bodyFat: json['body_fat'] is Map<String, dynamic>
          ? MetricValueChangeModel.fromJson(
              json['body_fat'] as Map<String, dynamic>,
              'percent',
              'change_percent',
            )
          : null,
      muscle: json['muscle'] is Map<String, dynamic>
          ? MetricValueChangeModel.fromJson(
              json['muscle'] as Map<String, dynamic>,
              'kg',
              'change_kg',
            )
          : null,
      weight: json['weight'] is Map<String, dynamic>
          ? MetricValueChangeModel.fromJson(
              json['weight'] as Map<String, dynamic>,
              'kg',
              'change_kg',
            )
          : null,
      momentum: json['momentum'] is Map<String, dynamic>
          ? DetailMomentumModel.fromJson(
              json['momentum'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TimelinePhotoViewItemModel {
  final String view;
  final String label;
  final String? imageUrl;
  final String? thumbUrl;

  const TimelinePhotoViewItemModel({
    required this.view,
    required this.label,
    this.imageUrl,
    this.thumbUrl,
  });

  factory TimelinePhotoViewItemModel.fromJson(Map<String, dynamic> json) {
    return TimelinePhotoViewItemModel(
      view: json['view']?.toString() ?? (json['key']?.toString() ?? ''),
      label: json['label']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      thumbUrl: json['thumb_url']?.toString(),
    );
  }
}

class TimelineDetailPhotosModel {
  final String title;
  final List<TimelinePhotoViewItemModel> views;

  const TimelineDetailPhotosModel({
    required this.title,
    required this.views,
  });

  factory TimelineDetailPhotosModel.fromJson(Map<String, dynamic> json) {
    return TimelineDetailPhotosModel(
      title: json['title']?.toString() ?? '',
      views: (json['views'] as List<dynamic>?)
              ?.map((e) => TimelinePhotoViewItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}

class ComparisonScanModel {
  final String id;
  final String scanDate;
  final TimelineThumbsModel? thumbs;

  const ComparisonScanModel({
    required this.id,
    required this.scanDate,
    this.thumbs,
  });

  factory ComparisonScanModel.fromJson(Map<String, dynamic> json) {
    return ComparisonScanModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      thumbs: json['thumbs'] is Map<String, dynamic>
          ? TimelineThumbsModel.fromJson(
              json['thumbs'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ComparisonDeltasModel {
  final String? bodyFatPercent;
  final String? muscleMassKg;
  final String? weightKg;

  const ComparisonDeltasModel({
    this.bodyFatPercent,
    this.muscleMassKg,
    this.weightKg,
  });

  factory ComparisonDeltasModel.fromJson(Map<String, dynamic> json) {
    return ComparisonDeltasModel(
      bodyFatPercent: json['body_fat_percent']?.toString(),
      muscleMassKg: json['muscle_mass_kg']?.toString(),
      weightKg: json['weight_kg']?.toString(),
    );
  }
}

class TimelineDetailComparisonModel {
  final String title;
  final ComparisonScanModel? then;
  final ComparisonScanModel? now;
  final ComparisonDeltasModel? deltas;

  const TimelineDetailComparisonModel({
    required this.title,
    this.then,
    this.now,
    this.deltas,
  });

  factory TimelineDetailComparisonModel.fromJson(Map<String, dynamic> json) {
    return TimelineDetailComparisonModel(
      title: json['title']?.toString() ?? '',
      then: json['then'] is Map<String, dynamic>
          ? ComparisonScanModel.fromJson(
              json['then'] as Map<String, dynamic>,
            )
          : null,
      now: json['now'] is Map<String, dynamic>
          ? ComparisonScanModel.fromJson(
              json['now'] as Map<String, dynamic>,
            )
          : null,
      deltas: json['deltas'] is Map<String, dynamic>
          ? ComparisonDeltasModel.fromJson(
              json['deltas'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
