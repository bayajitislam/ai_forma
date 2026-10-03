abstract final class CheckInStrings {
  // Home tab & Dashboard
  static const String checkInHeadline = 'Check-In';
  static const String checkInHomeSubtitle =
      'Track your progress with a new body scan.';
  static const String cameraPosition = 'Position your camera';
  static const String result = 'Result';
  static const String analysingComplete = 'Analysing complete';
  static const String analysing = 'Analysing';
  static const String stepIntoFrame = 'Step into the frame';
  static const String weekStreak = 'week streak';
  static const String personalBest = 'Personal Best';
  static const String keepItUp = 'Keep it up!';
  static const String statTotal = 'Total';
  static const String statOnTime = 'On-time';
  static const String statCheckDay = 'Check day';
  static const String checkDayValue = 'Sunday';
  static const String currentWeight = 'Current Weight';
  static const String currentWeightValue = '87.4 kg';
  static const String weightChange = '\u2193 0.6 kg vs last week';
  static const String latestScan = 'Latest Scan';
  static const String latestScanDate = 'May 12, 2026';
  static const String beginNewScan = 'WEEKLY CHECK-IN';
  static const String latestInsight = 'Latest Insight';
  static const String latestInsightBody =
      'Your shoulder definition has improved 8% since your last check-in.';
  static const String viewInsight = 'View Insight';

  // Intro
  static const String introTitle = 'Welcome to AiFORMA Intelligence';
  static const String introSubtitle =
      'Your check-in creates a digital record of your physique that becomes smarter with every scan.';
  static const String introFeature1Title = 'AI Body Analysis';
  static const String introFeature1Body =
      'Understand changes in muscle, body fat and overall physique.';
  static const String introFeature2Title = 'Progress Tracking';
  static const String introFeature2Body =
      'See exactly how your body evolves over time.';
  static const String introFeature3Title = 'Personalised Insights';
  static const String introFeature3Body =
      'Receive intelligent recommendations based on your unique data.';
  static const String beginFirstCheckIn = 'BEGIN YOUR FIRST CHECK-IN';

  // Camera setup
  static const String positionCameraTitle = 'Position your camera';
  static const String positionCameraBody =
      'Place your phone on a stable surface at waist height. Good lighting and a plain background will improve your results.';
  static const String imReady = 'I\u2019M READY';
  static const String stepIntoFrameTitle = 'Step Into Frame';
  static const String stepIntoFrameBody =
      'Move back until your entire body is visible from head to toe.';
  static const String continueButton = 'CONTINUE';

  // Camera capture
  static const String angleFront = 'Front';
  static const String angleSide = 'Side';
  static const String angleBack = 'Back';
  static const String frontInstruction =
      'Stand tall. Keep your feet shoulder-width apart and your arms slightly away from your body. This gives AiFORMA the clearest analysis.';
  static const String sideInstruction =
      'Turn 90\u00b0 to your left. Stand naturally and look straight ahead.';
  static const String backInstruction =
      'Face away from the camera. Stand tall with your arms relaxed by your sides.';
  static const String retake = 'Retake';
  static const String guide = 'Guide';
  static const String tips = 'Tips';
  static const String startingCamera = 'Starting camera...';
  static const String gallery = 'Gallery';
  static const String switchCamera = 'Switch';
  static const String usePhoto = 'Use Photo';
  static const String retakePhoto = 'Retake';
  static const String noCameraFound = 'No camera found on this device.';
  static const String failedToInitCamera = 'Failed to initialize camera: ';
  static const String errorCapturingPhoto = 'Error capturing photo: ';

  // Photo Tips & Guide modal strings
  static const String photoTipsTitle = 'Photo Tips';
  static const List<String> photoTipsBulletPoints = [
    'Use good, even lighting.',
    'Stand against a plain background.',
    'Keep your whole body inside the frame.',
    'Stand naturally and look straight ahead.',
    'Wear fitted clothing where possible.',
    'Avoid hats, bulky clothing and loose accessories.',
  ];

  static const String sidePhotoGuideTitle = 'Side Photo Guide';
  static const List<String> sidePhotoGuidePoints = [
    'Turn 90 degrees to face your left or right side.',
    'Stand straight with your posture natural.',
    'Keep your arms slightly away from your sides so your body outline is clear.',
    'Look straight ahead in the direction you are facing.',
    'Stay still until the photo is taken.',
  ];

  static const String backPhotoGuideTitle = 'Back Photo Guide';
  static const List<String> backPhotoGuidePoints = [
    'Turn around so your back faces the camera.',
    'Stand tall with your feet shoulder-width apart.',
    'Let your arms hang slightly away from your body.',
    'Keep your head level looking straight ahead.',
    'Stay still until the photo is taken.',
  ];

  static const String frontPhotoGuideTitle = 'Front Photo Guide';
  static const List<String> frontPhotoGuidePoints = [
    'Stand tall facing the camera.',
    'Keep your feet shoulder-width apart.',
    'Let your arms hang slightly away from your body.',
    'Keep your head level and look straight ahead.',
    'Stay still until the photo is taken.',
  ];

  // Review & Validation
  static const String reviewYourScan = 'Review Your Scan';
  static const String checkingPhotoQuality = 'Checking Photo Quality...';
  static const String checkingPhotoQualitySubtitle =
      'Please wait while AI verifies your scan images.';
  static const String scanReadyTitle = 'Your scan is ready.';
  static const String scanReadySubtitle =
      'Review your photos before AiFORMA begins analysing your physique.';
  static const String allPhotosValidated = 'All photos validated successfully!';
  static const String allPhotosValidatedSubtitle =
      'All photos validated successfully! Tap Looks Good to proceed.';
  static const String scanQualityIssues = 'Scan Quality Issues';
  static const String scanQualityIssuesSubtitle =
      'Some photos failed quality checks. Please retake.';
  static const String connectionIssue = 'Connection Issue';
  static const String connectionIssueSubtitle =
      'Unable to validate photos due to network error. Tap Retry to try again.';
  static const String validatingWithAi = 'Validating scan images with AI...';
  static const String validationFailedRetake =
      'Validation failed. Please retake failed photos.';
  static const String retryValidation = 'RETRY VALIDATION';
  static const String checkingImageQuality = 'Checking image quality...';
  static const String looksGood = 'LOOK\u2019S GOOD';
  static const String retakePhotos = 'RETAKE PHOTOS';
  static const String captureAllPhotosWarning =
      'Please capture front, side, and back photos before validating.';
  static const String submitAllPhotosWarning =
      'Please capture front, side, and back photos before submitting.';

  // Schedule Feedback & Day Picker
  static const String chooseCheckInDayTitle = 'Choose your check-in day';
  static const String chooseCheckInDaySubtitle =
      'Select the day you prefer to complete your weekly body scan.';
  static const String save = 'SAVE';
  static const String gotIt = 'GOT IT';
  static const String scheduleChangeRestricted = 'Schedule Change Restricted';
  static const String scheduleChangeRestrictedBody =
      'You can only change your weekly check-in day once every 7 days.';
  static const String failedToUpdateCheckInDay =
      'Failed to update check-in day';
  static const String scanScheduleChangeSet = 'Scan Schedule Change Set';
  static const String scanScheduleUpdated = 'Scan Schedule Updated';
  static const String weeklyScanDayUpdated =
      'Weekly scan day successfully updated.';
  static const String nextWeeklyScanSchedule = 'Next Weekly Scan Schedule';
  static const String nextScanDayLabel = 'Next Check-In Day';
  static const String transitionScheduleActive = 'Transition Schedule Active';
  static const String pendingChangePrefix = 'Pending change to ';
  static const String pendingChangeSuffix = ' (takes effect next cycle)';
  static const String nextWeeklyAvailablePrefix =
      'Next Weekly check-in available on ';

  static String nextScanAvailableMessage(String day) =>
      'Your check-in for this week is completed! Your next scan will be available on $day.';

  static String transitionScheduleBody(String day) =>
      'Your new scan schedule is set. Your next weekly scan is scheduled for $day. Your Daily Brief will begin 6 days before your scan.';

  // Weight
  static const String weightTitle = 'Current Weight';
  static const String weightSubtitle =
      'Enter your current weight so AiFORMA can accurately track your progress over time.';

  // Measurements
  static const String measurementsTitle = 'Body Measurements';
  static const String measurementsSubtitle =
      'Enter your current measurements for accurate tracking.';
  static const String waist = 'Waist';
  static const String chest = 'Chest';
  static const String arms = 'Arms';
  static const String hips = 'Hips';
  static const String skip = 'SKIP';
  static const String next = 'NEXT';
  static const String unitCm = 'cm';

  // Analysing
  static const String analysingTitle = 'AiFORMA is analysing your physique';
  static const String analysingSubtitle =
      'This usually takes less than 30 seconds.';
  static const String stepMapping = 'Mapping body composition';
  static const String stepMuscle = 'Identifying muscle development';
  static const String stepSymmetry = 'Assessing symmetry';
  static const String stepInsights = 'Generating personalized insights';
  static const String stepProfile = 'Building your progress profile';

  // Analysis Error Dialog
  static const String checkInWindowClosed = 'Check-In Window Closed';
  static const String analysisFailed = 'Analysis Failed';
  static const String analysisFailedDefaultMessage =
      'Failed to process body scan analysis. Please try again.';
  static const String returnToDashboard = 'Return to Dashboard';
  static const String backToReview = 'Back to Review';
  static const String tryAgain = 'Try Again';

  // Complete
  static const String completeTitle = 'Analysis Complete';
  static const String analysisCompleteBadge = 'ANALYSIS COMPLETE';
  static const String completeSubtitleFirstScan =
      'Your first physique analysis is ready. Discover what AiFORMA has detected.';
  static const String completeSubtitleRepeatScan =
      'Your latest analysis is ready. See what\u2019s changed since your previous scan.';
  static const String completeSubtitle = completeSubtitleRepeatScan;
  static const String checkInLabel = 'Check-In';
  static const String currentStreakLabel = 'Current Streak';
  static const String momentumLabel = 'Momentum';
  static const String checkInNumber = '#12';
  static const String streakNumber = '12';
  static const String streakUnit = ' weeks';
  static const String momentumValue = '82';
  static const String momentumSuffix = ' /100';
  static const String viewResults = 'VIEW MY RESULTS';

  // Measurement points on body silhouette
  static const String pointMuscleDevelopment = 'MUSCLE\nDEVELOPMENT';
  static const String pointBodyComposition = 'BODY\nCOMPOSITION';
  static const String pointPostureBalance = 'POSTURE\nBALANCE';
  static const String pointSymmetryAnalysis = 'SYMMETRY\nANALYSIS';
  static const String pointFatDistribution = 'FAT\nDISTRIBUTION';
  static const String pointPhysiqueScore = 'PHYSIQUE\nSCORE';

  // Header & Logout Confirmation
  static const String logoutConfirmTitle = 'Log Out?';
  static const String logoutConfirmMessage =
      'Are you sure you want to log out? You need to complete your initial check-in scan to prepare your personalized dashboard.';
  static const String cancel = 'Cancel';
  static const String logout = 'Log Out';
}
