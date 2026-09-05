import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/view/widgets/dashboard_header.dart';
import 'package:ai_forma/features/dashboard/view/widgets/momentum_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/todays_priority_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weekly_scan_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_daily_brief_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/latest_check_in_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_insight_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, dynamic> sampleHomeJson = {
    "header": {
      "greeting": "Hello, Josh",
      "first_name": "Josh",
      "status_message": "Your transformation is progressing steadily.",
      "avatar_url": null,
      "today": "2026-07-18"
    },
    "momentum": {
      "displayed_score": 82,
      "max": 100,
      "change": 12,
      "state": "strong_momentum",
      "state_label": "Strong Momentum",
      "insight": "You're making measurable progress. Keep doing what works.",
      "pills": [
        {"key": "muscle", "label": "Muscle +1.5%", "display": "+1.5%"},
        {"key": "fat", "label": "Fat -0.6 kg", "display": "-0.6 kg"},
        {"key": "streak", "label": "2 week streak", "display": "2 week streak"}
      ]
    },
    "today_priority": {
      "kind": "daily",
      "text": "Complete today's Daily Brief to maintain your momentum score.",
      "cta_label": "Answer Daily Brief",
      "already_answered": false
    },
    "daily_brief": {
      "visible": true,
      "heading": "AI DAILY BRIEF",
      "badge": 6,
      "answered_count": 0,
      "total": 6,
      "question_key": "sleep",
      "title": "How did you sleep most nights this week?",
      "subtitle": "Your answers help AiFORMA build a more accurate understanding of your recovery before your next scan.",
      "cta_label": "Answer today's question",
      "already_answered": false,
      "cycle_number": 2,
      "previous_week_option": null,
      "weight_kg_prefill": "87.4",
      "step": {
        "heading": "AI DAILY BRIEF",
        "key": "sleep",
        "type": "single_choice",
        "title": "How did you sleep most nights this week?",
        "subtitle": "This helps AiFORMA understand your recovery and overall performance.",
        "cta_label": "Save response",
        "privacy_note": "Your response is private and used only to improve your next scan analysis.",
        "required": false,
        "skippable": true,
        "options": [
          {
            "value": "excellent",
            "label": "Excellent",
            "description": "8+ hours, very restful",
            "icon": "sleep_excellent"
          }
        ]
      }
    },
    "weekly_scan": {
      "visible": false
    },
    "weight": {
      "current_kg": "87.4",
      "change_kg": "-0.6",
      "change_label": "since last week",
      "status": "on_target",
      "status_label": "On target",
      "status_tone": "positive"
    },
    "latest_analysis": {
      "scan_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "scan_date": "2025-05-18",
      "views": [
        {"key": "front", "label": "Front", "thumb_url": null, "image_url": null},
        {"key": "side", "label": "Side", "thumb_url": null, "image_url": null},
        {"key": "back", "label": "Back", "thumb_url": null, "image_url": null}
      ],
      "analysis_locked": false
    },
    "ai_insight": {
      "text": "Shoulder definition has improved by 8% since your previous scan.",
      "cta_label": "View Analysis",
      "scan_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    }
  };

  group('Home Integration Spec Compliance Tests', () {
    test('HomeResponseModel correctly parses spec JSON', () {
      final model = HomeResponseModel.fromJson(sampleHomeJson);

      expect(model.header?.firstName, 'Josh');
      expect(model.header?.today, '2026-07-18');
      expect(model.momentum?.displayedScore, 82);
      expect(model.momentum?.change, 12);
      expect(model.momentum?.pills.length, 3);
      expect(model.todayPriority?.kind, 'daily');
      expect(model.todayPriority?.ctaLabel, 'Answer Daily Brief');
      expect(model.dailyBrief?.visible, true);
      expect(model.dailyBrief?.badge, 6);
      expect(model.weeklyScan?.visible, false);
      expect(model.weight?.statusTone, 'positive');
      expect(model.latestAnalysis?.scanId, 'a1b2c3d4-e5f6-7890-abcd-ef1234567890');
      expect(model.aiInsight?.text, contains('Shoulder definition'));
    });

    testWidgets('DashboardHeader formats greeting and status message', (tester) async {
      final headerModel = HomeHeaderModel.fromJson(sampleHomeJson['header']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardHeader(headerData: headerModel),
          ),
        ),
      );

      expect(find.text('Hello, Josh'), findsOneWidget);
      expect(find.text('Your transformation is progressing steadily.'), findsOneWidget);
    });

    testWidgets('MomentumCard renders pills from server and handles null change', (tester) async {
      final momentumModel = HomeMomentumModel.fromJson(sampleHomeJson['momentum']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MomentumCard(momentumData: momentumModel),
          ),
        ),
      );

      expect(find.text('82'), findsOneWidget);
      expect(find.text('+12 this week'), findsOneWidget);
      expect(find.text('Muscle +1.5%'), findsOneWidget);
      expect(find.text('Fat -0.6 kg'), findsOneWidget);
      expect(find.text('2 week streak'), findsOneWidget);
    });

    testWidgets('MomentumCard omits change badge when change is null', (tester) async {
      final noChangeJson = Map<String, dynamic>.from(sampleHomeJson['momentum']);
      noChangeJson['change'] = null;
      final momentumModel = HomeMomentumModel.fromJson(noChangeJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MomentumCard(momentumData: momentumModel),
          ),
        ),
      );

      expect(find.textContaining('this week'), findsNothing);
    });

    testWidgets('TodaysPriorityCard displays priority header and copy without CTA button', (tester) async {
      final priorityModel = HomeTodayPriorityModel.fromJson(sampleHomeJson['today_priority']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodaysPriorityCard(
              priorityData: priorityModel,
            ),
          ),
        ),
      );

      expect(find.text("TODAY'S PRIORITY"), findsOneWidget);
      expect(find.text("Complete today's Daily Brief to maintain your momentum score."), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('WeeklyScanCard hides when visible == false and shows when true', (tester) async {
      final hiddenScan = HomeWeeklyScanModel(visible: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeeklyScanCard(weeklyScanData: hiddenScan),
          ),
        ),
      );

      expect(find.text('WEEKLY SCAN'), findsNothing);

      final visibleScan = HomeWeeklyScanModel(
        visible: true,
        title: 'Your weekly scan is ready.',
        subtitle: 'Complete your photos to see how your body has changed.',
        ctaLabel: 'Begin Weekly Scan',
        attachedBriefsLabel: '6 daily brief responses from last week are attached to this scan.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeeklyScanCard(weeklyScanData: visibleScan),
          ),
        ),
      );

      expect(find.text('WEEKLY SCAN'), findsOneWidget);
      expect(find.text('Your weekly scan is ready.'), findsOneWidget);
      expect(find.text('Begin Weekly Scan'), findsOneWidget);
      expect(find.text('6 daily brief responses from last week are attached to this scan.'), findsOneWidget);
    });

    testWidgets('AIDailyBriefCard hides when visible == false', (tester) async {
      final hiddenBrief = HomeDailyBriefModel(visible: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIDailyBriefCard(dailyBriefData: hiddenBrief),
          ),
        ),
      );

      expect(find.text('AI DAILY BRIEF'), findsNothing);
    });

    testWidgets('AIDailyBriefCard renders transition mode on bridge days', (tester) async {
      final transitionBrief = HomeDailyBriefModel(
        visible: true,
        kind: 'transition',
        heading: 'BRIDGE DAY',
        title: 'Recovery Phase',
        subtitle: 'Quiet days before the next scan window opens.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIDailyBriefCard(dailyBriefData: transitionBrief),
          ),
        ),
      );

      expect(find.text('BRIDGE DAY'), findsOneWidget);
      expect(find.text('Recovery Phase'), findsOneWidget);
      expect(find.text('Answer today\'s question'), findsNothing);
    });

    testWidgets('AIDailyBriefCard renders active question and days until scan badge', (tester) async {
      final activeBrief = HomeDailyBriefModel(
        visible: true,
        heading: 'AI DAILY BRIEF',
        badge: 6,
        title: 'How did you sleep most nights this week?',
        subtitle: 'Your answers help AiFORMA build a more accurate understanding.',
        ctaLabel: 'Answer today\'s question',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIDailyBriefCard(dailyBriefData: activeBrief),
          ),
        ),
      );

      expect(find.text('AI DAILY BRIEF'), findsOneWidget);
      expect(find.text('6 days until your scan'), findsOneWidget);
      expect(find.text('How did you sleep most nights this week?'), findsOneWidget);
      expect(find.text('Answer today\'s question'), findsOneWidget);
    });

    testWidgets('AIDailyBriefCard shows "View Your Analysis" and triggers insight router when analysis is ready', (tester) async {
      final analysisReadyBrief = HomeDailyBriefModel(
        visible: true,
        heading: 'SCAN COMPLETE',
        title: 'Your new analysis is ready.',
        subtitle: 'Your latest physique scan has been processed.',
        ctaLabel: 'View Your Analysis',
        alreadyAnswered: true, // even if marked answered
      );

      bool insightNavigated = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIDailyBriefCard(
              dailyBriefData: analysisReadyBrief,
              goInsightPage: () => insightNavigated = true,
            ),
          ),
        ),
      );

      // Must NOT show "Completed for Today • Tap to change"
      expect(find.textContaining('Completed for Today'), findsNothing);
      // Must show the analysis CTA button
      expect(find.text('View Your Analysis'), findsOneWidget);

      await tester.tap(find.text('View Your Analysis'));
      expect(insightNavigated, isTrue);
    });

    testWidgets('AIDailyBriefCard shows "Completed for Today" when regular question was answered', (tester) async {
      final answeredBrief = HomeDailyBriefModel(
        visible: true,
        heading: 'AI DAILY BRIEF',
        badge: 5,
        title: 'How is your energy today?',
        subtitle: 'Responses help improve next analysis.',
        alreadyAnswered: true,
        step: const {
          'heading': 'AI DAILY BRIEF',
          'key': 'energy',
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AIDailyBriefCard(dailyBriefData: answeredBrief),
          ),
        ),
      );

      expect(find.textContaining('Completed for Today'), findsOneWidget);
    });

    testWidgets('LatestCheckInCard and AiInsightCard are null-safe', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                LatestCheckInCard(analysisData: null),
                AiInsightCard(goInsightPage: () {}, aiInsightData: null),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Latest Scan'), findsNothing);
      expect(find.text('AI INSIGHT'), findsNothing);
    });
  });
}
