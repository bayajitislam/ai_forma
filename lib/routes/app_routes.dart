import 'package:ai_forma/features/auth/bindings/signup_binding.dart';
import 'package:ai_forma/features/auth/bindings/verify_email_binding.dart';
import 'package:ai_forma/features/auth/view/pages/login_view.dart';
import 'package:ai_forma/features/auth/view/pages/signup_success_view.dart';
import 'package:ai_forma/features/auth/view/pages/signup_view.dart';
import 'package:ai_forma/features/auth/view/pages/verify_email_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/onboarding_view.dart';
import 'package:ai_forma/features/onboarding/view/pages/privacy_onboarding_view.dart';
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
    GetPage(name: RoutesName.login, page: () => const LoginView()),
    GetPage(
      name: RoutesName.verifyEmail,
      page: () => const VerifyEmailView(),
      binding: VerifyEmailBinding(),
    ),
    GetPage(name: RoutesName.signupSuccess, page: () => SignupSuccessView()),
  ];
}
