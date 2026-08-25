class ApiEndpoint {
  static const String baseUrl = 'http://10.10.26.245:8000/';
  // static const String baseUrl = 'https://aiformapi.dsrt321.online';

  //auth
  static const String login = '/api/auth/login/';
  static const String register = '/api/auth/register/';
  static const String verifyEmail = '/api/auth/verify-email/';
  static const String resendOtp = '/api/auth/resend-otp/';
  static const String me = '/api/auth/me/';
  static const String profile = '/api/auth/profile/';
  static const String tokenRefresh = '/api/auth/token/refresh/';

  //account deletion
  static const String deleteAccount = '/api/auth/delete-account/';

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

  //timeline
  static const String timelineOverview = '/api/timeline/overview/';
  static const String timelineTrends = '/api/timeline/trends/';
  static const String timelineHistory = '/api/timeline/history/';
  static String timelineScanDetail(String id) => '/api/timeline/scans/$id/';

  //scans & compare
  static const String scansList = '/api/scans/';
  static const String compareScans = '/api/scans/compare/';

  //home
  static const String homeData = '/api/home/';

  //checkins
  static const String checkinStatus = '/api/checkins/status/';
  static const String dailyCheckIn = '/api/checkins/daily/';
  static const String weeklyCheckIn = '/api/checkins/weekly/';

  //weight trends & progress
  static const String weightTrends = '/api/checkins/weight-trends/';
  static const String weightProgress = '/api/checkins/weight-progress/';
  static const String weightHistory = '/api/checkins/weight-history/';
}
