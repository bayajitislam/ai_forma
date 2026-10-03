abstract final class DashboardStrings {
  // Scores & Metrics
  static const String appTitle = 'AiFORMA';
  static const String momentumScore = 'Momentum Score';
  static const String bodyIntelligenceScore = 'Body Intelligence Score';
  static const String todaysPriority = 'Today’s Priority';
  static const String todaysPriorityCaps = "TODAY'S PRIORITY";
  static const String currentWeight = 'Current Weight';
  static const String previousWeightCaps = 'PREVIOUS WEIGHT';
  static const String currentWeightCaps = 'CURRENT WEIGHT';
  static const String weeklyChange = 'Weekly Change';
  static const String latestScan = 'Latest Scan';
  static const String latestAnalysis = 'Latest Analysis';
  static const String aiInsight = 'AI INSIGHT';
  static const String viewAnalysis = 'View Analysis';
  static const String imageGenerate =
      'Images are generated from your latest body scan';
  static const String weeklyScanCaps = 'WEEKLY SCAN';
  static const String scanCompleteCaps = 'SCAN COMPLETE';
  static const String scanDay = 'Scan day';
  static const String updateWeight = 'UPDATE WEIGHT';
  static const String saveWeight = 'Save Weight';
  static const String editWeightEntry = 'Edit Weight Entry';
  static const String updateWeightTitle = 'Update Weight';
  static const String saveResponse = 'Save response';
  static const String viewAll = 'View all';
  static const String weightHistory = 'Weight History';
  static const String noDataForPeriod = 'No data for this period.';
  static const String subscribe = 'Subscribe';
  static const String kgUnit = 'kg';
  static const String success = 'Success';
  static const String error = 'Error';
  static const String defaultHello = 'Hello';

  // Controller & Network Feedback
  static const String responseSavedSuccess = 'Response saved successfully';
  static const String weightRecordedSuccess = 'Weight recorded successfully';
  static const String scanDayWeightSuccess =
      'Scan day weight recorded successfully.';
  static const String failedToLoadHomeData = 'Failed to load Home data.';
  static const String failedToSubmitAnswer = 'Failed to submit answer.';
  static const String failedToRecordWeight = 'Failed to record weight.';

  // Range Change Headers
  static const String weeklyChangeCaps = 'WEEKLY CHANGE';
  static const String monthlyChangeCaps = 'MONTHLY CHANGE';
  static const String threeMonthChangeCaps = '3-MONTH CHANGE';
  static const String sixMonthChangeCaps = '6-MONTH CHANGE';
  static const String yearlyChangeCaps = 'YEARLY CHANGE';

  // Views Titles & Descriptions
  static const String weeklyProgressTitle = 'Weekly Progress';
  static const String weeklyProgressSubtitle =
      "See how your weight has changed this week and how you're tracking against your goal.";
  static const String weightTrendsTitle = 'Weight Trends';
  static const String weightTrendsSubtitle =
      'Track your weight over time and monitor your progress.';

  // Target Status Labels
  static const String onTarget = 'On target';
  static const String fasterThanTarget = 'Faster than target';
  static const String slowerThanTarget = 'Slower than target';
  static const String maintaining = 'Maintaining';
  static const String insufficientData = 'Insufficient data';

  // Dialogs
  static const String premiumTitle = 'AiFORMA Premium';
  static const String premiumMessage =
      'Weekly body scans and AI physique analysis are available exclusively for Premium members. Upgrade now to track your transformation.';
  static const String buyPremium = 'Buy Premium';
  static const String cancel = 'Cancel';

  static const String logWeightBeforeScanTitle = 'Log Weight Before Scan';
  static const String logWeightBeforeScanMessage =
      'Logging your weight before scanning helps AiFORMA calculate more accurate body composition changes. Would you like to log your weight now, or skip to scan?';
  static const String logWeightShortMessage =
      'Track your weight for more accurate scan analysis, or skip to proceed.';
  static const String logWeight = 'Log Weight';
  static const String skip = 'Skip';

  // Analysis & Photos
  static const String viewYourAnalysis = 'View Your Analysis';
  static const String completedForTodayTapToChange =
      'Completed for Today • Tap to change';
  static const String photosHidden = 'Photos Hidden';
  static const String photosHiddenSubtitle =
      'Tap the toggle above to display your latest scan photos.';

  // Helper formats
  static String daysUntilScan(int days) => days == 1
      ? '1 day until your scan'
      : (days == 0 ? 'Scan day' : '$days days until your scan');

  static String thisWeekChange(int change) =>
      change > 0 ? '+$change this week' : '$change this week';

  static String greetingWithFirstName(String firstName) => 'Hello, $firstName';
}

