class CompareResultResponseModel {
  final String title;
  final bool analysisLocked;
  final CompareScanCardModel? then;
  final CompareScanCardModel? now;
  final CompareDeltasModel? deltas;

  const CompareResultResponseModel({
    required this.title,
    required this.analysisLocked,
    this.then,
    this.now,
    this.deltas,
  });

  factory CompareResultResponseModel.fromJson(Map<String, dynamic> json) {
    return CompareResultResponseModel(
      title: json['title']?.toString() ?? '',
      analysisLocked: json['analysis_locked'] as bool? ?? false,
      then: json['then'] is Map<String, dynamic>
          ? CompareScanCardModel.fromJson(
              json['then'] as Map<String, dynamic>,
            )
          : null,
      now: json['now'] is Map<String, dynamic>
          ? CompareScanCardModel.fromJson(
              json['now'] as Map<String, dynamic>,
            )
          : null,
      deltas: json['deltas'] is Map<String, dynamic>
          ? CompareDeltasModel.fromJson(
              json['deltas'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CompareScanCardModel {
  final String id;
  final String scanDate;
  final String? frontImageUrl;
  final String? frontThumbUrl;

  const CompareScanCardModel({
    required this.id,
    required this.scanDate,
    this.frontImageUrl,
    this.frontThumbUrl,
  });

  factory CompareScanCardModel.fromJson(Map<String, dynamic> json) {
    return CompareScanCardModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      frontImageUrl: json['front_image_url']?.toString(),
      frontThumbUrl: json['front_thumb_url']?.toString(),
    );
  }
}

class CompareDeltasModel {
  final String? bodyFatPercent;
  final String? muscleMassKg;
  final String? weightKg;

  const CompareDeltasModel({
    this.bodyFatPercent,
    this.muscleMassKg,
    this.weightKg,
  });

  factory CompareDeltasModel.fromJson(Map<String, dynamic> json) {
    return CompareDeltasModel(
      bodyFatPercent: json['body_fat_percent']?.toString(),
      muscleMassKg: json['muscle_mass_kg']?.toString(),
      weightKg: json['weight_kg']?.toString(),
    );
  }
}
