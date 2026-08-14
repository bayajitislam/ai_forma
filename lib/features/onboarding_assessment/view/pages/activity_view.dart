import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/medical_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:get/get.dart';

enum ActivityOption { sedentary, lightlyActive, moderatelyActive, veryActive }

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  ActivityOption _selected = ActivityOption.moderatelyActive;

  @override
  void initState() {
    super.initState();
    _saveToController(_selected);
  }

  void _saveToController(ActivityOption option) {
    if (Get.isRegistered<AssessmentController>()) {
      String val;
      switch (option) {
        case ActivityOption.sedentary:
          val = 'sedentary';
          break;
        case ActivityOption.lightlyActive:
          val = 'lightly_active';
          break;
        case ActivityOption.moderatelyActive:
          val = 'moderately_active';
          break;
        case ActivityOption.veryActive:
          val = 'very_active';
          break;
      }
      Get.find<AssessmentController>().setAnswer('activity_level', val);
    }
  }

  void _onOptionSelected(ActivityOption option) {
    setState(() => _selected = option);
    _saveToController(option);
  }

  void _goToNext() {
    _saveToController(_selected);
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().nextStep();
    }
    Get.to(() => const MedicalView());
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
              const AssessmentFlowHeader(currentStep: 8),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.activityTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.activitySubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      icon: AppIcons.user,
                      title: AssessmentStrings.activitySedentary,
                      subtitle: AssessmentStrings.activitySedentarySubtitle,
                      isSelected: _selected == ActivityOption.sedentary,
                      onTap: () => _onOptionSelected(ActivityOption.sedentary),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.heartPulse,
                      title: AssessmentStrings.activityLightlyActive,
                      subtitle: AssessmentStrings.activityLightlyActiveSubtitle,
                      isSelected: _selected == ActivityOption.lightlyActive,
                      onTap: () => _onOptionSelected(ActivityOption.lightlyActive),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.flash,
                      title: AssessmentStrings.activityModeratelyActive,
                      subtitle: AssessmentStrings.activityModeratelyActiveSubtitle,
                      isSelected: _selected == ActivityOption.moderatelyActive,
                      onTap: () => _onOptionSelected(ActivityOption.moderatelyActive),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.run,
                      title: AssessmentStrings.activityVeryActive,
                      subtitle: AssessmentStrings.activityVeryActiveSubtitle,
                      isSelected: _selected == ActivityOption.veryActive,
                      onTap: () => _onOptionSelected(ActivityOption.veryActive),
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
