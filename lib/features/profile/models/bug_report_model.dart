class BugReportResponseModel {
  final int id;
  final String title;
  final String description;
  final String createdAt;

  const BugReportResponseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory BugReportResponseModel.fromJson(Map<String, dynamic> json) {
    return BugReportResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
