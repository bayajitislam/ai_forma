class ApiEndpoint {
  static const String baseUrl = 'https://aiformapi.dsrt321.online';

  //auth
  static const String login = '/api/auth/login/';
  static const String register = '/api/auth/register/';
  static const String verifyEmail = '/api/auth/verify-email/';
  static const String resendOtp = '/api/auth/resend-otp/';
  static const String me = '/api/auth/me/';

  //password reset
  static const String forgotPassword = '/api/auth/password/forgot/';
  static const String verifyResetCode = '/api/auth/password/verify-code/';
  static const String resetPassword = '/api/auth/password/reset/';

  //onboarding assessment
  static const String onboardingSchema = '/api/onboarding/schema/';
  static const String onboardingComplete = '/api/onboarding/complete/';
}
