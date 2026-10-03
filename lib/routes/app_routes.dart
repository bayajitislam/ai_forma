import 'package:ai_forma/core/dev/ui_test_gallery.dart';
import 'package:ai_forma/core/middleware/auth_middleware.dart';
import 'package:flutter/foundation.dart';
import 'package:ai_forma/features/onboarding_assessment/bindings/assessment_binding.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/dynamic_assessment_view.dart';
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
import 'package:ai_forma/features/check_in/view/pages/camera_capture_view.dart';
import 'package:ai_forma/features/check_in/view/pages/camera_position_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_weight_view.dart';
import 'package:ai_forma/features/check_in/view/pages/scan_review_view.dart';
import 'package:ai_forma/features/check_in/view/pages/step_into_frame_view.dart';
import 'package:ai_forma/features/dashboard/bindings/weight_binding.dart';
import 'package:ai_forma/features/dashboard/view/pages/weekly_progress_view.dart';
import 'package:ai_forma/features/dashboard/view/pages/weight_trends_view.dart';
import 'package:ai_forma/features/insights/bindings/insights_binding.dart';
import 'package:ai_forma/features/insights/view/pages/compare_scans_view.dart';
import 'package:ai_forma/features/insights/view/pages/consistency_view.dart';
import 'package:ai_forma/features/insights/view/pages/fat_loss_view.dart';
import 'package:ai_forma/features/insights/view/pages/muscle_growth_view.dart';
import 'package:ai_forma/features/insights/view/pages/posture_analysis_view.dart';
import 'package:ai_forma/features/insights/view/pages/symmetry_score_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/onboarding_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/privacy_onboarding_view.dart';
import 'package:ai_forma/features/shell/bindings/app_shell_binding.dart';
import 'package:ai_forma/features/shell/view/pages/app_shell_view.dart';
import 'package:ai_forma/features/splash/bindings/splash_binding.dart';
import 'package:ai_forma/features/splash/view/pages/splash_view.dart';
import 'package:ai_forma/features/profile/bindings/profile_binding.dart';
import 'package:ai_forma/features/profile/view/pages/community_chat_view.dart';
import 'package:ai_forma/features/profile/view/pages/edit_personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/help_support_view.dart';
import 'package:ai_forma/features/profile/view/pages/personal_details_view.dart';
import 'package:ai_forma/features/profile/view/pages/physique_targets_view.dart';
import 'package:ai_forma/features/profile/view/pages/profile_view.dart';
import 'package:ai_forma/features/profile/view/pages/report_bug_view.dart';
import 'package:ai_forma/features/profile/view/pages/subscription_view.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage> get pages => [
    GetPage(
      name: RoutesName.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    //Onboarding
    GetPage(name: RoutesName.onboarding, page: () => const OnboardingView()),
    GetPage(
      name: RoutesName.privacyOnboarding,
      page: () => const PrivacyOnboardingView(),
    ),
    //Auth
    GetPage(
      name: RoutesName.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: RoutesName.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RoutesName.verifyEmail,
      page: () => const VerifyEmailView(),
      binding: VerifyEmailBinding(),
    ),
    GetPage(name: RoutesName.signupSuccess, page: () => SignupSuccessView()),

    //ForgotPassword
    GetPage(
      name: RoutesName.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: RoutesName.resetCode,
      page: () => const ResetCodeView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: RoutesName.createNewPassword,
      page: () => const CreateNewPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: RoutesName.resetPasswordSuccess,
      page: () => const ResetPasswordSuccessView(),
    ),

    //Assessment
    GetPage(
      name: RoutesName.gender,
      page: () => const DynamicAssessmentView(),
      binding: AssessmentBinding(),
    ),

    //CheckIn
    GetPage(
      name: RoutesName.checkInIntro,
      page: () => const CheckInIntroView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.cameraPosition,
      page: () => const CameraPositionView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.stepIntoFrame,
      page: () => const StepIntoFrameView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.cameraCapture,
      page: () {
        final angle = Get.arguments is ScanAngle
            ? Get.arguments as ScanAngle
            : ScanAngle.front;
        return CameraCaptureView(angle: angle);
      },
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.scanReview,
      page: () => const ScanReviewView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.checkInWeight,
      page: () => const CheckInWeightView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.analysing,
      page: () => const AnalysingView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: RoutesName.analysisComplete,
      page: () => const AnalysisCompleteView(),
    ),

    //Shell
    GetPage(
      name: RoutesName.appShell,
      page: () => const AppShellView(),
      binding: AppShellBinding(),
      middlewares: [AuthMiddleware()],
    ),

    //Dashboard
    GetPage(
      name: RoutesName.weightTrends,
      page: () => const WeightTrendsView(),
      binding: WeightBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.weeklyProgress,
      page: () => const WeeklyProgressView(),
      binding: WeeklyProgressBinding(),
      middlewares: [AuthMiddleware()],
    ),

    //Insights sub-pages
    GetPage(
      name: RoutesName.muscleGrowth,
      page: () => const MuscleGrowthView(),
      binding: MuscleGrowthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.fatLoss,
      page: () => const FatLossView(),
      binding: FatLossBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.postureAnalysis,
      page: () => const PostureAnalysisView(),
      binding: PostureBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.symmetryScore,
      page: () => const SymmetryScoreView(),
      binding: SymmetryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.consistency,
      page: () => const ConsistencyView(),
      binding: ConsistencyBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.compareScans,
      page: () => const CompareScansView(),
      binding: CompareScansBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Profile & sub-pages
    GetPage(
      name: RoutesName.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.personalDetails,
      page: () => const PersonalDetailsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.editPersonalDetails,
      page: () => const EditPersonalDetailsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.physiqueTargets,
      page: () => const PhysiqueTargetsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.communityChat,
      page: () => const CommunityChatView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.reportBug,
      page: () => const ReportBugView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.subscription,
      page: () => const SubscriptionView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesName.helpSupport,
      page: () => const HelpSupportView(),
      middlewares: [AuthMiddleware()],
    ),

    //Dev UI Gallery — only available in debug builds
    if (kDebugMode)
      GetPage(
        name: RoutesName.uiTestGallery,
        page: () => const UiTestGalleryView(),
      ),
  ];
}
