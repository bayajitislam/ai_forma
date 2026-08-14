import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/supplements_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_radio_tile.dart';
import 'package:get/get.dart';

enum MenstrualOption {
  menstrual,
  follicular,
  ovulation,
  luteal,
  notSure,
  preferNotToSay,
}

class MenstrualView extends StatefulWidget {
  const MenstrualView({super.key});

  @override
  State<MenstrualView> createState() => _MenstrualViewState();
}

class _MenstrualViewState extends State<MenstrualView> {
  MenstrualOption _selected = MenstrualOption.follicular;

  @override
  void initState() {
    super.initState();
    _saveToController(_selected);
  }

  void _saveToController(MenstrualOption option) {
    if (Get.isRegistered<AssessmentController>()) {
      String val;
      switch (option) {
        case MenstrualOption.menstrual:
          val = 'menstrual';
          break;
        case MenstrualOption.follicular:
          val = 'follicular';
          break;
        case MenstrualOption.ovulation:
          val = 'ovulation';
          break;
        case MenstrualOption.luteal:
          val = 'luteal';
          break;
        case MenstrualOption.notSure:
          val = 'not_sure';
          break;
        case MenstrualOption.preferNotToSay:
          val = 'prefer_not_to_say';
          break;
      }
      Get.find<AssessmentController>().setAnswer('menstrual_cycle', val);
    }
  }

  void _onOptionSelected(MenstrualOption option) {
    setState(() => _selected = option);
    _saveToController(option);
  }

  void _goToNext() {
    _saveToController(_selected);
    if (Get.isRegistered<AssessmentController>()) {
      Get.find<AssessmentController>().nextStep();
    }
    Get.to(() => const SupplementsView());
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
              const AssessmentFlowHeader(currentStep: 10),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.menstrualTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.menstrualSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualPhase,
                      isSelected: _selected == MenstrualOption.menstrual,
                      onTap: () => _onOptionSelected(MenstrualOption.menstrual),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualFollicular,
                      isSelected: _selected == MenstrualOption.follicular,
                      onTap: () => _onOptionSelected(MenstrualOption.follicular),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualOvulation,
                      isSelected: _selected == MenstrualOption.ovulation,
                      onTap: () => _onOptionSelected(MenstrualOption.ovulation),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualLuteal,
                      isSelected: _selected == MenstrualOption.luteal,
                      onTap: () => _onOptionSelected(MenstrualOption.luteal),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualNotSure,
                      isSelected: _selected == MenstrualOption.notSure,
                      onTap: () => _onOptionSelected(MenstrualOption.notSure),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      title: AssessmentStrings.menstrualPreferNotToSay,
                      isSelected: _selected == MenstrualOption.preferNotToSay,
                      onTap: () => _onOptionSelected(MenstrualOption.preferNotToSay),
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
