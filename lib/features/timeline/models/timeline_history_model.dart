import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class TimelineHistoryResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<TimelineHistoryScanItemModel> results;

  const TimelineHistoryResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory TimelineHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TimelineHistoryResponseModel(
      count: safeParseInt(json['count']) ?? 0,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => TimelineHistoryScanItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}

class TimelineHistoryScanItemModel {
  final String id;
  final String scanDate;
  final int checkinNumber;
  final String month;
  final String monthLabel;
  final TimelineThumbsModel? thumbs;

  const TimelineHistoryScanItemModel({
    required this.id,
    required this.scanDate,
    required this.checkinNumber,
    required this.month,
    required this.monthLabel,
    this.thumbs,
  });

  factory TimelineHistoryScanItemModel.fromJson(Map<String, dynamic> json) {
    return TimelineHistoryScanItemModel(
      id: json['id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      checkinNumber: safeParseInt(json['checkin_number']) ?? 0,
      month: json['month']?.toString() ?? '',
      monthLabel: json['month_label']?.toString() ?? '',
      thumbs: json['thumbs'] is Map<String, dynamic>
          ? TimelineThumbsModel.fromJson(
              json['thumbs'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
