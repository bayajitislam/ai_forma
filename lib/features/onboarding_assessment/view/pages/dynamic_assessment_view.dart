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
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/measurement_wheel_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicAssessmentView extends GetView<AssessmentController> {
  const DynamicAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
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
                  showBackButton: !controller.isFirstStep,
                ),
                const SizedBox(height: 32),
                Text(step.title, style: AppTextStyles.authSectionTitle),
                const SizedBox(height: 12),
                Text(step.subtitle, style: AppTextStyles.authBody),
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
    switch (step.type) {
      case 'single_choice':
        return _buildSingleChoice(step);
      case 'multi_choice':
        return _buildMultiChoice(step);
      case 'number_picker':
        return _buildNumberPicker(step);
      case 'unit_picker':
        return _buildUnitPicker(step);
      default:
        return _buildSingleChoice(step);
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

        return AssessmentRadioTile(
          icon: AppIcons.user,
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
