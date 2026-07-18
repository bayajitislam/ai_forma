import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/nutrition_difficulties_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_info_banner.dart';
import 'package:ai_forma/features/assessment/view/widgets/nutrition_radio_tile.dart';

enum NutritionConfidenceOption {
  veryConfident,
  somewhatConfident,
  unsure,
  needDirection,
}

class NutritionConfidenceView extends StatefulWidget {
  const NutritionConfidenceView({super.key});

  @override
  State<NutritionConfidenceView> createState() =>
      _NutritionConfidenceViewState();
}

class _NutritionConfidenceViewState extends State<NutritionConfidenceView> {
  NutritionConfidenceOption _selected = NutritionConfidenceOption.veryConfident;

  void _goToNext() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NutritionDifficultiesView(),
      ),
    );
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
              const SizedBox(height: 20),
              const Text(
                AssessmentStrings.nutritionConfidenceTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.nutritionConfidenceSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    NutritionRadioTile(
                      icon: AppIcons.focusTarget,
                      title: AssessmentStrings.nutritionVeryConfident,
                      subtitle:
                          AssessmentStrings.nutritionVeryConfidentSubtitle,
                      isSelected:
                          _selected == NutritionConfidenceOption.veryConfident,
                      onTap: () => setState(
                        () =>
                            _selected = NutritionConfidenceOption.veryConfident,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.thumbUp,
                      title: AssessmentStrings.nutritionSomewhatConfident,
                      subtitle:
                          AssessmentStrings.nutritionSomewhatConfidentSubtitle,
                      isSelected:
                          _selected ==
                          NutritionConfidenceOption.somewhatConfident,
                      onTap: () => setState(
                        () => _selected =
                            NutritionConfidenceOption.somewhatConfident,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.question,
                      title: AssessmentStrings.nutritionUnsure,
                      subtitle: AssessmentStrings.nutritionUnsureSubtitle,
                      isSelected: _selected == NutritionConfidenceOption.unsure,
                      onTap: () => setState(
                        () => _selected = NutritionConfidenceOption.unsure,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.signpost,
                      title: AssessmentStrings.nutritionNeedDirection,
                      subtitle:
                          AssessmentStrings.nutritionNeedDirectionSubtitle,
                      isSelected:
                          _selected == NutritionConfidenceOption.needDirection,
                      onTap: () => setState(
                        () =>
                            _selected = NutritionConfidenceOption.needDirection,
                      ),
                    ),
                  ],
                ),
              ),
              const AssessmentInfoBanner(
                message: AssessmentStrings.nutritionConfidenceInfoBanner,
              ),
              const SizedBox(height: 16),
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
