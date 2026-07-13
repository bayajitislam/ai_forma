import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/age_view.dart';
import 'package:ai_forma/features/assessment/view/pages/height_view.dart';
import 'package:ai_forma/features/assessment/view/pages/objective_view.dart';
import 'package:ai_forma/features/assessment/view/pages/supplements_view.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/pages/compare_scans_view.dart';
import 'package:ai_forma/features/insights/view/pages/comparison_summary_view.dart';
import 'package:ai_forma/features/insights/view/pages/consistency_view.dart';
import 'package:ai_forma/features/insights/view/pages/focus_areas_view.dart';
import 'package:ai_forma/features/insights/view/pages/insights_view.dart';
import 'package:ai_forma/features/insights/view/pages/muscle_growth_view.dart';
import 'package:ai_forma/features/insights/view/pages/posture_analysis_view.dart';
import 'package:ai_forma/features/insights/view/pages/next_step_view.dart';
import 'package:ai_forma/features/insights/view/pages/strengths_view.dart';
import 'package:ai_forma/features/insights/view/pages/visual_scan_view.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_home_view.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/shell/constants/shell_strings.dart';
import 'package:ai_forma/features/shell/view/pages/app_shell_view.dart';
import 'package:ai_forma/features/assessment/view/pages/weight_view.dart';
import 'package:ai_forma/features/assessment/view/pages/gender_view.dart';
import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/pages/login_view.dart';
import 'package:ai_forma/features/auth/view/pages/signup_view.dart';
import 'package:ai_forma/features/onboarding/constants/onboarding_strings.dart';
import 'package:ai_forma/features/onboarding/constants/privacy_strings.dart';
import 'package:ai_forma/features/onboarding/view/pages/onboarding_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/privacy_onboarding_view.dart';
import 'package:ai_forma/features/splash/constants/splash_strings.dart';
import 'package:ai_forma/features/splash/view/widgets/splash_content.dart';

void main() {
  testWidgets('Splash content shows AiFORMA branding', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SplashContent())),
    );

    expect(find.text(SplashStrings.appSubTagline), findsOneWidget);
    expect(find.text(SplashStrings.sloganLine1), findsOneWidget);
    expect(find.text(SplashStrings.sloganLine2), findsOneWidget);
  });

  testWidgets('Onboarding screen shows AiFORMA features and continue button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingView()));

    expect(find.text(OnboardingStrings.subtitle), findsOneWidget);
    expect(
      find.text(OnboardingStrings.featureAiBodyAnalysisTitle),
      findsOneWidget,
    );
    expect(find.text(AppStrings.continueButton), findsOneWidget);
  });

  testWidgets('Privacy onboarding shows data protection cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyOnboardingView()));

    expect(find.text(PrivacyStrings.title), findsOneWidget);
    expect(find.text(PrivacyStrings.youOwnYourData), findsOneWidget);
    expect(find.text(PrivacyStrings.protectedCloudStorage), findsOneWidget);
    expect(find.text(AppStrings.continueButton), findsOneWidget);
  });

  testWidgets('Signup screen shows form and create account button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignupView()));

    expect(find.text(AuthStrings.signupSubtitle), findsOneWidget);
    expect(find.text(AuthStrings.createAccountButton), findsOneWidget);
    expect(find.text(AuthStrings.fullNameLabel), findsOneWidget);
  });

  testWidgets('Login screen shows welcome and log in button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    expect(find.text(AuthStrings.loginTitle), findsOneWidget);
    expect(find.text(AuthStrings.loginButton), findsOneWidget);
    expect(find.text(AuthStrings.forgotPassword), findsOneWidget);
  });

  testWidgets('Gender assessment screen shows options and next button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GenderView()));

    expect(find.text(AssessmentStrings.genderTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.genderMale), findsOneWidget);
    expect(find.text(AssessmentStrings.genderFemale), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Age assessment screen shows picker and next button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AgeView()));

    expect(find.text(AssessmentStrings.ageTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.ageSubtitle), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultAge}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Height assessment screen shows toggle and picker', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HeightView()));

    expect(find.text(AssessmentStrings.heightTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.heightUnitCm), findsOneWidget);
    expect(find.text(AssessmentStrings.heightUnitFt), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultHeightCm}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Weight assessment screen shows toggle and picker', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WeightView()));

    expect(find.text(AssessmentStrings.weightTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.weightUnitKg), findsOneWidget);
    expect(find.text(AssessmentStrings.weightUnitLb), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultWeightKg}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Objective assessment screen shows goal options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ObjectiveView()));

    expect(find.text(AssessmentStrings.objectiveTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.objectiveReduceBodyFat), findsOneWidget);
    expect(
      find.text(AssessmentStrings.objectiveIncreaseMuscle),
      findsOneWidget,
    );
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Supplements assessment screen shows multi-select options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SupplementsView()));

    expect(find.text(AssessmentStrings.supplementsTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.supplementProtein), findsOneWidget);
    expect(find.text(AssessmentStrings.supplementCreatine), findsOneWidget);
    expect(find.text(AssessmentStrings.skip), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('App shell shows dashboard and bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AppShellView()));

    expect(find.text(DashboardStrings.momentumTitle), findsOneWidget);
    expect(find.text(DashboardStrings.todaysPriority), findsOneWidget);
    expect(find.text(DashboardStrings.currentWeight), findsOneWidget);
    expect(find.text(ShellStrings.navHome), findsOneWidget);
    expect(find.text(ShellStrings.navCheckIn), findsOneWidget);
    expect(find.text(ShellStrings.navInsights), findsOneWidget);
    expect(find.text(ShellStrings.navProfile), findsOneWidget);
  });

  testWidgets('Insights screen shows categories and key insights', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InsightsView()));

    expect(find.text(InsightsStrings.keyInsights), findsOneWidget);
    expect(find.text(InsightsStrings.categoryStrengths), findsOneWidget);
    expect(find.text(InsightsStrings.muscleGrowth), findsOneWidget);
    expect(find.text(InsightsStrings.compareScans), findsOneWidget);
  });

  testWidgets('Strengths category navigates to strengths detail page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InsightsView()));

    await tester.tap(find.text(InsightsStrings.categoryStrengths));
    await tester.pumpAndSettle();

    expect(find.text(InsightsStrings.strengthsTitle), findsOneWidget);
    expect(find.text(InsightsStrings.shoulderDevelopment), findsOneWidget);
    expect(find.text(InsightsStrings.recoveryHabits), findsOneWidget);
  });

  testWidgets('Strengths detail page shows all strength items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: StrengthsView()));

    expect(find.text(InsightsStrings.strengthsTitle), findsOneWidget);
    expect(find.text(InsightsStrings.strengthsSubtitle), findsOneWidget);
    expect(find.text(InsightsStrings.trainingConsistency), findsOneWidget);
    expect(find.text(InsightsStrings.upperBodyDevelopment), findsOneWidget);
  });

  testWidgets('Focus areas page shows highest impact opportunities', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FocusAreasView()));

    expect(find.text(InsightsStrings.focusAreasTitle), findsOneWidget);
    expect(find.text(InsightsStrings.lowerAbs), findsOneWidget);
    expect(find.text(InsightsStrings.gluteDevelopment), findsNWidgets(2));
    expect(find.text(InsightsStrings.calves), findsOneWidget);
    expect(find.text(InsightsStrings.postureFocus), findsOneWidget);
  });

  testWidgets('Next step page shows next step', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NextStepView()));

    expect(find.text(InsightsStrings.nextStepsTitle), findsOneWidget);
    expect(find.text(InsightsStrings.nutrition), findsOneWidget);
    expect(find.text(InsightsStrings.training), findsOneWidget);
    expect(find.text(InsightsStrings.cardio), findsOneWidget);
    expect(find.text(InsightsStrings.recovery), findsOneWidget);
  });

  testWidgets('Muscle growth metric navigates to detail page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InsightsView()));

    await tester.tap(find.text(InsightsStrings.muscleGrowth));
    await tester.pumpAndSettle();

    expect(find.text(InsightsStrings.muscleGrowthScoreLabel), findsOneWidget);
    expect(find.text(InsightsStrings.aiFormaAnalysis), findsOneWidget);
    expect(find.text(InsightsStrings.thisWeeksPriorities), findsOneWidget);
  });

  testWidgets('Muscle growth detail page shows score and stats', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MuscleGrowthView()));

    expect(find.text(InsightsStrings.muscleGrowth), findsOneWidget);
    expect(find.text(InsightsStrings.muscleMass), findsOneWidget);
    expect(find.text(InsightsStrings.muscleGrowthPriority1), findsOneWidget);
  });

  testWidgets('Posture analysis page shows comparison and status list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PostureAnalysisView()));

    expect(find.text(InsightsStrings.postureAnalysis), findsOneWidget);
    expect(find.text(InsightsStrings.shoulderPosition), findsOneWidget);
    expect(find.text(InsightsStrings.posturePriority1), findsOneWidget);
  });

  testWidgets('Consistency page shows grid and stats', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ConsistencyView()));

    expect(find.text(InsightsStrings.consistencyScoreLabel), findsOneWidget);
    expect(find.text(InsightsStrings.currentStreak), findsOneWidget);
    expect(find.text(InsightsStrings.consistencyPriority1), findsOneWidget);
  });

  testWidgets('Compare scans button opens compare scans page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InsightsView()));

    await tester.ensureVisible(find.text(InsightsStrings.compareScans));
    await tester.tap(find.text(InsightsStrings.compareScans));
    await tester.pumpAndSettle();

    expect(find.text(InsightsStrings.compareScansTitle), findsOneWidget);
    expect(find.text(InsightsStrings.scanDateMay18), findsOneWidget);
    expect(find.text(InsightsStrings.generateComparison), findsOneWidget);
  });

  testWidgets('Compare scans page shows selectable scan cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CompareScansView()));

    expect(find.text(InsightsStrings.compareScansSubtitle), findsOneWidget);
    expect(find.text(InsightsStrings.scanDateMay4), findsOneWidget);
    expect(find.text(InsightsStrings.scanDateApr27), findsOneWidget);
    expect(find.text(InsightsStrings.latestScanLabel), findsOneWidget);
  });

  testWidgets('Generate comparison opens summary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CompareScansView()));

    await tester.tap(find.text(InsightsStrings.generateComparison));
    await tester.pumpAndSettle();

    expect(
      find.text(
        InsightsStrings.comparisonTitle(
          InsightsStrings.scanShortMay4,
          InsightsStrings.scanShortMay18,
        ),
      ),
      findsOneWidget,
    );
    expect(find.text(InsightsStrings.aiComparisonSummary), findsOneWidget);
    expect(find.text(InsightsStrings.comparisonBodyFatChange), findsOneWidget);
  });

  testWidgets('Comparison summary page shows then/now and metrics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ComparisonSummaryView()));

    expect(find.text(InsightsStrings.comparisonThen), findsOneWidget);
    expect(find.text(InsightsStrings.comparisonNow), findsOneWidget);
    expect(find.text(InsightsStrings.comparisonMuscleMass), findsOneWidget);
    expect(find.text(InsightsStrings.comparisonWeightChange), findsOneWidget);
  });

  testWidgets('Comparison icon opens visual scan page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ComparisonSummaryView()));

    await tester.tap(find.byIcon(AppIcons.layoutColumn));
    await tester.pumpAndSettle();

    expect(find.text(InsightsStrings.visualScanTitle), findsOneWidget);
    expect(find.text(InsightsStrings.slideToCompare), findsOneWidget);
    expect(find.text(InsightsStrings.scanShortMay4), findsOneWidget);
    expect(find.text(InsightsStrings.scanShortMay18), findsOneWidget);
  });

  testWidgets('Visual scan page shows interactive compare slider', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VisualScanView()));

    expect(find.text(InsightsStrings.visualScanTitle), findsOneWidget);
    expect(find.text(InsightsStrings.slideToCompare), findsOneWidget);
  });

  testWidgets('Check-in home shows streak and begin scan button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CheckInHomeView()));

    expect(find.text(CheckInStrings.beginNewScan), findsOneWidget);
    expect(find.text(CheckInStrings.latestScan), findsOneWidget);
    expect(find.text(CheckInStrings.statTotal), findsOneWidget);
  });
}
