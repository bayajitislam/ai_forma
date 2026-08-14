import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/experience_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:get/get.dart';

enum ObjectiveOption {
  reduceBodyFat,
  increaseMuscle,
  improveComposition,
  generalHealth,
  somethingElse,
}

class ObjectiveView extends StatefulWidget {
  const ObjectiveView({super.key});

  @override
  State<ObjectiveView> createState() => _ObjectiveViewState();
}

class _ObjectiveViewState extends State<ObjectiveView> {
  ObjectiveOption _selected = ObjectiveOption.reduceBodyFat;

  @override
  void initState() {
    super.initState();
    _saveToController(_selected);
  }

  void _saveToController(ObjectiveOption option) {
    if (Get.isRegistered<AssessmentController>()) {
      String value;
      switch (option) {
        case ObjectiveOption.reduceBodyFat:
          value = 'reduce_body_fat';
          break;
        case ObjectiveOption.increaseMuscle:
          value = 'increase_muscle_mass';
          break;
        case ObjectiveOption.improveComposition:
          value = 'improve_body_composition';
          break;
        case ObjectiveOption.generalHealth:
          value = 'general_health';
          break;
        case ObjectiveOption.somethingElse:
          value = 'something_else';
          break;
      }
      Get.find<AssessmentController>().setAnswer('goal', value);
    }
  }

  void _onOptionSelected(ObjectiveOption option) {
    setState(() => _selected = option);
    _saveToController(option);
  }

  void _goToNext() {
    _saveToController(_selected);
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().nextStep();
    }
    Get.to(() => const ExperienceView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const AssessmentFlowHeader(currentStep: 5),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.objectiveTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.objectiveSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      icon: AppIcons.focusTarget,
                      title: AssessmentStrings.objectiveReduceBodyFat,
                      isSelected: _selected == ObjectiveOption.reduceBodyFat,
                      onTap: () => _onOptionSelected(ObjectiveOption.reduceBodyFat),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.bodyScan,
                      title: AssessmentStrings.objectiveIncreaseMuscle,
                      isSelected: _selected == ObjectiveOption.increaseMuscle,
                      onTap: () => _onOptionSelected(ObjectiveOption.increaseMuscle),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.heartPulse,
                      title: AssessmentStrings.objectiveImproveComposition,
                      isSelected: _selected == ObjectiveOption.improveComposition,
                      onTap: () => _onOptionSelected(ObjectiveOption.improveComposition),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.flash,
                      title: AssessmentStrings.objectiveGeneralHealth,
                      isSelected: _selected == ObjectiveOption.generalHealth,
                      onTap: () => _onOptionSelected(ObjectiveOption.generalHealth),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.user,
                      title: AssessmentStrings.objectiveSomethingElse,
                      isSelected: _selected == ObjectiveOption.somethingElse,
                      onTap: () => _onOptionSelected(ObjectiveOption.somethingElse),
                    ),
                  ],
                ),
              ),
              PrimaryButton(onPressed: _goToNext, label: AppStrings.nextButton),
              Platform.isAndroid
                  ? const SizedBox(height: 26)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
