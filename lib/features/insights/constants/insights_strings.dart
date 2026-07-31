abstract final class InsightsStrings {
  static const String categoryStrengths = 'Strengths';
  static const String categoryFocusAreas = 'Focus Areas';
  static const String categoryNextSteps = 'Next Steps';

  static const String keyInsights = 'Key Insights';

  static const String muscleGrowth = 'Muscle Growth';
  static const String muscleGrowthSubtitle = 'Good progress';
  static const String muscleGrowthStatus = 'Good/Improving';

  static const String fatReduction = 'Fat Reduction';
  static const String fatReductionSubtitle = 'On track';
  static const String fatReductionStatus = 'On track';

  static const String posture = 'Posture';
  static const String postureSubtitle = 'Needs attention';
  static const String postureStatus = 'Needs attention';

  static const String symmetryScore = 'Symmetry Score';
  static const String symmetrySubtitle = 'Excellent';
  static const String symmetryStatus = 'Excellent';

  static const String consistency = 'Consistency';
  static const String consistencySubtitle = 'Excellent';
  static const String consistencyStatus = 'Excellent';

  static const String compareScans = 'COMPARE SCANS';
  static const String compareScansTitle = 'Compare Scans';
  static const String slideCompare = 'Slide Compare';
  static const String compareScansSubtitle =
      'Choose two body scans to compare.';
  static const String generateComparison = 'GENERATE COMPARISON';
  static const String latestScanLabel = 'Latest Scan';
  static const String twoWeeksAgo = '2 weeks ago';
  static const String oneMonthAgo = '1 month ago';
  static const String scanDateMay18 = 'May 18, 2025';
  static const String scanDateMay4 = 'May 4, 2025';
  static const String scanDateApr27 = 'Apr 27, 2025';
  static const String scanShortMay18 = 'May 18';
  static const String scanShortMay4 = 'May 4';
  static const String scanShortApr27 = 'Apr 27';
  static const String comparisonThen = 'Then';
  static const String comparisonNow = 'Now';
  static const String aiComparisonSummary = 'AI Comparison Summary';
  static const String visualScanTitle = 'Visual Scan';
  static const String slideToCompare = 'Slide to compare';
  static const String comparisonBodyFat = 'Body Fat';
  static const String comparisonMuscleMass = 'Muscle Mass';
  static const String comparisonWeight = 'Weight';
  static const String comparisonBodyFatChange = '-1.2%';
  static const String comparisonMuscleMassChange = '+1.2 kg';
  static const String comparisonWeightChange = '-0.6 kg';

  static String comparisonTitle(String older, String newer) =>
      '$older vs $newer';

  static const String strengthsTitle = 'Your Strengths';
  static const String strengthsSubtitle =
      'Your top-performing health and physique markers.';
  static const String shoulderDevelopment = 'Shoulder Development';
  static const String shoulderDevelopmentSubtitle = 'Great development';
  static const String trainingConsistency = 'Training Consistency';
  static const String trainingConsistencySubtitle = 'Excellent discipline';
  static const String upperBodyDevelopment = 'Upper Body Development';
  static const String upperBodyDevelopmentSubtitle = 'Well developed';
  static const String recoveryHabits = 'Recovery Habits';
  static const String recoveryHabitsSubtitle = 'Good recovery habits';

  static const String focusAreasTitle = 'Highest Impact Opportunities';
  static const String focusAreasSubtitle =
      'AiFORMA has identified these as the highest-impact improvements for your physique.';
  static const String lowerAbs = 'Lower Abs';
  static const String lowerAbsSubtitle = 'Lower Abdominal Definition';
  static const String gluteDevelopment = 'Glute Development';
  static const String gluteDevelopmentSubtitle = 'Glute Development';
  static const String calves = 'Calves';
  static const String calvesSubtitle = 'Calf Development';
  static const String postureFocus = 'Posture';
  static const String postureFocusSubtitle = 'Upper Body Posture';

  static const String nextStepsTitle = 'AiFORMA Priorities';
  static const String nextStepsSubtitle =
      'Your highest-impact actions for the coming week.';
  static const String nutrition = 'Nutrition';
  static const String nutritionSubtitle = 'Increase protein by 20g/day';
  static const String training = 'Training';
  static const String trainingSubtitle =
      'Prioritize two additional lower-body sessions.';
  static const String cardio = 'Cardio';
  static const String cardioSubtitle =
      'Complete 2–3 low-intensity cardio sessions.';
  static const String recovery = 'Recovery';
  static const String recoverySubtitle =
      'Aim for more consistent sleep timing.';

  static const String progressingWell = 'Progressing Well';
  static const String needsAttention = 'Needs Attention';
  static const String good = 'Good';
  static const String excellent = 'Excellent';
  static const String outOfHundred = '/100';

  static const String aiFormaAnalysis = 'AiFORMA Analysis';
  static const String whatAiFormaDetected = 'What AiFORMA detected';
  static const String whyYoureSeeingThis = 'Why you\'re seeing this';
  static const String recommendedNextSteps = 'Recommended next steps';
  static const String thisWeeksPriorities = 'This week\'s priorities';

  static const List<String> trendDates = [
    'Apr 27',
    'May 11',
    'May 25',
    'Jun 8',
    'Jun 22',
  ];

  // Muscle Growth
  static const String muscleGrowthScoreLabel = 'Muscle Growth Score';
  static const String muscleGrowthSummary =
      'You\'ve gained 1.8 kg of lean muscle over the last 8 weeks.';
  static const String muscleMass = 'Muscle Mass';
  static const String muscleMassPercent = 'Muscle Mass %';
  static const String muscleGrowthDetected =
      'Significant hypertrophy in your deltoids and upper back over the last 4 weeks, contributing to a 1.8 kg overall increase in lean mass.';
  static const String muscleGrowthWhy =
      'Your consistency with the new progressive overload program and hitting your daily protein target of 180g has provided the necessary stimulus and building blocks for growth.';
  static const String muscleGrowthNextSteps =
      'Maintain your current caloric surplus and protein intake. We need to ensure your recovery keeps pace with this increased training volume.';
  static const String muscleGrowthPriority1 =
      'Increase sleep duration by 30 mins to support recovery.';
  static const String muscleGrowthPriority2 =
      'Add one dedicated mobility session for your shoulders.';
  static const String muscleGrowthPriority3 =
      'Maintain current weight on compound lifts, focus on form.';

  // Fat Loss
  static const String fatLoss = 'Fat Loss';
  static const String fatLossScoreLabel = 'Fat Loss Score';
  static const String fatLossSummary =
      'You\'ve reduced 2.4% body fat in the last 8 weeks.';
  static const String bodyFatPercent = 'Body Fat %';
  static const String fatMass = 'Fat Mass';
  static const String fatLossDetected =
      'Steady reduction in overall body fat percentage and visible leaning out, particularly around the midsection and lower back.';
  static const String fatLossWhy =
      'Your consistent caloric deficit combined with 2-3 weekly LISS cardio sessions has created the optimal environment for fat oxidation without sacrificing muscle mass.';
  static const String fatLossNextSteps =
      'Consider implementing one high-carb refeed day this week to support metabolic rate and training performance.';
  static const String fatLossPriority1 =
      'Implement one high-carb refeed day this Saturday.';
  static const String fatLossPriority2 =
      'Keep LISS cardio at 2 sessions per week, do not increase yet.';
  static const String fatLossPriority3 =
      'Ensure daily water intake remains above 3 liters.';

  // Posture
  static const String postureAnalysis = 'Posture Analysis';
  static const String postureScoreLabel = 'Posture Score';
  static const String postureSummary =
      'Slight improvements detected in upper body alignment.';
  static const String postureBefore = 'May 4 - Before';
  static const String postureAfter = 'Jun 22 - After';
  static const String headPosition = 'Head Position';
  static const String shoulderPosition = 'Shoulder Position';
  static const String spinalPosition = 'Spinal Position';
  static const String pelvicTilt = 'Pelvic Tilt';
  static const String headPositionStatus = 'Good';
  static const String shoulderPositionStatus = 'Slight Forward';
  static const String spinalPositionStatus = 'Improving';
  static const String pelvicTiltStatus = 'Neutral';
  static const String postureDetected =
      'We are detecting a slight rounding of the shoulders (kyphosis) and a minor anterior pelvic tilt when viewed from the side profile.';
  static const String postureWhy =
      'This is commonly associated with prolonged sitting and tight hip flexors, which pull the pelvis forward and cause the upper back to compensate.';
  static const String postureNextSteps =
      'Incorporate daily mobility work targeting the hip flexors and thoracic spine to restore neutral alignment.';
  static const String posturePriority1 =
      'Add 3 sets of face-pulls to your upper body days.';
  static const String posturePriority2 =
      'Perform a 5-minute hip flexor stretching routine daily.';
  static const String posturePriority3 =
      'Set a reminder to stand and reset posture every 60 minutes.';

  // Symmetry
  static const String symmetryScoreLabel = 'Symmetry Score';
  static const String symmetrySummary = 'Minor lower-body asymmetry detected.';
  static const String symmetryLeft = 'L';
  static const String symmetryRight = 'R';
  static const String symmetryExcellent = 'Excellent';
  static const String symmetryGood = 'Good';
  static const String symmetryNeedsAttention = 'Needs Attention';
  static const String symmetryDetected =
      'Your upper body shows excellent left-to-right symmetry (80%), but we are detecting a slight imbalance in your lower body (76%), specifically favoring your right leg.';
  static const String symmetryWhy =
      'This is common if you have a dominant leg you subconsciously rely on during bilateral movements like squats and deadlifts.';
  static const String symmetryNextSteps =
      'We need to incorporate more unilateral (single-leg) exercises to force your weaker side to work independently and catch up.';
  static const String symmetryPriority1 =
      'Add Bulgarian split squats (3 sets of 10) to leg days.';
  static const String symmetryPriority2 =
      'Always start unilateral exercises with your weaker (left) leg.';
  static const String symmetryPriority3 =
      'Focus on mind-muscle connection during lower body lifts.';

  // Consistency
  static const String consistencyScoreLabel = 'Consistency Score';
  static const String consistencySummary =
      'You\'ve completed 12 body scans in the last 16 weeks.';
  static const String currentStreak = 'Current Streak';
  static const String onTimeRate = 'On-Time Rate';
  static const String momentumGained = 'Momentum Gained';
  static const String consistencyDetected =
      'You have maintained an exceptional scan cadence, completing 12 of 16 scheduled check-ins with a 92% on-time rate.';
  static const String consistencyWhy =
      'Regular scanning provides AiFORMA with the data needed to track micro-changes in your physique that weekly weigh-ins alone cannot capture.';
  static const String consistencyNextSteps =
      'Keep your current Tuesday/Friday scan schedule. Consistency at this level compounds into significantly more accurate AI recommendations over time.';
  static const String consistencyPriority1 =
      'Complete your next scheduled scan on Tuesday.';
  static const String consistencyPriority2 =
      'Review your scan history to identify long-term trends.';
  static const String consistencyPriority3 =
      'Set a calendar reminder 1 hour before each scan window.';
}
