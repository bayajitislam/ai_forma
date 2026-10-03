import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/onboarding_assessment/models/onboarding_schema_model.dart';
import 'package:ai_forma/features/onboarding_assessment/repositories/assessment_repository.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

class AssessmentController extends GetxController {
  final AssessmentRepository assessmentRepository;
  AssessmentController({required this.assessmentRepository});

  final RxBool isLoadingSchema = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<OnboardingStepModel> allSteps = <OnboardingStepModel>[].obs;
  final RxInt currentStepIndex = 0.obs;

  /// Collected answers payload
  final RxMap<String, dynamic> answers = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSchema();
  }

  /// Active steps filtered by visible_when conditions
  List<OnboardingStepModel> get activeSteps {
    return allSteps.where((step) {
      if (step.visibleWhen == null) return true;

      final field = step.visibleWhen!.field;
      final expected = step.visibleWhen!.equals;
      final actual = answers[field]?.toString();

      return actual == expected;
    }).toList();
  }

  /// Current active step model
  OnboardingStepModel? get currentStep {
    final steps = activeSteps;
    if (steps.isEmpty || currentStepIndex.value >= steps.length) {
      return null;
    }
    return steps[currentStepIndex.value];
  }

  bool get isFirstStep => currentStepIndex.value == 0;
  bool get isLastStep => currentStepIndex.value >= activeSteps.length - 1;

  /// Find step by key (e.g. 'gender', 'age', etc.)
  OnboardingStepModel? getStep(String key) {
    try {
      return allSteps.firstWhere((step) => step.key == key);
    } catch (_) {
      return null;
    }
  }

  /// Fetch schema steps from GET /api/onboarding/schema/
  Future<void> fetchSchema() async {
    isLoadingSchema(true);
    errorMessage('');

    final result = await assessmentRepository.getSchema();

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isLoadingSchema(false);
      },
      (schema) {
        allSteps.assignAll(schema.steps);
        _initDefaultAnswers();
        isLoadingSchema(false);
      },
    );
  }

  /// Populate default values for schema steps
  void _initDefaultAnswers() {
    for (final step in allSteps) {
      if (step.defaultVal != null) {
        answers[step.key] = step.defaultVal;
      } else if (step.type == 'unit_picker' && step.units.isNotEmpty) {
        final firstUnit = step.units.first;
        answers[step.key] = {
          'value': firstUnit.defaultVal,
          'unit': firstUnit.unit,
        };
      }
    }
  }

  /// Store primitive/single/multi choice answers
  void setAnswer(String key, dynamic value) {
    answers[key] = value;
    answers.refresh();
    errorMessage('');
  }

  /// Store unit picker answers as {"value": num, "unit": String}
  void setUnitAnswer(String key, num value, String unit) {
    answers[key] = {
      'value': value,
      'unit': unit,
    };
    answers.refresh();
    errorMessage('');
  }

  /// Store categorized multi-choice answers as:
  /// { "dietary_preferences": ["vegetarian"], "lifestyle_factors": ["office_worker"] }
  void toggleCategorizedMultiAnswer(
    String stepKey,
    String categoryKey,
    String optionValue,
  ) {
    final rawStepAnswer = answers[stepKey];
    final Map<String, dynamic> stepAnswerMap =
        (rawStepAnswer is Map<String, dynamic>)
            ? Map<String, dynamic>.from(rawStepAnswer)
            : <String, dynamic>{};

    final rawCatList = stepAnswerMap[categoryKey];
    final List<String> catSelectedList = (rawCatList is List)
        ? List<String>.from(rawCatList)
        : <String>[];

    if (optionValue == 'none') {
      if (catSelectedList.contains('none')) {
        catSelectedList.remove('none');
      } else {
        catSelectedList
          ..clear()
          ..add('none');
      }
    } else {
      catSelectedList.remove('none');
      if (catSelectedList.contains(optionValue)) {
        catSelectedList.remove(optionValue);
      } else {
        catSelectedList.add(optionValue);
      }
    }

    stepAnswerMap[categoryKey] = catSelectedList;
    answers[stepKey] = stepAnswerMap;
    answers.refresh();
    errorMessage('');
  }

  /// Move to next step or submit on last step
  Future<void> nextStep() async {
    final step = currentStep;
    if (step != null && step.isRequired) {
      final val = answers[step.key];
      if (val == null || (val is String && val.isEmpty)) {
        errorMessage('Please select an option to continue.');
        return;
      }
    }

    if (isLastStep) {
      await submitOnboarding();
    } else {
      currentStepIndex.value++;
      errorMessage('');
    }
  }

  /// Move back to previous step
  void previousStep() {
    if (!isFirstStep) {
      currentStepIndex.value--;
      errorMessage('');
    }
  }

  /// Submit onboarding answers payload to POST /api/onboarding/complete/
  Future<void> submitOnboarding() async {
    isSubmitting(true);
    errorMessage('');

    // Filter payload to include only visible steps
    final Map<String, dynamic> payload = {};
    for (final step in activeSteps) {
      if (answers.containsKey(step.key)) {
        final val = answers[step.key];
        if (step.type == 'categorized_multi_choice' && val is Map) {
          // Flatten category entries onto root payload so backend receives
          // dietary_preferences and lifestyle_factors as top-level keys!
          val.forEach((catKey, catVal) {
            payload[catKey.toString()] = catVal;
          });
        } else if ((step.key == 'height' || step.storeAs == 'height_cm') && val is Map) {
          // Normalize height to centimeters because the backend database column is height_cm
          // and the API serializer strictly enforces "Height must be between 120 and 219 cm."
          final unit = val['unit']?.toString().toLowerCase();
          final rawVal = (val['value'] as num?)?.toDouble() ?? 170.0;
          if (unit == 'ft' || unit == 'feet') {
            final double inches;
            if (rawVal < 15) {
              // Feet-decimal notation from schema default (e.g. 5.7 -> 5'7")
              final feet = rawVal.toInt();
              final inVal = ((rawVal - feet) * 10).round();
              inches = (feet * 12 + inVal).toDouble();
            } else {
              // Raw value is total inches (e.g. 59, 67, 70)
              inches = rawVal;
            }
            final heightCm = (inches * 2.54).round().clamp(120, 219);
            payload[step.key] = {'value': heightCm, 'unit': 'cm'};
          } else {
            final heightCm = rawVal.round().clamp(120, 219);
            payload[step.key] = {'value': heightCm, 'unit': 'cm'};
          }
        } else if ((step.key == 'weight' || step.storeAs == 'weight_kg') && val is Map) {
          // Normalize weight to kilograms because the backend database column is weight_kg
          // and the API serializer enforces weight in kg (between 40 and 189 kg).
          final unit = val['unit']?.toString().toLowerCase();
          final rawVal = (val['value'] as num?)?.toDouble() ?? 70.0;
          if (unit == 'lb' || unit == 'lbs') {
            final weightKg = (rawVal / 2.20462).round().clamp(40, 189);
            payload[step.key] = {'value': weightKg, 'unit': 'kg'};
          } else {
            final weightKg = rawVal.round().clamp(40, 189);
            payload[step.key] = {'value': weightKg, 'unit': 'kg'};
          }
        } else {
          payload[step.key] = val;
        }
      } else if (step.type == 'unit_picker' && step.units.isNotEmpty) {
        final firstUnit = step.units.first;
        if (step.key == 'height' || step.storeAs == 'height_cm') {
          payload[step.key] = {'value': firstUnit.defaultVal.round(), 'unit': 'cm'};
        } else if (step.key == 'weight' || step.storeAs == 'weight_kg') {
          payload[step.key] = {'value': firstUnit.defaultVal.round(), 'unit': 'kg'};
        }
      }
    }

    final result = await assessmentRepository.completeOnboarding(payload);

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isSubmitting(false);
      },
      (_) async {
        isSubmitting(false);

        // Update user onboarding_completed flag locally
        final user = await AuthStorage.getUser();
        if (user != null) {
          final updatedUser = UserModel(
            id: user.id,
            email: user.email,
            fullName: user.fullName,
            gender: user.gender ?? payload['gender']?.toString(),
            isEmailVerified: user.isEmailVerified,
            onboardingCompleted: true,
            initialScanCompleted: user.initialScanCompleted,
            nextStep: user.nextStep,
          );
          await AuthStorage.saveUser(updatedUser);

          if (Get.isRegistered<UserController>()) {
            Get.find<UserController>().setUser(updatedUser);
          }
        }

        // Navigate to CheckInIntroView after completing onboarding
        Get.offAllNamed(RoutesName.checkInIntro);
      },
    );
  }
}
