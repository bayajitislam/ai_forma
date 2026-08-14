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
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/onboarding_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/privacy_onboarding_view.dart';
import 'package:ai_forma/features/shell/view/pages/app_shell_view.dart';
import 'package:ai_forma/features/splash/view/pages/splash_view.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage> get pages => [
    GetPage(name: RoutesName.splash, page: () => const SplashView()),

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
    ),

    //Shell
    GetPage(name: RoutesName.appShell, page: () => const AppShellView()),
  ];
}
