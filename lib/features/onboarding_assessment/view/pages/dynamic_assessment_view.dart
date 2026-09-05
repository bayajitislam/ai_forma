import 'dart:io';

import 'package:ai_forma/core/common/app_loader.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:ai_forma/features/onboarding_assessment/models/onboarding_schema_model.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/age_wheel_picker.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_checkbox_tile.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_grid_option_tile.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/measurement_wheel_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicAssessmentView extends GetView<AssessmentController> {
  const DynamicAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.isFirstStep,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && !controller.isFirstStep) {
            controller.previousStep();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.onboardingBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Builder(builder: (_) {
                if (controller.isLoadingSchema.value) {
                  return _buildSchemaLoadingView();
                }

                final step = controller.currentStep;
                if (step == null) {
                  return const Center(child: Text("No steps available"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    AssessmentFlowHeader(
                      currentStep: controller.currentStepIndex.value + 1,
                      totalSteps: controller.activeSteps.length,
                      showBackButton: !controller.isFirstStep,
                      onBackTap: () => controller.previousStep(),
                    ),
                    const SizedBox(height: 32),
                    Text(step.title, style: AppTextStyles.authSectionTitle),
                    const SizedBox(height: 12),
                    Text(step.subtitle, style: AppTextStyles.authBody),
                    // if (step.infoNote != null &&
                    //     step.infoNote!.isNotEmpty) ...[
                    //   const SizedBox(height: 12),
                    //   AssessmentInfoBanner(message: step.infoNote!),
                    // ],
                    const SizedBox(height: 20),
                    Expanded(child: _buildStepBody(step)),
                    // Inline error display
                    if (controller.errorMessage.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Obx(
                      () => PrimaryButton(
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () => controller.nextStep(),
                        label: controller.isLastStep
                            ? 'Complete'
                            : AppStrings.nextButton,
                      ),
                    ),
                    Platform.isAndroid
                        ? const SizedBox(height: 26)
                        : const SizedBox.shrink(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  /// Shown while GET /api/onboarding/schema/ is loading
  Widget _buildSchemaLoadingView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoader(color: AppColors.brandTeal),
            SizedBox(height: 20),
            Text(
              "We are getting everything ready for you...",
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Loading your body intelligence assessment profile...",
              style: AppTextStyles.authBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Renders step input body dynamically based on step.type
  Widget _buildStepBody(OnboardingStepModel step) {
    return Obx(() {
      switch (step.type) {
        case 'single_choice':
          return _buildSingleChoice(step);
        case 'multi_choice':
          return _buildMultiChoice(step);
        case 'categorized_multi_choice':
          return _buildCategorizedMultiChoice(step);
        case 'number_picker':
          return _buildNumberPicker(step);
        case 'unit_picker':
          return _buildUnitPicker(step);
        default:
          return _buildSingleChoice(step);
      }
    });
  }

  Widget _buildCategorizedMultiChoice(OnboardingStepModel step) {
    final rawStepAnswer = controller.answers[step.key];
    final Map<String, dynamic> stepAnswerMap =
        (rawStepAnswer is Map<String, dynamic>)
            ? Map<String, dynamic>.from(rawStepAnswer)
            : <String, dynamic>{};

    return ListView.separated(
      itemCount: step.categories.length,
      separatorBuilder: (_, _) => const SizedBox(height: 24),
      itemBuilder: (context, catIndex) {
        final cat = step.categories[catIndex];
        final rawCatList = stepAnswerMap[cat.key];
        final selectedList = (rawCatList is List)
            ? List<String>.from(rawCatList)
            : <String>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cat.title,
              style: AppTextStyles.featureDescription.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.brandTealDark,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: cat.options.length,
              itemBuilder: (context, optIndex) {
                final opt = cat.options[optIndex];
                final isSelected = selectedList.contains(opt.value);
                final iconData = _resolveDynamicIcon(
                  opt.icon,
                  opt.value,
                  cat.key,
                );

                return AssessmentGridOptionTile(
                  label: opt.label,
                  icon: iconData,
                  isSelected: isSelected,
                  onTap: () {
                    controller.toggleCategorizedMultiAnswer(
                      step.key,
                      cat.key,
                      opt.value,
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  IconData _resolveDynamicIcon(String? rawIcon, String value, [String? stepKey]) {
    // 1. Explicit icon string from backend JSON (e.g. "plant", "women", "fire")
    if (rawIcon != null && rawIcon.isNotEmpty) {
      final parsed = _mapNameToIcon(rawIcon);
      if (parsed != null) return parsed;
    }

    // 2. Resolve by option value name
    final valueIcon = _mapNameToIcon(value);
    if (valueIcon != null) return valueIcon;

    // 3. Fallback resolve by step key / context
    if (stepKey != null && stepKey.isNotEmpty) {
      switch (stepKey) {
        case 'gender':
          return value == 'female' ? AppIcons.women : AppIcons.men;
        case 'age':
          return AppIcons.cake;
        case 'height':
        case 'weight':
          return AppIcons.scales;
        case 'goal':
          return AppIcons.fire;
        case 'experience':
          return AppIcons.star;
        case 'sleep':
          return AppIcons.moon;
        case 'activity_level':
          return AppIcons.run;
        case 'nutrition_pattern':
          return AppIcons.restaurant;
        case 'confidence_level':
          return AppIcons.sparkle;
        case 'dietary_and_lifestyle':
          return AppIcons.plant;
        case 'health_notes':
          return AppIcons.info;
        case 'menstrual_cycle':
          return AppIcons.refresh;
        case 'supplements':
          return AppIcons.shield;
      }
    }

    return AppIcons.user;
  }

  IconData? _mapNameToIcon(String name) {
    final lower = name.toLowerCase().replaceAll('-', '_');
    switch (lower) {
      case 'male':
      case 'men':
      case 'man':
        return AppIcons.men;
      case 'female':
      case 'women':
      case 'woman':
        return AppIcons.women;
      case 'plant':
      case 'vegetarian':
      case 'vegan':
        return AppIcons.plant;
      case 'fish':
      case 'pescatarian':
        return AppIcons.fish;
      case 'weight':
      case 'high_protein':
      case 'protein_powder':
        return AppIcons.weight;
      case 'forbid':
      case 'low_carb':
      case 'gluten_free':
      case 'dairy_free':
        return AppIcons.forbid;
      case 'timer':
      case 'intermittent_fasting':
        return AppIcons.timer;
      case 'time':
      case 'shift_worker':
        return AppIcons.time;
      case 'plane':
      case 'frequent_traveller':
        return AppIcons.plane;
      case 'group':
      case 'parent_young_children':
        return AppIcons.group;
      case 'briefcase':
      case 'office_worker':
        return AppIcons.briefcase;
      case 'walk':
      case 'physically_active_job':
      case 'lightly_active':
        return AppIcons.walk;
      case 'run':
      case 'moderately_active':
      case 'very_active':
        return AppIcons.run;
      case 'subtract':
      case 'none':
      case 'none_of_the_above':
        return AppIcons.subtract;
      case 'creatine':
      case 'pre_workout':
      case 'fire':
      case 'reduce_body_fat':
        return AppIcons.fire;
      case 'vitamins_minerals':
      case 'omega_3':
      case 'supplements':
      case 'shield':
        return AppIcons.shield;
      case 'star':
      case 'beginner':
      case 'intermediate':
      case 'advanced':
        return AppIcons.star;
      case 'sleep':
      case 'poor':
      case 'average':
      case 'good':
      case 'excellent':
      case 'moon':
        return AppIcons.moon;
      case 'confidence':
      case 'sparkle':
      case 'very_confident':
      case 'somewhat_confident':
        return AppIcons.sparkle;
      default:
        return null;
    }
  }

  Widget _buildSingleChoice(OnboardingStepModel step) {
    final currentSelected = controller.answers[step.key]?.toString();

    return ListView.separated(
      itemCount: step.options.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final opt = step.options[index];
        final isSelected = currentSelected == opt.value;
        final iconData = _resolveDynamicIcon(opt.icon, opt.value, step.key);

        return AssessmentRadioTile(
          icon: iconData,
          title: opt.label,
          subtitle: opt.description,
          isSelected: isSelected,
          onTap: () {
            controller.setAnswer(step.key, opt.value);
          },
        );
      },
    );
  }

  Widget _buildMultiChoice(OnboardingStepModel step) {
    final rawList = controller.answers[step.key];
    final selectedList = (rawList is List)
        ? List<String>.from(rawList)
        : <String>[];

    return ListView.builder(
      itemCount: step.options.length,
      itemBuilder: (context, index) {
        final opt = step.options[index];
        final isSelected = selectedList.contains(opt.value);

        return AssessmentCheckboxTile(
          label: opt.label,
          isSelected: isSelected,
          onTap: () {
            final updated = List<String>.from(selectedList);
            if (isSelected) {
              updated.remove(opt.value);
            } else {
              updated.add(opt.value);
            }
            controller.setAnswer(step.key, updated);
          },
        );
      },
    );
  }

  Widget _buildNumberPicker(OnboardingStepModel step) {
    final min = (step.min ?? 16).toInt();
    final max = (step.max ?? 95).toInt();
    final initial =
        (controller.answers[step.key] ?? step.defaultVal ?? min) as int;

    return Center(
      child: AgeWheelPicker(
        minAge: min,
        maxAge: max,
        initialAge: initial,
        onChanged: (val) => controller.setAnswer(step.key, val),
      ),
    );
  }

  Widget _buildUnitPicker(OnboardingStepModel step) {
    if (step.units.isEmpty) return const SizedBox.shrink();

    final selectedUnitObj = controller.answers[step.key];
    final selectedUnit =
        (selectedUnitObj is Map && selectedUnitObj['unit'] != null)
        ? selectedUnitObj['unit'].toString()
        : step.units.first.unit;

    final unitIndex = step.units.indexWhere((u) => u.unit == selectedUnit);
    final activeUnitIndex = unitIndex >= 0 ? unitIndex : 0;
    final currentUnitConfig = step.units[activeUnitIndex];

    final currentVal =
        (selectedUnitObj is Map && selectedUnitObj['value'] != null)
        ? (selectedUnitObj['value'] as num).toInt()
        : currentUnitConfig.defaultVal.toInt();

    return Column(
      children: [
        AssessmentUnitToggle(
          options: step.units.map((u) => u.unit.toUpperCase()).toList(),
          selectedIndex: activeUnitIndex,
          onChanged: (idx) {
            final newUnit = step.units[idx];
            controller.setUnitAnswer(
              step.key,
              newUnit.defaultVal,
              newUnit.unit,
            );
          },
        ),
        const Spacer(),
        MeasurementWheelPicker(
          key: ValueKey('${step.key}-$selectedUnit'),
          minValue: currentUnitConfig.min.toInt(),
          maxValue: currentUnitConfig.max.toInt(),
          initialValue: currentVal,
          unit: currentUnitConfig.unit,
          onChanged: (val) {
            controller.setUnitAnswer(step.key, val, currentUnitConfig.unit);
          },
        ),
        const Spacer(),
      ],
    );
  }
}
