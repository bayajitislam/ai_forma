import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class CompareScansListResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<CompareScanItemModel> results;

  const CompareScansListResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory CompareScansListResponseModel.fromJson(Map<String, dynamic> json) {
    return CompareScansListResponseModel(
      count: safeParseInt(json['count']) ?? 0,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => CompareScanItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}

class CompareScanItemModel {
  final String id;
  final String scanDate;
  final String status;
  final String? frontThumbUrl;
  final String createdAt;

  const CompareScanItemModel({
    required this.id,
    required this.scanDate,
    required this.status,
    this.frontThumbUrl,
    required this.createdAt,
  });

  factory CompareScanItemModel.fromJson(Map<String, dynamic> json) {
    return CompareScanItemModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      frontThumbUrl: json['front_thumb_url']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
