abstract final class AssessmentStrings {
  static const int totalSteps = 15;

  static const String nutritionCategory = 'NUTRITION';

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

  static const String nutritionCurrentTitle =
      'How would you describe your current nutrition?';
  static const String nutritionCurrentSubtitle =
      'Select the option that best describes you.';
  static const String nutritionBalancedDiet =
      'I consistently eat a balanced, healthy diet.';
  static const String nutritionBalancedDietSubtitle =
      'I follow a nutritious eating pattern most of the time.';
  static const String nutritionOccasionalSetbacks =
      'I eat well most of the time but have occasional setbacks.';
  static const String nutritionOccasionalSetbacksSubtitle =
      'I make healthy choices regularly but slip up sometimes.';
  static const String nutritionStruggleConsistency =
      'I know what I should eat but struggle to stay consistent.';
  static const String nutritionStruggleConsistencySubtitle =
      'I have a good understanding but find it hard to stick to.';
  static const String nutritionTakeawayMeals =
      'I often eat convenience or takeaway meals.';
  static const String nutritionTakeawayMealsSubtitle =
      'I rely on convenient food options more often than I\u2019d like.';
  static const String nutritionNotPriority =
      'I don\u2019t currently pay much attention to my nutrition.';
  static const String nutritionNotPrioritySubtitle =
      'My eating habits aren\u2019t a priority right now.';

  static const String nutritionConfidenceTitle =
      'How confident are you in your current approach?';
  static const String nutritionConfidenceSubtitle =
      'This helps AiFORMA understand how much guidance you may need.';
  static const String nutritionVeryConfident = 'Very confident';
  static const String nutritionVeryConfidentSubtitle =
      'I understand what I need to do and follow a clear strategy.';
  static const String nutritionSomewhatConfident = 'Somewhat confident';
  static const String nutritionSomewhatConfidentSubtitle =
      'I have a general plan but still need some guidance.';
  static const String nutritionUnsure = 'Unsure';
  static const String nutritionUnsureSubtitle =
      'I\u2019m not certain whether my current approach is working.';
  static const String nutritionNeedDirection = 'I need clear direction';
  static const String nutritionNeedDirectionSubtitle =
      'I don\u2019t currently have a reliable strategy.';
  static const String nutritionConfidenceInfoBanner =
      'Your answers help AiFORMA personalise the guidance and recommendations you receive.';

  static const String nutritionDifficultiesTitle =
      'What makes nutrition difficult for you?';
  static const String nutritionDifficultiesSubtitle =
      'Select up to 2 options that apply most to you.';
  static const String nutritionDifficultiesSelected = ' of 2 selected';
  static const String nutritionPortionControl = 'Portion control';
  static const String nutritionCravings = 'Cravings';
  static const String nutritionLateNightEating = 'Late-night eating';
  static const String nutritionEmotionalEating = 'Emotional eating';
  static const String nutritionFastFood = 'Takeaway / fast food';
  static const String nutritionAlcohol = 'Alcohol';
  static const String nutritionNotEnoughProtein = 'Not enough protein';
  static const String nutritionMealPrep = 'Meal preparation';
  static const String nutritionBusySchedule = 'Busy schedule';
  static const String nutritionDontKnowWhatToEat = 'I don\u2019t know what to eat';
  static const String nutritionStayingConsistent = 'Staying consistent';
  static const String nutritionNoneOfThese = 'None of these';
  static const String nutritionDifficultiesInfoBanner =
      'Your answers help AIFORMA provide more personalized insights and recommendations.';

  static const String nutritionPreferencesTitle =
      'Tell AiFORMA a little more about you';
  static const String nutritionPreferencesSubtitle =
      'Select all that apply. This step is optional.';
  static const String nutritionDietaryPreferencesSection = 'DIETARY PREFERENCES';
  static const String nutritionLifestyleFactorsSection = 'LIFESTYLE FACTORS';
  static const String nutritionVegetarian = 'Vegetarian';
  static const String nutritionVegan = 'Vegan';
  static const String nutritionPescatarian = 'Pescatarian';
  static const String nutritionHighProtein = 'High-protein diet';
  static const String nutritionLowCarb = 'Low-carb diet';
  static const String nutritionGlutenFree = 'Gluten-free';
  static const String nutritionDairyFree = 'Dairy-free';
  static const String nutritionIntermittentFasting = 'Intermittent fasting';
  static const String nutritionShiftWorker = 'Shift worker';
  static const String nutritionFrequentTraveller = 'Frequent traveller';
  static const String nutritionParentYoungChildren =
      'Parent with young children';
  static const String nutritionOfficeWorker = 'Office worker';
  static const String nutritionPhysicallyActiveJob = 'Physically active job';
  static const String nutritionNoneOfTheAbove = 'None of the above';
  static const String nutritionPreferencesInfoBanner =
      'Why we ask \u2014 This information helps us tailor nutrition and lifestyle insights that fit your life and support your goals.';

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
  static const String supplementFatBurner = 'Fat Burner';
  static const String supplementPreWorkout = 'Pre-Workout';
  static const String supplementVitamins = 'Vitamins / Minerals';
  static const String supplementOmega3 = 'Omega 3';
  static const String supplementOther = 'Other';
}
