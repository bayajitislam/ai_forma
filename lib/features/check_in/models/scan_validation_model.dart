class ViewCheckDetail {
  final String status;
  final bool isHuman;
  final bool matchesExpectedView;
  final String detectedView;
  final String? detectedSex;
  final bool sexMatches;
  final String? reason;

  ViewCheckDetail({
    required this.status,
    required this.isHuman,
    required this.matchesExpectedView,
    required this.detectedView,
    this.detectedSex,
    required this.sexMatches,
    this.reason,
  });

  factory ViewCheckDetail.fromJson(Map<String, dynamic> json) {
    return ViewCheckDetail(
      status: json['status'] ?? '',
      isHuman: json['is_human'] ?? false,
      matchesExpectedView: json['matches_expected_view'] ?? false,
      detectedView: json['detected_view'] ?? '',
      detectedSex: json['detected_sex']?.toString(),
      sexMatches: json['sex_matches'] ?? false,
      reason: json['reason']?.toString(),
    );
  }

  bool get isValid => isHuman && matchesExpectedView && sexMatches;

  String get displayReason {
    if (reason != null && reason!.isNotEmpty) {
      return reason!;
    }
    if (!isHuman) {
      return 'No human detected in image';
    }
    if (!matchesExpectedView) {
      return 'Pose mismatch (detected: $detectedView)';
    }
    if (!sexMatches) {
      return 'Gender mismatch detected';
    }
    return 'Validation failed';
  }
}

class ScanValidationResponseModel {
  final String status;
  final bool allValid;
  final ViewCheckDetail? frontCheck;
  final ViewCheckDetail? backCheck;
  final ViewCheckDetail? sideCheck;

  ScanValidationResponseModel({
    required this.status,
    required this.allValid,
    this.frontCheck,
    this.backCheck,
    this.sideCheck,
  });

  factory ScanValidationResponseModel.fromJson(Map<String, dynamic> json) {
    final checksMap = json['checks'] is Map ? json['checks'] as Map<String, dynamic> : {};

    return ScanValidationResponseModel(
      status: json['status'] ?? '',
      allValid: json['all_valid'] ?? false,
      frontCheck: checksMap['front'] != null
          ? ViewCheckDetail.fromJson(checksMap['front'] as Map<String, dynamic>)
          : null,
      backCheck: checksMap['back'] != null
          ? ViewCheckDetail.fromJson(checksMap['back'] as Map<String, dynamic>)
          : null,
      sideCheck: checksMap['side'] != null
          ? ViewCheckDetail.fromJson(checksMap['side'] as Map<String, dynamic>)
          : null,
    );
  }
}
