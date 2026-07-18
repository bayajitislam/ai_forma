import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/experience_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_radio_tile.dart';

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

  void _goToNext() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ExperienceView()));
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
                      onTap: () => setState(
                        () => _selected = ObjectiveOption.reduceBodyFat,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.bodyScan,
                      title: AssessmentStrings.objectiveIncreaseMuscle,
                      isSelected: _selected == ObjectiveOption.increaseMuscle,
                      onTap: () => setState(
                        () => _selected = ObjectiveOption.increaseMuscle,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.heartPulse,
                      title: AssessmentStrings.objectiveImproveComposition,
                      isSelected:
                          _selected == ObjectiveOption.improveComposition,
                      onTap: () => setState(
                        () => _selected = ObjectiveOption.improveComposition,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.flash,
                      title: AssessmentStrings.objectiveGeneralHealth,
                      isSelected: _selected == ObjectiveOption.generalHealth,
                      onTap: () => setState(
                        () => _selected = ObjectiveOption.generalHealth,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AssessmentRadioTile(
                      icon: AppIcons.user,
                      title: AssessmentStrings.objectiveSomethingElse,
                      isSelected: _selected == ObjectiveOption.somethingElse,
                      onTap: () => setState(
                        () => _selected = ObjectiveOption.somethingElse,
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(onPressed: _goToNext, label: AppStrings.nextButton),
              Platform.isAndroid
                  ? const SizedBox(height: 26)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
