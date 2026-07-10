abstract final class AssessmentStrings {
  static const int totalSteps = 11;

  static const String genderTitle = 'Tell us about yourself?';
  static const String genderSubtitle =
      'This helps AiFORMA personalise your Body Intelligence profile.';

  static const String genderMale = 'Male';
  static const String genderFemale = 'Female';

  static const String ageTitle = 'How old are you?';
  static const String ageSubtitle =
      'Age helps improve the accuracy of your analysis.';

  static const int minAge = 16;
  static const int maxAge = 99;
  static const int defaultAge = 28;

  static const String heightTitle = 'What\u2019s your height?';
  static const String heightSubtitle =
      'Used to calculate your personalised body metrics.';
  static const String heightUnitCm = 'cm';
  static const String heightUnitFt = 'ft';

  static const int minHeightCm = 100;
  static const int maxHeightCm = 250;
  static const int defaultHeightCm = 171;

  static const int minHeightInches = 48;
  static const int maxHeightInches = 95;
  static const int defaultHeightInches = 67;

  static const String weightTitle = 'What\u2019s your current weight?';
  static const String weightSubtitle =
      'This becomes your starting benchmark.';
  static const String weightUnitKg = 'KG';
  static const String weightUnitLb = 'LB';

  static const int minWeightKg = 30;
  static const int maxWeightKg = 200;
  static const int defaultWeightKg = 50;

  static const int minWeightLb = 66;
  static const int maxWeightLb = 440;
  static const int defaultWeightLb = 110;

  static const String skip = 'Skip';

  static const String objectiveTitle = 'What\u2019s your main objective?';
  static const String objectiveSubtitle =
      'AiFORMA will prioritise recommendations based on your goal.';
  static const String objectiveReduceBodyFat = 'Reduce Body Fat';
  static const String objectiveIncreaseMuscle = 'Increase Muscle Mass';
  static const String objectiveImproveComposition = 'Improve Body Composition';
  static const String objectiveGeneralHealth = 'General Health';
  static const String objectiveSomethingElse = 'Something Else';

  static const String experienceTitle =
      'How experienced are you with resistance training?';
  static const String experienceSubtitle =
      'This helps us recommend the right level of training.';
  static const String experienceBeginner = 'Beginner';
  static const String experienceBeginnerSubtitle = 'New to strength training';
  static const String experienceIntermediate = 'Intermediate';
  static const String experienceIntermediateSubtitle =
      'Training consistently for 1\u20133 years';
  static const String experienceAdvanced = 'Advanced';
  static const String experienceAdvancedSubtitle =
      '3+ years of structured training';

  static const String sleepTitle = 'How well do you usually sleep?';
  static const String sleepSubtitle =
      'Recovery is a key part of accurate performance insights.';
  static const String sleepPoor = 'Poor';
  static const String sleepPoorSubtitle = 'Usually under 6 hours';
  static const String sleepAverage = 'Average';
  static const String sleepAverageSubtitle = 'Around 7 hours';
  static const String sleepGood = 'Good';
  static const String sleepGoodSubtitle = '7\u20138 hours consistently';
  static const String sleepExcellent = 'Excellent';
  static const String sleepExcellentSubtitle =
      '8+ hours, high-quality sleep';

  static const String activityTitle = 'Outside the gym, how active are you?';
  static const String activitySubtitle =
      'Daily movement influences your calorie and recovery estimates.';
  static const String activitySedentary = 'Sedentary';
  static const String activitySedentarySubtitle = 'Little or no exercise';
  static const String activityLightlyActive = 'Lightly Active';
  static const String activityLightlyActiveSubtitle =
      'Light exercise 1\u20133 days/week';
  static const String activityModeratelyActive = 'Moderately Active';
  static const String activityModeratelyActiveSubtitle =
      'Moderate exercise 3\u20135 days/week';
  static const String activityVeryActive = 'Very Active';
  static const String activityVeryActiveSubtitle =
      'Hard exercise 6\u20137 days/week';

  static const String medicalTitle = 'Anything we should know before we begin?';
  static const String medicalSubtitle =
      'This helps AiFORMA make safer recommendations.';
  static const String medicalNo = 'No';
  static const String medicalCurrentInjury = 'Current Injury';
  static const String medicalCondition = 'Medical Condition';
  static const String medicalPreferNotToAnswer = 'Prefer not to answer';

  static const String menstrualTitle = 'Where are you in your menstrual cycle?';
  static const String menstrualSubtitle =
      'This helps AiFORMA personalise recovery, performance and nutrition insights.';
  static const String menstrualPhase = 'Menstrual';
  static const String menstrualFollicular = 'Follicular';
  static const String menstrualOvulation = 'Ovulation';
  static const String menstrualLuteal = 'Luteal';
  static const String menstrualNotSure = 'I\u2019m not sure';
  static const String menstrualPreferNotToSay = 'Prefer not to say';

  static const String supplementsTitle =
      'Which supplements do you currently take?';
  static const String supplementsSubtitle = 'Select all that apply.';
  static const String supplementProtein = 'Protein Powder';
  static const String supplementCreatine = 'Creatine';
  static const String supplementPreWorkout = 'Pre-Workout';
  static const String supplementVitamins = 'Vitamins / Minerals';
  static const String supplementOmega3 = 'Omega 3';
  static const String supplementOther = 'Other';
}
