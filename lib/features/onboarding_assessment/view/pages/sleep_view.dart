import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/activity_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:get/get.dart';

enum SleepOption { poor, average, good, excellent }

class SleepView extends StatefulWidget {
  const SleepView({super.key});

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
  SleepOption _selected = SleepOption.average;

  @override
  void initState() {
    super.initState();
    _saveToController(_selected);
  }

  void _saveToController(SleepOption option) {
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().setAnswer('sleep', option.name);
    }
  }

  void _onOptionSelected(SleepOption option) {
    setState(() => _selected = option);
    _saveToController(option);
  }

  void _goToNext() {
    _saveToController(_selected);
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().nextStep();
    }
    Get.to(() => const ActivityView());
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
              const AssessmentFlowHeader(currentStep: 7),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.sleepTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.sleepSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      icon: AppIcons.moon,
                      title: AssessmentStrings.sleepPoor,
                      subtitle: AssessmentStrings.sleepPoorSubtitle,
                      isSelected: _selected == SleepOption.poor,
                      onTap: () => _onOptionSelected(SleepOption.poor),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.moon,
                      title: AssessmentStrings.sleepAverage,
                      subtitle: AssessmentStrings.sleepAverageSubtitle,
                      isSelected: _selected == SleepOption.average,
                      onTap: () => _onOptionSelected(SleepOption.average),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.moon,
                      title: AssessmentStrings.sleepGood,
                      subtitle: AssessmentStrings.sleepGoodSubtitle,
                      isSelected: _selected == SleepOption.good,
                      onTap: () => _onOptionSelected(SleepOption.good),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.moon,
                      title: AssessmentStrings.sleepExcellent,
                      subtitle: AssessmentStrings.sleepExcellentSubtitle,
                      isSelected: _selected == SleepOption.excellent,
                      onTap: () => _onOptionSelected(SleepOption.excellent),
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
