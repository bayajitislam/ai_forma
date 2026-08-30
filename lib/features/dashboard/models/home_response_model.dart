import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';

class HomeResponseModel {
  final HomeHeaderModel? header;
  final HomeMomentumModel? momentum;
  final HomeTodayPriorityModel? todayPriority;
  final HomeDailyBriefModel? dailyBrief;
  final HomeWeeklyScanModel? weeklyScan;
  final HomeWeightModel? weight;
  final HomeLatestAnalysisModel? latestAnalysis;
  final HomeAiInsightModel? aiInsight;
  final DailyBriefAiFeedbackModel? todayAiFeedback;

  const HomeResponseModel({
    this.header,
    this.momentum,
    this.todayPriority,
    this.dailyBrief,
    this.weeklyScan,
    this.weight,
    this.latestAnalysis,
    this.aiInsight,
    this.todayAiFeedback,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      header: json['header'] is Map<String, dynamic>
          ? HomeHeaderModel.fromJson(json['header'] as Map<String, dynamic>)
          : null,
      momentum: json['momentum'] is Map<String, dynamic>
          ? HomeMomentumModel.fromJson(json['momentum'] as Map<String, dynamic>)
          : null,
      todayPriority: json['today_priority'] is Map<String, dynamic>
          ? HomeTodayPriorityModel.fromJson(
              json['today_priority'] as Map<String, dynamic>,
            )
          : null,
      dailyBrief: json['daily_brief'] is Map<String, dynamic>
          ? HomeDailyBriefModel.fromJson(
              json['daily_brief'] as Map<String, dynamic>,
            )
          : null,
      weeklyScan: json['weekly_scan'] is Map<String, dynamic>
          ? HomeWeeklyScanModel.fromJson(
              json['weekly_scan'] as Map<String, dynamic>,
            )
          : null,
      weight: json['weight'] is Map<String, dynamic>
          ? HomeWeightModel.fromJson(json['weight'] as Map<String, dynamic>)
          : null,
      latestAnalysis: json['latest_analysis'] is Map<String, dynamic>
          ? HomeLatestAnalysisModel.fromJson(
              json['latest_analysis'] as Map<String, dynamic>,
            )
          : null,
      aiInsight: json['ai_insight'] is Map<String, dynamic>
          ? HomeAiInsightModel.fromJson(json['ai_insight'] as Map<String, dynamic>)
          : null,
      todayAiFeedback: json['today_ai_feedback'] is Map<String, dynamic>
          ? DailyBriefAiFeedbackModel.fromJson(
              json['today_ai_feedback'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class HomeHeaderModel {
  final String greeting;
  final String? firstName;
  final String statusMessage;
  final String? avatarUrl;
  final String today;

  const HomeHeaderModel({
    required this.greeting,
    this.firstName,
    required this.statusMessage,
    this.avatarUrl,
    required this.today,
  });

  factory HomeHeaderModel.fromJson(Map<String, dynamic> json) {
    return HomeHeaderModel(
      greeting: json['greeting']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      statusMessage: json['status_message']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      today: json['today']?.toString() ?? '',
    );
  }
}

class HomeMomentumModel {
  final int displayedScore;
  final int max;
  final int? change;
  final String state;
  final String stateLabel;
  final String insight;
  final List<HomeMomentumPillModel> pills;

  const HomeMomentumModel({
    required this.displayedScore,
    required this.max,
    this.change,
    required this.state,
    required this.stateLabel,
    required this.insight,
    required this.pills,
  });

  factory HomeMomentumModel.fromJson(Map<String, dynamic> json) {
    return HomeMomentumModel(
      displayedScore: safeParseInt(json['displayed_score']) ?? 0,
      max: safeParseInt(json['max']) ?? 100,
      change: safeParseInt(json['change']),
      state: json['state']?.toString() ?? '',
      stateLabel: json['state_label']?.toString() ?? '',
      insight: json['insight']?.toString() ?? '',
      pills: (json['pills'] as List<dynamic>?)
              ?.map((e) => HomeMomentumPillModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }
}

class HomeMomentumPillModel {
  final String key;
  final String label;
  final String display;

  const HomeMomentumPillModel({
    required this.key,
    required this.label,
    required this.display,
  });

  factory HomeMomentumPillModel.fromJson(Map<String, dynamic> json) {
    return HomeMomentumPillModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      display: json['display']?.toString() ?? '',
    );
  }
}

class HomeTodayPriorityModel {
  final String kind;
  final String text;
  final String? ctaLabel;
  final bool alreadyAnswered;

  const HomeTodayPriorityModel({
    required this.kind,
    required this.text,
    this.ctaLabel,
    required this.alreadyAnswered,
  });

  factory HomeTodayPriorityModel.fromJson(Map<String, dynamic> json) {
    return HomeTodayPriorityModel(
      kind: json['kind']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      ctaLabel: json['cta_label']?.toString(),
      alreadyAnswered: json['already_answered'] as bool? ?? false,
    );
  }
}

class DailyBriefAiFeedbackModel {
  final String? title;
  final String? description;

  const DailyBriefAiFeedbackModel({
    this.title,
    this.description,
  });

  factory DailyBriefAiFeedbackModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = json;
    if (json['ai_feedback'] is Map<String, dynamic>) {
      dataMap = json['ai_feedback'] as Map<String, dynamic>;
    }
    if (dataMap['data'] is Map<String, dynamic>) {
      dataMap = dataMap['data'] as Map<String, dynamic>;
    }

    return DailyBriefAiFeedbackModel(
      title: dataMap['title']?.toString(),
      description: dataMap['description']?.toString(),
    );
  }
}

class HomeDailyBriefModel {
  final bool visible;
  final String? kind;
  final String? heading;
  final int? badge;
  final int? answeredCount;
  final int? total;
  final String? questionKey;
  final String? selectedOption;
  final String? title;
  final String? subtitle;
  final String? ctaLabel;
  final bool alreadyAnswered;
  final int? cycleNumber;
  final String? previousWeekOption;
  final String? weightKgPrefill;
  final Map<String, dynamic>? step;
  final DailyBriefAiFeedbackModel? aiFeedback;

  const HomeDailyBriefModel({
    required this.visible,
    this.kind,
    this.heading,
    this.badge,
    this.answeredCount,
    this.total,
    this.questionKey,
    this.selectedOption,
    this.title,
    this.subtitle,
    this.ctaLabel,
    this.alreadyAnswered = false,
    this.cycleNumber,
    this.previousWeekOption,
    this.weightKgPrefill,
    this.step,
    this.aiFeedback,
  });

  factory HomeDailyBriefModel.fromJson(Map<String, dynamic> json) {
    return HomeDailyBriefModel(
      visible: json['visible'] as bool? ?? false,
      kind: json['kind']?.toString(),
      heading: json['heading']?.toString(),
      badge: safeParseInt(json['badge']),
      answeredCount: safeParseInt(json['answered_count']),
      total: safeParseInt(json['total']),
      questionKey: json['question_key']?.toString(),
      selectedOption: json['selected_option']?.toString(),
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString(),
      ctaLabel: json['cta_label']?.toString(),
      alreadyAnswered: json['already_answered'] as bool? ?? false,
      cycleNumber: safeParseInt(json['cycle_number']),
      previousWeekOption: json['previous_week_option']?.toString(),
      weightKgPrefill: json['weight_kg_prefill']?.toString(),
      step: json['step'] is Map<String, dynamic>
          ? json['step'] as Map<String, dynamic>
          : null,
      aiFeedback: json['ai_feedback'] is Map<String, dynamic>
          ? DailyBriefAiFeedbackModel.fromJson(
              json['ai_feedback'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class HomeWeeklyScanModel {
  final bool visible;
  final String? kind;
  final String? title;
  final String? subtitle;
  final String? ctaLabel;
  final String? attachedBriefsLabel;
  final bool paywallRequired;
  final bool weightLogged;
  final String? cycleWeightKg;

  const HomeWeeklyScanModel({
    required this.visible,
    this.kind,
    this.title,
    this.subtitle,
    this.ctaLabel,
    this.attachedBriefsLabel,
    this.paywallRequired = false,
    this.weightLogged = false,
    this.cycleWeightKg,
  });

  factory HomeWeeklyScanModel.fromJson(Map<String, dynamic> json) {
    return HomeWeeklyScanModel(
      visible: json['visible'] as bool? ?? false,
      kind: json['kind']?.toString(),
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString(),
      ctaLabel: json['cta_label']?.toString(),
      attachedBriefsLabel: json['attached_briefs_label']?.toString(),
      paywallRequired: json['paywall_required'] as bool? ?? false,
      weightLogged: json['weight_logged'] as bool? ?? false,
      cycleWeightKg: json['cycle_weight_kg']?.toString(),
    );
  }
}

class HomeWeightModel {
  final String? currentKg;
  final String? changeKg;
  final String changeLabel;
  final String status;
  final String statusLabel;
  final String statusTone;

  const HomeWeightModel({
    this.currentKg,
    this.changeKg,
    required this.changeLabel,
    required this.status,
    required this.statusLabel,
    required this.statusTone,
  });

  factory HomeWeightModel.fromJson(Map<String, dynamic> json) {
    return HomeWeightModel(
      currentKg: json['current_kg']?.toString(),
      changeKg: json['change_kg']?.toString(),
      changeLabel: json['change_label']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      statusTone: json['status_tone']?.toString() ?? '',
    );
  }
}

class HomeLatestAnalysisModel {
  final String scanId;
  final String scanDate;
  final List<HomeScanViewModel> views;
  final bool analysisLocked;

  const HomeLatestAnalysisModel({
    required this.scanId,
    required this.scanDate,
    required this.views,
    required this.analysisLocked,
  });

  factory HomeLatestAnalysisModel.fromJson(Map<String, dynamic> json) {
    return HomeLatestAnalysisModel(
      scanId: json['scan_id']?.toString() ?? '',
      scanDate: json['scan_date']?.toString() ?? '',
      views: (json['views'] as List<dynamic>?)
              ?.map((e) => HomeScanViewModel.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      analysisLocked: json['analysis_locked'] as bool? ?? false,
    );
  }
}

class HomeScanViewModel {
  final String key;
  final String label;
  final String? thumbUrl;
  final String? imageUrl;

  const HomeScanViewModel({
    required this.key,
    required this.label,
    this.thumbUrl,
    this.imageUrl,
  });

  factory HomeScanViewModel.fromJson(Map<String, dynamic> json) {
    return HomeScanViewModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      thumbUrl: json['thumb_url']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class HomeAiInsightModel {
  final String? text;
  final String? ctaLabel;
  final String? scanId;

  const HomeAiInsightModel({
    this.text,
    this.ctaLabel,
    this.scanId,
  });

  factory HomeAiInsightModel.fromJson(Map<String, dynamic> json) {
    return HomeAiInsightModel(
      text: json['text']?.toString(),
      ctaLabel: json['cta_label']?.toString(),
      scanId: json['scan_id']?.toString(),
    );
  }
}
