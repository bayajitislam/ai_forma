class ApiEndpoint {
  // static const String baseUrl = 'https://aiformapi.dsrt321.online';
  static const String baseUrl = 'http://10.10.26.245:8000';
  

  //auth
  static const String login = '/api/auth/login/';
  static const String register = '/api/auth/register/';
  static const String verifyEmail = '/api/auth/verify-email/';
  static const String resendOtp = '/api/auth/resend-otp/';
  static const String me = '/api/auth/me/';
  static const String tokenRefresh = '/api/auth/token/refresh/';

  //password reset
  static const String forgotPassword = '/api/auth/password/forgot/';
  static const String verifyResetCode = '/api/auth/password/verify-code/';
  static const String resetPassword = '/api/auth/password/reset/';

  //onboarding assessment
  static const String onboardingSchema = '/api/onboarding/schema/';
  static const String onboardingComplete = '/api/onboarding/complete/';

  //scans & check-in
  static const String validateImages = '/api/scans/validate-images/';
  static const String createScan = '/api/scans/';
  static const String weeklyCheckin = '/api/checkins/weekly/';
  static const String latestScan = '/api/scans/latest/';
  static const String muscleGrowthInsight = '/api/insights/muscle-growth/';
  static const String fatLossInsight = '/api/insights/fat-loss/';
  static const String postureInsight = '/api/insights/posture/';
  static const String symmetryInsight = '/api/insights/symmetry/';
  static const String consistencyInsight = '/api/insights/consistency/';

  //bug reports
  static const String bugReports = '/api/bug-reports/';
}
