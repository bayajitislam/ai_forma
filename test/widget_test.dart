import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/age_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/height_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/objective_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/gender_view.dart';
import 'package:ai_forma/features/onboarding/constants/onboarding_strings.dart';
import 'package:ai_forma/features/onboarding/constants/privacy_strings.dart';
import 'package:ai_forma/features/onboarding/view/pages/onboarding_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/privacy_onboarding_view.dart';
import 'package:ai_forma/features/splash/constants/splash_strings.dart';
import 'package:ai_forma/features/splash/view/widgets/splash_content.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/pages/visual_scan_view.dart';

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
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

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
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: PrivacyOnboardingView()));

    expect(find.text(PrivacyStrings.title), findsOneWidget);
    expect(find.text(PrivacyStrings.youOwnYourData), findsOneWidget);
    expect(find.text(PrivacyStrings.protectedCloudStorage), findsOneWidget);
    expect(find.text(AppStrings.continueButton), findsOneWidget);
  });

  testWidgets('Gender assessment screen shows options and next button', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: GenderView()));

    expect(find.text(AssessmentStrings.genderTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.genderMale), findsOneWidget);
    expect(find.text(AssessmentStrings.genderFemale), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Age assessment screen shows picker and next button', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: AgeView()));

    expect(find.text(AssessmentStrings.ageTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.ageSubtitle), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultAge}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Height assessment screen shows toggle and picker', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: HeightView()));

    expect(find.text(AssessmentStrings.heightTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.heightUnitCm), findsOneWidget);
    expect(find.text(AssessmentStrings.heightUnitFt), findsOneWidget);
    expect(find.text('${AssessmentStrings.defaultHeightCm}'), findsOneWidget);
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Objective assessment screen shows goal options', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: ObjectiveView()));

    expect(find.text(AssessmentStrings.objectiveTitle), findsOneWidget);
    expect(find.text(AssessmentStrings.objectiveReduceBodyFat), findsOneWidget);
    expect(
      find.text(AssessmentStrings.objectiveIncreaseMuscle),
      findsOneWidget,
    );
    expect(find.text(AppStrings.nextButton), findsOneWidget);
  });

  testWidgets('Visual scan page shows interactive compare slider', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: VisualScanView()));

    expect(find.text(InsightsStrings.visualScanTitle), findsOneWidget);
    expect(find.text(InsightsStrings.slideToCompare), findsOneWidget);
  });
}
