import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/supplements_view.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/menstrual_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:get/get.dart';

enum MedicalOption { no, currentInjury, medicalCondition, preferNotToAnswer }

class MedicalView extends StatefulWidget {
  const MedicalView({super.key});

  @override
  State<MedicalView> createState() => _MedicalViewState();
}

class _MedicalViewState extends State<MedicalView> {
  MedicalOption _selected = MedicalOption.no;

  @override
  void initState() {
    super.initState();
    _saveToController(_selected);
  }

  void _saveToController(MedicalOption option) {
    if (Get.isRegistered<AssessmentController>()) {
      String val;
      switch (option) {
        case MedicalOption.no:
          val = 'none';
          break;
        case MedicalOption.currentInjury:
          val = 'current_injury';
          break;
        case MedicalOption.medicalCondition:
          val = 'medical_condition';
          break;
        case MedicalOption.preferNotToAnswer:
          val = 'prefer_not_to_answer';
          break;
      }
      Get.find<AssessmentController>().setAnswer('health_notes', val);
    }
  }

  void _onOptionSelected(MedicalOption option) {
    setState(() => _selected = option);
    _saveToController(option);
  }

  void _goToNext() {
    _saveToController(_selected);
    if (Get.isRegistered<AssessmentController>()) {
      final controller = Get.find<AssessmentController>();
      controller.nextStep();

      // Check if gender is female; if not, skip MenstrualView directly to SupplementsView
      final isFemale = controller.answers['gender'] == 'female';
      if (isFemale) {
        Get.to(() => const MenstrualView());
      } else {
        Get.to(() => const SupplementsView());
      }
    } else {
      Get.to(() => const MenstrualView());
    }
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
              const AssessmentFlowHeader(currentStep: 9),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.medicalTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.medicalSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalNo,
                      isSelected: _selected == MedicalOption.no,
                      onTap: () => _onOptionSelected(MedicalOption.no),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalCurrentInjury,
                      isSelected: _selected == MedicalOption.currentInjury,
                      onTap: () => _onOptionSelected(MedicalOption.currentInjury),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalCondition,
                      isSelected: _selected == MedicalOption.medicalCondition,
                      onTap: () => _onOptionSelected(MedicalOption.medicalCondition),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.medicalPreferNotToAnswer,
                      isSelected: _selected == MedicalOption.preferNotToAnswer,
                      onTap: () => _onOptionSelected(MedicalOption.preferNotToAnswer),
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
