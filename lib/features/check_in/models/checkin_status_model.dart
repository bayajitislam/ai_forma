class StreakCycleModel {
  final int cycleNumber;
  final String status;
  final bool isCompleted;

  StreakCycleModel({
    required this.cycleNumber,
    required this.status,
    required this.isCompleted,
  });

  factory StreakCycleModel.fromJson(Map<String, dynamic> json) {
    return StreakCycleModel(
      cycleNumber: (json['cycle_number'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }
}

class CheckinCtaModel {
  final String label;
  final String kind;
  final String action;
  final int? cycleNumber;

  CheckinCtaModel({
    required this.label,
    required this.kind,
    required this.action,
    this.cycleNumber,
  });

  factory CheckinCtaModel.fromJson(Map<String, dynamic> json) {
    return CheckinCtaModel(
      label: json['label']?.toString() ?? 'BEGIN NEW SCAN',
      kind: json['kind']?.toString() ?? 'weekly',
      action: json['action']?.toString() ?? 'open_camera',
      cycleNumber: (json['cycle_number'] as num?)?.toInt(),
    );
  }
}

class LatestScanThumbsModel {
  final String? front;
  final String? side;
  final String? back;

  LatestScanThumbsModel({
    this.front,
    this.side,
    this.back,
  });

  factory LatestScanThumbsModel.fromJson(Map<String, dynamic> json) {
    return LatestScanThumbsModel(
      front: json['front']?.toString(),
      side: json['side']?.toString(),
      back: json['back']?.toString(),
    );
  }
}

class LatestScanModel {
  final String? publicId;
  final int? checkinNumber;
  final String? scanDate;
  final String? formattedScanDate;
  final String? insight;
  final LatestScanThumbsModel? thumbs;

  LatestScanModel({
    this.publicId,
    this.checkinNumber,
    this.scanDate,
    this.formattedScanDate,
    this.insight,
    this.thumbs,
  });

  factory LatestScanModel.fromJson(Map<String, dynamic> json) {
    return LatestScanModel(
      publicId: json['public_id']?.toString(),
      checkinNumber: (json['checkin_number'] as num?)?.toInt(),
      scanDate: json['scan_date']?.toString(),
      formattedScanDate: json['formatted_scan_date']?.toString(),
      insight: json['insight']?.toString(),
      thumbs: json['thumbs'] != null && json['thumbs'] is Map<String, dynamic>
          ? LatestScanThumbsModel.fromJson(json['thumbs'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LatestInsightModel {
  final String heading;
  final String text;
  final String ctaLabel;
  final String? scanId;

  LatestInsightModel({
    required this.heading,
    required this.text,
    required this.ctaLabel,
    this.scanId,
  });

  factory LatestInsightModel.fromJson(Map<String, dynamic> json) {
    return LatestInsightModel(
      heading: json['heading']?.toString() ?? 'Latest Insight',
      text: json['text']?.toString() ?? '',
      ctaLabel: json['cta_label']?.toString() ?? 'View Insight',
      scanId: json['scan_id']?.toString(),
    );
  }
}

class CheckinMomentumModel {
  final int displayedScore;
  final String state;
  final int change;
  final String insight;

  CheckinMomentumModel({
    required this.displayedScore,
    required this.state,
    required this.change,
    required this.insight,
  });

  factory CheckinMomentumModel.fromJson(Map<String, dynamic> json) {
    return CheckinMomentumModel(
      displayedScore: (json['displayed_score'] as num?)?.toInt() ?? 0,
      state: json['state']?.toString() ?? '',
      change: (json['change'] as num?)?.toInt() ?? 0,
      insight: json['insight']?.toString() ?? '',
    );
  }
}

class CheckinWindowModel {
  final String? opensAt;
  final String? closesAt;
  final String? status;
  final int? number;

  CheckinWindowModel({
    this.opensAt,
    this.closesAt,
    this.status,
    this.number,
  });

  factory CheckinWindowModel.fromJson(Map<String, dynamic> json) {
    return CheckinWindowModel(
      opensAt: json['opens_at']?.toString(),
      closesAt: json['closes_at']?.toString(),
      status: json['status']?.toString(),
      number: (json['number'] as num?)?.toInt(),
    );
  }
}

class CheckinTodayModel {
  final String kind;
  final int cycleNumber;
  final bool alreadyAnswered;
  final bool weeklyCheckinAvailable;

  CheckinTodayModel({
    required this.kind,
    required this.cycleNumber,
    required this.alreadyAnswered,
    required this.weeklyCheckinAvailable,
  });

  factory CheckinTodayModel.fromJson(Map<String, dynamic> json) {
    return CheckinTodayModel(
      kind: json['kind']?.toString() ?? 'weekly',
      cycleNumber: (json['cycle_number'] as num?)?.toInt() ?? 0,
      alreadyAnswered: json['already_answered'] as bool? ?? false,
      weeklyCheckinAvailable: json['weekly_checkin_available'] as bool? ?? false,
    );
  }
}

class CheckinSubscriptionModel {
  final bool isPaid;
  final String state;

  CheckinSubscriptionModel({
    required this.isPaid,
    required this.state,
  });

  factory CheckinSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return CheckinSubscriptionModel(
      isPaid: json['is_paid'] as bool? ?? false,
      state: json['state']?.toString() ?? '',
    );
  }
}

class CheckinStatusModel {
  final String phase;
  final int checkinNumber;
  final int totalCheckins;
  final int streakWeeks;
  final int personalBestWeeks;
  final List<StreakCycleModel> streakHistory;
  final int onTimePercent;
  final String checkDay;
  final String currentWeightKg;
  final String currentWeightLbs;
  final String weightChangeKg;
  final String weightChangeLbs;
  final String weightChangeLabel;
  final LatestScanModel? latestScan;
  final LatestInsightModel? latestInsight;
  final CheckinCtaModel? cta;
  final CheckinMomentumModel? momentum;
  final CheckinWindowModel? window;
  final CheckinTodayModel? today;
  final CheckinSubscriptionModel? subscription;

  CheckinStatusModel({
    required this.phase,
    required this.checkinNumber,
    required this.totalCheckins,
    required this.streakWeeks,
    required this.personalBestWeeks,
    required this.streakHistory,
    required this.onTimePercent,
    required this.checkDay,
    required this.currentWeightKg,
    required this.currentWeightLbs,
    required this.weightChangeKg,
    required this.weightChangeLbs,
    required this.weightChangeLabel,
    this.latestScan,
    this.latestInsight,
    this.cta,
    this.momentum,
    this.window,
    this.today,
    this.subscription,
  });

  factory CheckinStatusModel.fromJson(Map<String, dynamic> json) {
    return CheckinStatusModel(
      phase: json['phase']?.toString() ?? '',
      checkinNumber: (json['checkin_number'] as num?)?.toInt() ?? 0,
      totalCheckins: (json['total_checkins'] as num?)?.toInt() ?? 0,
      streakWeeks: (json['streak_weeks'] as num?)?.toInt() ?? 0,
      personalBestWeeks: (json['personal_best_weeks'] as num?)?.toInt() ?? 0,
      streakHistory: json['streak_history'] != null && json['streak_history'] is List
          ? (json['streak_history'] as List)
              .map((e) => StreakCycleModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      onTimePercent: (json['on_time_percent'] as num?)?.toInt() ?? 0,
      checkDay: json['check_day']?.toString() ?? 'Sun',
      currentWeightKg: json['current_weight_kg']?.toString() ?? '',
      currentWeightLbs: json['current_weight_lbs']?.toString() ?? '',
      weightChangeKg: json['weight_change_kg']?.toString() ?? '',
      weightChangeLbs: json['weight_change_lbs']?.toString() ?? '',
      weightChangeLabel: json['weight_change_label']?.toString() ?? '',
      latestScan: json['latest_scan'] != null && json['latest_scan'] is Map<String, dynamic>
          ? LatestScanModel.fromJson(json['latest_scan'] as Map<String, dynamic>)
          : null,
      latestInsight: json['latest_insight'] != null && json['latest_insight'] is Map<String, dynamic>
          ? LatestInsightModel.fromJson(json['latest_insight'] as Map<String, dynamic>)
          : null,
      cta: json['cta'] != null && json['cta'] is Map<String, dynamic>
          ? CheckinCtaModel.fromJson(json['cta'] as Map<String, dynamic>)
          : null,
      momentum: json['momentum'] != null && json['momentum'] is Map<String, dynamic>
          ? CheckinMomentumModel.fromJson(json['momentum'] as Map<String, dynamic>)
          : null,
      window: json['window'] != null && json['window'] is Map<String, dynamic>
          ? CheckinWindowModel.fromJson(json['window'] as Map<String, dynamic>)
          : null,
      today: json['today'] != null && json['today'] is Map<String, dynamic>
          ? CheckinTodayModel.fromJson(json['today'] as Map<String, dynamic>)
          : null,
      subscription: json['subscription'] != null && json['subscription'] is Map<String, dynamic>
          ? CheckinSubscriptionModel.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
    );
  }
}
