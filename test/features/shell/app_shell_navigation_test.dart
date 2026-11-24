// Regression test for the "Something went wrong" screen shown after every
// weekly scan.
//
// The weekly scan is pushed on top of the app shell (Get.toNamed). "View
// results" then calls Get.offAllNamed(appShell, arguments: insights), which
// builds a second shell while the first one is still alive. When the first
// shell route is disposed, GetX deletes the controllers that were created
// under it. If AppShellBinding skipped re-registering them because they were
// still registered at that moment, the next tab rebuild throws
// '"HomeController" not found' and AppErrorWidget takes over the screen.
//
// This test drives that exact navigation with the real AppShellBinding,
// AppShellController and tab controllers. Repositories are faked so no
// request reaches the network.

import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/models/checkin_status_model.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/dashboard/controllers/home_controller.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/dashboard/repositories/dashboard_repository.dart';
import 'package:ai_forma/features/insights/controllers/insights_controller.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:ai_forma/features/insights/repositories/insights_repository.dart';
import 'package:ai_forma/features/shell/bindings/app_shell_binding.dart';
import 'package:ai_forma/features/shell/controllers/app_shell_controller.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/repositories/timeline_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

const _shellRoute = '/app_shell';
const _scanRoute = '/scan';

class _FakeCheckInRepository extends CheckInRepository {
  _FakeCheckInRepository() : super(DioClient());

  @override
  Future<Either<Failure, CheckinStatusModel>> getCheckInStatus() async =>
      Left(NetworkFailure());
}

class _FakeDashboardRepository extends DashboardRepository {
  _FakeDashboardRepository() : super(DioClient());

  int homeCalls = 0;

  @override
  Future<Either<Failure, HomeResponseModel>> getHomeData() async {
    homeCalls++;
    return Left(NetworkFailure());
  }
}

class _FakeInsightsRepository extends InsightsRepository {
  _FakeInsightsRepository() : super(DioClient());

  int latestScanCalls = 0;

  @override
  Future<Either<Failure, ScanLatestResponseModel>> getLatestScan({
    String? scanId,
  }) async {
    latestScanCalls++;
    return Left(NetworkFailure());
  }
}

class _FakeTimelineRepository extends TimelineRepository {
  _FakeTimelineRepository() : super(DioClient());
}

/// Forces the shell's tabs to rebuild, like a status refresh does in the app.
final _rebuildTabs = ValueNotifier<int>(0);

/// Stands in for AppShellView: looks up the same controllers the real tabs
/// look up during build. With [tabsVisited] false it only builds the shell,
/// like a user who opens the app on the Check-In tab.
class _ShellProbe extends StatelessWidget {
  const _ShellProbe({this.tabsVisited = true});

  final bool tabsVisited;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _rebuildTabs,
      builder: (_, _, _) {
        // Same fallback AppShellView uses.
        if (!Get.isRegistered<AppShellController>()) {
          Get.put(AppShellController());
        }
        Get.find<AppShellController>();
        if (!tabsVisited) return const Text('shell');
        Get.find<HomeController>(); // DashboardView
        Get.find<InsightsController>(); // InsightsView
        Get.find<TimelineController>(); // TimelineView
        return const Text('shell');
      },
    );
  }
}

void main() {
  late _FakeDashboardRepository dashboardRepository;
  late _FakeInsightsRepository insightsRepository;

  setUp(() {
    Get.reset();
    Get.testMode = true;
    dashboardRepository = _FakeDashboardRepository();
    insightsRepository = _FakeInsightsRepository();

    // Registered up front and permanent, so AppShellBinding keeps these fakes
    // instead of building the real network-backed repositories.
    Get.put<DioClient>(DioClient(), permanent: true);
    Get.put<DashboardRepository>(dashboardRepository, permanent: true);
    Get.put<InsightsRepository>(insightsRepository, permanent: true);
    Get.put<TimelineRepository>(_FakeTimelineRepository(), permanent: true);
    Get.put<CheckInRepository>(_FakeCheckInRepository(), permanent: true);
    Get.put<CheckInController>(
      CheckInController(repository: Get.find<CheckInRepository>()),
      permanent: true,
    );
  });

  tearDown(() => Get.reset());

  Future<void> openShellThenScan(
    WidgetTester tester, {
    bool tabsVisited = true,
  }) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: _shellRoute,
        getPages: [
          GetPage(
            name: _shellRoute,
            page: () => _ShellProbe(tabsVisited: tabsVisited),
            binding: AppShellBinding(),
          ),
          GetPage(name: _scanRoute, page: () => const Text('scan')),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // BEGIN NEW SCAN from the check-in tab pushes the scan flow on top.
    Get.toNamed<void>(_scanRoute);
    await tester.pumpAndSettle();
  }

  Future<void> viewResults(WidgetTester tester) async {
    // AnalysisCompleteView's "View results".
    Get.offAllNamed<void>(_shellRoute, arguments: AppNavItem.insights);
    // Finishes the transition and disposes the old shell route.
    await tester.pumpAndSettle();
  }

  testWidgets('tabs still find their controllers after View results',
      (tester) async {
    await openShellThenScan(tester);
    await viewResults(tester);

    _rebuildTabs.value++;
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(Get.isRegistered<HomeController>(), isTrue);
    expect(Get.isRegistered<InsightsController>(), isTrue);
    expect(Get.isRegistered<TimelineController>(), isTrue);
    expect(Get.isRegistered<AppShellController>(), isTrue);
  });

  testWidgets('View results opens the Insights tab and loads the new scan',
      (tester) async {
    await openShellThenScan(tester);
    expect(insightsRepository.latestScanCalls, 0);

    await viewResults(tester);

    expect(tester.takeException(), isNull);
    expect(
      Get.find<AppShellController>().selectedItem.value,
      AppNavItem.insights,
    );
    expect(insightsRepository.latestScanCalls, 1);
  });

  testWidgets('shell start loads Home data even if Home tab is not opened',
      (tester) async {
    // Begin Scan on the Check-In tab reads HomeController.homeData to decide
    // whether to ask for scan-day weight first, so it must already be loading.
    await openShellThenScan(tester, tabsVisited: false);

    expect(dashboardRepository.homeCalls, 1);
  });
}
