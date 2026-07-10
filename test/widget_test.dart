import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/age_view.dart';
import 'package:ai_forma/features/assessment/view/pages/height_view.dart';
import 'package:ai_forma/features/assessment/view/pages/objective_view.dart';
import 'package:ai_forma/features/assessment/view/pages/supplements_view.dart';
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
  testWidgets('Splash content shows AiFORMA branding', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SplashContent(),
        ),
      ),
    );

    expect(find.text(SplashStrings.appSubTagline), findsOneWidget);
    expect(find.text(SplashStrings.sloganLine1), findsOneWidget);
    expect(find.text(SplashStrings.sloganLine2), findsOneWidget);
  });

  testWidgets('Onboarding screen shows AiFORMA features and continue button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OnboardingView()),
    );

    expect(find.text(OnboardingStrings.subtitle), findsOneWidget);
    expect(find.text(OnboardingStrings.featureAiBodyAnalysisTitle),
        findsOneWidget);
    expect(find.text(AppStrings.continueButton), findsOneWidget);
  });

  testWidgets('Privacy onboarding shows data protection cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrivacyOnboardingView()),
    );

    expect(find.text(PrivacyStrings.title), findsOneWidget);
    expect(find.text(PrivacyStrings.youOwnYourData), findsOneWidget);
    expect(find.text(PrivacyStrings.protectedCloudStorage), findsOneWidget);
    expect(find.text(AppStrings.continueButton), findsOneWidget);
  });

  testWidgets('Signup screen shows form and create account button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SignupView()),
    );

    expect(find.text(AuthStrings.signupSubtitle), findsOneWidget);
    expect(find.text(AuthStrings.createAccountButton), findsOneWidget);
    expect(find.text(AuthStrings.fullNameLabel), findsOneWidget);
  });

  testWidgets('Login screen shows welcome and log in button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginView()),
    );

    expect(find.text(AuthStrings.loginTitle), findsOneWidget);
    expect(find.text(AuthStrings.loginButton), findsOneWidget);
    expect(find.text(AuthStrings.forgotPassword), findsOneWidget);
  });

  testWidgets('Gender assessment screen shows options and next button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: GenderView()),
    );

    expect(find.text(AssessmentStrings.genderTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.genderMale), findsOneWidget);
    expect(find.text(AssessmentStrings.genderFemale), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Age assessment screen shows picker and next button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AgeView()),
    );

    expect(find.text(AssessmentStrings.ageTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.ageSubtitle), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultAge}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Height assessment screen shows toggle and picker',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HeightView()),
    );

    expect(find.text(AssessmentStrings.heightTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.heightUnitCm), findsOneWidget);
    expect(find.text(AssessmentStrings.heightUnitFt), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultHeightCm}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Weight assessment screen shows toggle and picker',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: WeightView()),
    );

    expect(find.text(AssessmentStrings.weightTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.weightUnitKg), findsOneWidget);
    expect(find.text(AssessmentStrings.weightUnitLb), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultWeightKg}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Objective assessment screen shows goal options',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ObjectiveView()),
    );

    expect(find.text(AssessmentStrings.objectiveTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.objectiveReduceBodyFat), findsOneWidget);
    expect(find.text(AssessmentStrings.objectiveIncreaseMuscle), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Supplements assessment screen shows multi-select options',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SupplementsView()),
    );

    expect(find.text(AssessmentStrings.supplementsTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.supplementProtein), findsOneWidget);
    expect(find.text(AssessmentStrings.supplementCreatine), findsOneWidget);
    expect(find.text(AssessmentStrings.skip), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('App shell shows dashboard and bottom navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppShellView()),
    );

    expect(find.text(DashboardStrings.momentumTitle), findsOneWidget);
    expect(find.text(DashboardStrings.todaysPriority), findsOneWidget);
    expect(find.text(DashboardStrings.currentWeight), findsOneWidget);
    expect(find.text(ShellStrings.navHome), findsOneWidget);
    expect(find.text(ShellStrings.navCheckIn), findsOneWidget);
    expect(find.text(ShellStrings.navAnalysis), findsOneWidget);
    expect(find.text(ShellStrings.navProfile), findsOneWidget);
  });

  testWidgets('Check-in home shows streak and begin scan button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CheckInHomeView()),
    );

    expect(find.text(CheckInStrings.beginNewScan), findsOneWidget);
    expect(find.text(CheckInStrings.latestScan), findsOneWidget);
    expect(find.text(CheckInStrings.statTotal), findsOneWidget);
  });
}
