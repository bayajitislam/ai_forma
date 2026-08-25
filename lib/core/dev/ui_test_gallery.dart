import 'package:ai_forma/features/auth/bindings/forgot_password_binding.dart';
import 'package:ai_forma/features/auth/bindings/login_binding.dart';
import 'package:ai_forma/features/auth/bindings/signup_binding.dart';
import 'package:ai_forma/features/auth/bindings/verify_email_binding.dart';
import 'package:ai_forma/features/auth/view/pages/create_new_password_view.dart';
import 'package:ai_forma/features/auth/view/pages/forgot_password_view.dart';
import 'package:ai_forma/features/auth/view/pages/login_view.dart';
import 'package:ai_forma/features/auth/view/pages/reset_code_view.dart';
import 'package:ai_forma/features/auth/view/pages/reset_password_success_view.dart';
import 'package:ai_forma/features/auth/view/pages/signup_success_view.dart';
import 'package:ai_forma/features/auth/view/pages/signup_view.dart';
import 'package:ai_forma/features/auth/view/pages/verify_email_view.dart';
import 'package:ai_forma/features/check_in/bindings/check_in_binding.dart';
import 'package:ai_forma/features/check_in/view/pages/analysing_view.dart';
import 'package:ai_forma/features/check_in/view/pages/analysis_complete_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/check_in/view/pages/scan_review_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/onboarding_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/privacy_onboarding_view.dart';
import 'package:ai_forma/features/onboarding_assessment/bindings/assessment_binding.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/activity_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/age_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/dynamic_assessment_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/experience_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/gender_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/height_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/medical_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/menstrual_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/nutrition_confidence_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/nutrition_current_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/nutrition_difficulties_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/nutrition_preferences_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/objective_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/sleep_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/supplements_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/weight_view.dart';
import 'package:ai_forma/features/profile/view/pages/edit_personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/help_support_view.dart';
import 'package:ai_forma/features/profile/view/pages/personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/report_bug_view.dart';
import 'package:ai_forma/features/shell/view/pages/app_shell_view.dart';
import 'package:ai_forma/features/splash/view/pages/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiTestGalleryView extends StatelessWidget {
  const UiTestGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Test Gallery'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('1. Core & Splash'),
          _buildTile(context, 'Splash Screen', () => const SplashView()),

          _buildSectionHeader('2. Onboarding'),
          _buildTile(context, 'Onboarding Welcome', () => const OnboardingView()),
          _buildTile(context, 'Privacy Onboarding', () => const PrivacyOnboardingView()),

          _buildSectionHeader('3. Authentication'),
          _buildTile(context, 'Sign Up', () => const SignupView(), binding: SignupBinding()),
          _buildTile(context, 'Verify Email', () => const VerifyEmailView(), binding: VerifyEmailBinding()),
          _buildTile(context, 'Sign Up Success', () => SignupSuccessView()),
          _buildTile(context, 'Login', () => const LoginView(), binding: LoginBinding()),
          _buildTile(context, 'Forgot Password', () => const ForgotPasswordView(), binding: ForgotPasswordBinding()),
          _buildTile(context, 'Reset Code (OTP)', () => const ResetCodeView(), binding: ForgotPasswordBinding()),
          _buildTile(context, 'Create New Password', () => const CreateNewPasswordView(), binding: ForgotPasswordBinding()),
          _buildTile(context, 'Reset Password Success', () => const ResetPasswordSuccessView()),

          _buildSectionHeader('4. Onboarding Assessment'),
          _buildTile(context, 'Dynamic Assessment (API Flow)', () => const DynamicAssessmentView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 1: Gender', () => const GenderView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 2: Age', () => const AgeView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 3: Height', () => const HeightView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 4: Weight', () => const WeightView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 5: Objective', () => const ObjectiveView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 6: Experience', () => const ExperienceView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 7: Sleep', () => const SleepView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 8: Activity', () => const ActivityView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 9: Nutrition Current', () => const NutritionCurrentView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 10: Nutrition Confidence', () => const NutritionConfidenceView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 11: Nutrition Difficulties', () => const NutritionDifficultiesView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 12: Supplements', () => const SupplementsView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 13: Nutrition Preferences', () => const NutritionPreferencesView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 14: Medical', () => const MedicalView(), binding: AssessmentBinding()),
          _buildTile(context, 'Static Step 15: Menstrual', () => const MenstrualView(), binding: AssessmentBinding()),

          _buildSectionHeader('5. Check-In & Scan'),
          _buildTile(context, 'Check-In Intro', () => const CheckInIntroView(), binding: CheckInBinding()),
          _buildTile(context, 'Scan Review', () => const ScanReviewView()),
          _buildTile(context, 'Analysing', () => const AnalysingView()),
          _buildTile(context, 'Analysis Complete', () => const AnalysisCompleteView()),

          _buildSectionHeader('6. Main App & Profile'),
          _buildTile(context, 'App Shell (Bottom Navigation)', () => const AppShellView()),
          _buildTile(context, 'Personal Details', () => const PersonalDetailsView()),
          _buildTile(context, 'Edit Personal Details', () => const EditPersonalDetailsView()),
          _buildTile(context, 'Help & Support', () => const HelpSupportView()),
          _buildTile(context, 'Report Bug', () => const ReportBugView()),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent,
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    Widget Function() pageBuilder, {
    Bindings? binding,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (binding != null) {
            binding.dependencies();
          }
          Get.to(pageBuilder);
        },
      ),
    );
  }
}
