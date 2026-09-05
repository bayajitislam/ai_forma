import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_position_view.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/insights/bindings/insights_binding.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:ai_forma/features/dashboard/view/widgets/ai_daily_brief_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weekly_scan_card.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';
import 'package:ai_forma/features/insights/view/pages/insights_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
  });

  group('Scan completion navigation and DioClient lifecycle', () {
    testWidgets('DioClient registered with permanent: true survives Get.offAll', (tester) async {
      Get.put(DioClient(), permanent: true);
      expect(Get.isRegistered<DioClient>(), isTrue);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(body: Text('Initial Screen')),
        ),
      );
      await tester.pump();

      // Trigger Get.offAll to navigate to a new screen
      Get.offAll(() => const Scaffold(body: Text('New Screen')));
      await tester.pump();

      // DioClient MUST still be registered
      expect(Get.isRegistered<DioClient>(), isTrue);
      expect(Get.find<DioClient>(), isA<DioClient>());
    });

    test('InsightsBinding gracefully resolves DioClient with fallback', () {
      // Even if DioClient was never put before, InsightsBinding must not crash
      expect(Get.isRegistered<DioClient>(), isFalse);

      InsightsBinding().dependencies();

      expect(Get.isRegistered<DioClient>(), isTrue);
      expect(Get.isRegistered<InsightsRepository>(), isTrue);
      expect(Get.isRegistered<InsightsController>(), isTrue);
    });

    testWidgets('InsightsController survives Get.offAll due to permanent: true in InsightsBinding', (tester) async {
      InsightsBinding().dependencies();
      expect(Get.isRegistered<InsightsController>(), isTrue);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(body: Text('Screen 1')),
        ),
      );
      await tester.pump();

      Get.offAll(() => const Scaffold(body: Text('Screen 2')));
      await tester.pump();

      // InsightsController MUST still be registered because of permanent: true
      expect(Get.isRegistered<InsightsController>(), isTrue);
    });

    testWidgets('InsightsView self-heals and builds safely even if InsightsController was not registered', (tester) async {
      expect(Get.isRegistered<InsightsController>(), isFalse);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: InsightsView(),
          ),
        ),
      );
      await tester.pump();

      // InsightsController must be self-healed and registered with permanent: true
      expect(Get.isRegistered<InsightsController>(), isTrue);
      expect(find.byType(InsightsView), findsOneWidget);
    });

    test('CheckInRepository and CheckInController initialize safely with permanent DioClient', () {
      Get.put(DioClient(), permanent: true);

      final repo = CheckInRepository(
        Get.isRegistered<DioClient>()
            ? Get.find<DioClient>()
            : Get.put(DioClient(), permanent: true),
      );
      expect(repo, isA<CheckInRepository>());

      final controller = CheckInController(repository: repo);
      expect(controller, isA<CheckInController>());
    });

    test('ScanLatestResponseModel parses scan #2 locked response safely', () {
      final json = {
        'id': 'scan_123',
        'scan_date': '2026-09-05',
        'status': 'completed',
        'checkin_number': 2,
        'source': 'weekly',
        'analysis_locked': true,
        'analysis_result': null,
      };

      final model = ScanLatestResponseModel.fromJson(json);
      expect(model.id, 'scan_123');
      expect(model.checkinNumber, 2);
      expect(model.analysisLocked, isTrue);
      expect(model.analysisResult, isNull);
    });

    test('ScanLatestResponseModel parses string-based lists in analysis_result without crashing', () {
      final json = {
        'id': 'scan_124',
        'scan_date': '2026-09-05',
        'status': 'completed',
        'checkin_number': 2,
        'source': 'weekly',
        'analysis_locked': false,
        'analysis_result': {
          'strength': ['Shoulder development', 'Upper body symmetry'],
          'focus_area': ['Lower back posture'],
          'next_steps': ['Progressive overload on squats'],
          'overall_weekly_insight': 'Great progress this week.',
        },
      };

      final model = ScanLatestResponseModel.fromJson(json);
      expect(model.analysisResult, isNotNull);
      expect(model.analysisResult!.strength.length, 2);
      expect(model.analysisResult!.strength[0].title, 'Shoulder development');
      expect(model.analysisResult!.focusArea[0].title, 'Lower back posture');
      expect(model.analysisResult!.nextSteps[0].title, 'Progressive overload on squats');
    });
  });

  group('Daily Brief Card and Scan Weight Enforcement Tests', () {
    testWidgets('AIDailyBriefCard with Update Weight opens WeightEntryBottomSheet and does not route to Insights', (tester) async {
      bool insightNavigated = false;

      final brief = HomeDailyBriefModel(
        visible: true,
        alreadyAnswered: false,
        heading: 'TODAY\'S BRIEF',
        title: 'Update Weight',
        subtitle: 'Please log your weight before weekly scan',
        ctaLabel: 'Update Weight',
        questionKey: 'weight',
        step: {'question': 'How is your weight?'},
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AIDailyBriefCard(
              dailyBriefData: brief,
              goInsightPage: () {
                insightNavigated = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Update Weight'), findsWidgets);

      // Tap on the CTA button
      await tester.tap(find.text('Update Weight').last);
      await tester.pumpAndSettle();

      // Insight route should NOT be navigated
      expect(insightNavigated, isFalse);

      // WeightEntryBottomSheet should be displayed
      expect(find.byType(WeightEntryBottomSheet), findsOneWidget);
      expect(find.text('Save Weight'), findsOneWidget);
    });

    testWidgets('WeeklyScanCard shows Buy Premium AppDialog when user is free', (tester) async {
      Get.put(DioClient(), permanent: true);

      final userController = Get.put(UserController(Get.find<DioClient>()));
      userController.currentUser.value = UserModel(
        id: 1,
        email: 'test@example.com',
        fullName: 'Test User',
        isEmailVerified: true,
        onboardingCompleted: true,
        initialScanCompleted: true,
        isPaid: false, // Free user
      );

      final checkInRepo = CheckInRepository(Get.find<DioClient>());
      Get.put(CheckInController(repository: checkInRepo));

      final dashboardRepo = DashboardRepository(Get.find<DioClient>());
      final homeController = Get.put(HomeController(repository: dashboardRepo));

      homeController.homeData.value = HomeResponseModel(
        weeklyScan: HomeWeeklyScanModel(
          visible: true,
          title: 'Weekly Scan Ready',
          subtitle: 'Scan is ready for this week',
          ctaLabel: 'Begin Weekly Scan',
        ),
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: WeeklyScanCard(
              weeklyScanData: homeController.homeData.value?.weeklyScan,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Weekly Scan'));
      await tester.pumpAndSettle();

      // Premium AppDialog should be displayed!
      expect(find.text('AiFORMA Premium'), findsOneWidget);
      expect(find.text('Buy Premium'), findsOneWidget);
      expect(find.byType(WeightEntryBottomSheet), findsNothing);
    });

    testWidgets('WeeklyScanCard shows Weight AppDialog when premium user has unanswered weight, and Log Weight opens sheet', (tester) async {
      Get.put(DioClient(), permanent: true);

      final user = UserModel(
        id: 1,
        email: 'test@example.com',
        fullName: 'Test User',
        isEmailVerified: true,
        onboardingCompleted: true,
        initialScanCompleted: true,
        isPaid: true, // Premium user
      );
      await AuthStorage.saveUser(user);

      final userController = Get.put(UserController(Get.find<DioClient>()));
      userController.currentUser.value = user;

      final checkInRepo = CheckInRepository(Get.find<DioClient>());
      Get.put(CheckInController(repository: checkInRepo));

      final dashboardRepo = DashboardRepository(Get.find<DioClient>());
      final homeController = Get.put(HomeController(repository: dashboardRepo));

      homeController.homeData.value = HomeResponseModel(
        dailyBrief: HomeDailyBriefModel(
          visible: true,
          alreadyAnswered: false,
          heading: 'TODAY\'S BRIEF',
          title: 'Update Weight',
          ctaLabel: 'Update Weight',
          questionKey: 'weight',
          step: {'question': 'How is your weight?'},
        ),
        weeklyScan: HomeWeeklyScanModel(
          visible: true,
          title: 'Weekly Scan Ready',
          subtitle: 'Scan is ready for this week',
          ctaLabel: 'Begin Weekly Scan',
        ),
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: WeeklyScanCard(
              weeklyScanData: homeController.homeData.value?.weeklyScan,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on the Begin Weekly Scan button
      await tester.tap(find.text('Begin Weekly Scan'));
      await tester.pumpAndSettle();

      // Weight AppDialog must be displayed!
      expect(find.text('Log Weight Before Scan'), findsOneWidget);
      expect(find.text('Log Weight'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Tap on Log Weight
      await tester.tap(find.text('Log Weight'));
      await tester.pumpAndSettle();

      // WeightEntryBottomSheet should now be open
      expect(find.byType(WeightEntryBottomSheet), findsOneWidget);
      expect(find.text('Save Weight'), findsOneWidget);
    });

    testWidgets('WeeklyScanCard allows user to Skip weight logging and proceed to scan', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      Get.put(DioClient(), permanent: true);

      final user = UserModel(
        id: 1,
        email: 'test@example.com',
        fullName: 'Test User',
        isEmailVerified: true,
        onboardingCompleted: true,
        initialScanCompleted: true,
        isPaid: true, // Premium user
      );
      await AuthStorage.saveUser(user);

      final userController = Get.put(UserController(Get.find<DioClient>()));
      userController.currentUser.value = user;

      final checkInRepo = CheckInRepository(Get.find<DioClient>());
      Get.put(CheckInController(repository: checkInRepo));

      final dashboardRepo = DashboardRepository(Get.find<DioClient>());
      final homeController = Get.put(HomeController(repository: dashboardRepo));

      homeController.homeData.value = HomeResponseModel(
        dailyBrief: HomeDailyBriefModel(
          visible: true,
          alreadyAnswered: false,
          heading: 'TODAY\'S BRIEF',
          title: 'Update Weight',
          questionKey: 'weight',
        ),
        weeklyScan: HomeWeeklyScanModel(
          visible: true,
          title: 'Weekly Scan Ready',
          subtitle: 'Scan is ready for this week',
          ctaLabel: 'Begin Weekly Scan',
        ),
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: WeeklyScanCard(
              weeklyScanData: homeController.homeData.value?.weeklyScan,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Begin Weekly Scan
      await tester.tap(find.text('Begin Weekly Scan'));
      await tester.pumpAndSettle();

      // Weight AppDialog must be displayed
      expect(find.text('Log Weight Before Scan'), findsOneWidget);

      // Tap on Skip
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Weight sheet is NOT opened, navigated to camera position
      expect(find.byType(WeightEntryBottomSheet), findsNothing);
      expect(find.byType(CameraPositionView), findsOneWidget);
    });

    testWidgets('WeeklyScanCard navigates directly to scan when premium user already answered weight', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      Get.put(DioClient(), permanent: true);

      final user = UserModel(
        id: 1,
        email: 'test@example.com',
        fullName: 'Test User',
        isEmailVerified: true,
        onboardingCompleted: true,
        initialScanCompleted: true,
        isPaid: true, // Premium user
      );
      await AuthStorage.saveUser(user);

      final userController = Get.put(UserController(Get.find<DioClient>()));
      userController.currentUser.value = user;

      final checkInRepo = CheckInRepository(Get.find<DioClient>());
      Get.put(CheckInController(repository: checkInRepo));

      final dashboardRepo = DashboardRepository(Get.find<DioClient>());
      final homeController = Get.put(HomeController(repository: dashboardRepo));

      homeController.homeData.value = HomeResponseModel(
        dailyBrief: HomeDailyBriefModel(
          visible: true,
          alreadyAnswered: true,
          heading: 'DAILY BRIEF COMPLETED',
          title: 'Weight Logged',
          questionKey: 'weight',
        ),
        weeklyScan: HomeWeeklyScanModel(
          visible: true,
          title: 'Weekly Scan Ready',
          subtitle: 'Scan is ready for this week',
          ctaLabel: 'Begin Weekly Scan',
        ),
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: WeeklyScanCard(
              weeklyScanData: homeController.homeData.value?.weeklyScan,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Weekly Scan'));
      await tester.pumpAndSettle();

      // Does NOT open WeightEntryBottomSheet, navigates to camera position
      expect(find.byType(WeightEntryBottomSheet), findsNothing);
      expect(find.text('Log Weight Before Scan'), findsNothing);
      expect(find.byType(CameraPositionView), findsOneWidget);
    });
  });

  group('Insights Navigation and Locked Analysis Tests', () {
    test('ScanLatestResponseModel infers analysisLocked when analysis_result is null on completed scan', () {
      final json = {
        'id': 'd9ad90c7-ec64-4f6f-b5d7-318b57cff1ea',
        'scan_date': '2026-09-05',
        'status': 'completed',
        'checkin_number': 2,
        'source': 'scheduled',
        'weight_kg': '51.0',
        'analysis_result': null,
        'analysis_headings': [
          'Physique Changes',
          'What AiFORMA Noticed',
          'Progress Summary',
          'Suggested Adjustments',
        ],
      };

      final model = ScanLatestResponseModel.fromJson(json);
      expect(model.analysisLocked, isTrue);
      expect(model.analysisHeadings.length, 4);
      expect(model.analysisHeadings.first, 'Physique Changes');
    });

    testWidgets('InsightsView renders safely and does not stay in loading when analysis is locked', (tester) async {
      Get.put(DioClient(), permanent: true);
      final repo = InsightsRepository(Get.find<DioClient>());
      final controller = Get.put(InsightsController(repository: repo), permanent: true);

      controller.latestScan.value = ScanLatestResponseModel(
        id: 'scan_1',
        scanDate: '2026-09-05',
        status: 'completed',
        checkinNumber: 2,
        source: 'scheduled',
        analysisLocked: true,
        analysisResult: null,
      );
      controller.isLoading.value = false;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: InsightsView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
