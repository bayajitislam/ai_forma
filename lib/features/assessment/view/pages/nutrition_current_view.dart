import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/nutrition_confidence_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_category_badge.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/nutrition_radio_tile.dart';

enum NutritionCurrentOption {
  balancedDiet,
  occasionalSetbacks,
  struggleConsistency,
  takeawayMeals,
  notPriority,
}

class NutritionCurrentView extends StatefulWidget {
  const NutritionCurrentView({super.key});

  @override
  State<NutritionCurrentView> createState() => _NutritionCurrentViewState();
}

class _NutritionCurrentViewState extends State<NutritionCurrentView> {
  NutritionCurrentOption _selected = NutritionCurrentOption.balancedDiet;

  void _goToNext() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NutritionConfidenceView()),
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
              const AssessmentFlowHeader(currentStep: 9),
              const SizedBox(height: 12),
              const AssessmentCategoryBadge(),
              const SizedBox(height: 20),
              const Text(
                AssessmentStrings.nutritionCurrentTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.nutritionCurrentSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    NutritionRadioTile(
                      icon: AppIcons.checkCircle,
                      title: AssessmentStrings.nutritionBalancedDiet,
                      subtitle: AssessmentStrings.nutritionBalancedDietSubtitle,
                      isSelected:
                          _selected == NutritionCurrentOption.balancedDiet,
                      onTap: () => setState(
                        () => _selected = NutritionCurrentOption.balancedDiet,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.thumbUp,
                      title: AssessmentStrings.nutritionOccasionalSetbacks,
                      subtitle:
                          AssessmentStrings.nutritionOccasionalSetbacksSubtitle,
                      isSelected:
                          _selected == NutritionCurrentOption.occasionalSetbacks,
                      onTap: () => setState(
                        () => _selected =
                            NutritionCurrentOption.occasionalSetbacks,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.scales,
                      title: AssessmentStrings.nutritionStruggleConsistency,
                      subtitle:
                          AssessmentStrings.nutritionStruggleConsistencySubtitle,
                      isSelected: _selected ==
                          NutritionCurrentOption.struggleConsistency,
                      onTap: () => setState(
                        () => _selected =
                            NutritionCurrentOption.struggleConsistency,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.restaurant,
                      title: AssessmentStrings.nutritionTakeawayMeals,
                      subtitle: AssessmentStrings.nutritionTakeawayMealsSubtitle,
                      isSelected:
                          _selected == NutritionCurrentOption.takeawayMeals,
                      onTap: () => setState(
                        () => _selected = NutritionCurrentOption.takeawayMeals,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NutritionRadioTile(
                      icon: AppIcons.closeCircle,
                      title: AssessmentStrings.nutritionNotPriority,
                      subtitle: AssessmentStrings.nutritionNotPrioritySubtitle,
                      isSelected: _selected == NutritionCurrentOption.notPriority,
                      onTap: () => setState(
                        () => _selected = NutritionCurrentOption.notPriority,
                      ),
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
