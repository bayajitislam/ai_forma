import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/medical_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_grid_option_tile.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_info_banner.dart';

enum NutritionPreferenceOption {
  vegetarian,
  vegan,
  pescatarian,
  highProtein,
  lowCarb,
  glutenFree,
  dairyFree,
  intermittentFasting,
  shiftWorker,
  frequentTraveller,
  parentYoungChildren,
  officeWorker,
  physicallyActiveJob,
  noneOfTheAbove,
}

class _PreferenceItem {
  const _PreferenceItem({
    required this.option,
    required this.label,
    required this.icon,
  });

  final NutritionPreferenceOption option;
  final String label;
  final IconData icon;
}

class NutritionPreferencesView extends StatefulWidget {
  const NutritionPreferencesView({super.key});

  @override
  State<NutritionPreferencesView> createState() =>
      _NutritionPreferencesViewState();
}

class _NutritionPreferencesViewState extends State<NutritionPreferencesView> {
  static const _dietaryItems = [
    _PreferenceItem(
      option: NutritionPreferenceOption.vegetarian,
      label: AssessmentStrings.nutritionVegetarian,
      icon: AppIcons.plant,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.vegan,
      label: AssessmentStrings.nutritionVegan,
      icon: AppIcons.plant,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.pescatarian,
      label: AssessmentStrings.nutritionPescatarian,
      icon: AppIcons.fish,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.highProtein,
      label: AssessmentStrings.nutritionHighProtein,
      icon: AppIcons.weight,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.lowCarb,
      label: AssessmentStrings.nutritionLowCarb,
      icon: AppIcons.forbid,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.glutenFree,
      label: AssessmentStrings.nutritionGlutenFree,
      icon: AppIcons.forbid,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.dairyFree,
      label: AssessmentStrings.nutritionDairyFree,
      icon: AppIcons.forbid,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.intermittentFasting,
      label: AssessmentStrings.nutritionIntermittentFasting,
      icon: AppIcons.timer,
    ),
  ];

  static const _lifestyleItems = [
    _PreferenceItem(
      option: NutritionPreferenceOption.shiftWorker,
      label: AssessmentStrings.nutritionShiftWorker,
      icon: AppIcons.time,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.frequentTraveller,
      label: AssessmentStrings.nutritionFrequentTraveller,
      icon: AppIcons.plane,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.parentYoungChildren,
      label: AssessmentStrings.nutritionParentYoungChildren,
      icon: AppIcons.group,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.officeWorker,
      label: AssessmentStrings.nutritionOfficeWorker,
      icon: AppIcons.briefcase,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.physicallyActiveJob,
      label: AssessmentStrings.nutritionPhysicallyActiveJob,
      icon: AppIcons.walk,
    ),
    _PreferenceItem(
      option: NutritionPreferenceOption.noneOfTheAbove,
      label: AssessmentStrings.nutritionNoneOfTheAbove,
      icon: AppIcons.subtract,
    ),
  ];

  final Set<NutritionPreferenceOption> _selected = {};

  void _toggle(NutritionPreferenceOption option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
        return;
      }

      if (option == NutritionPreferenceOption.noneOfTheAbove) {
        _selected
          ..clear()
          ..add(option);
        return;
      }

      _selected
        ..remove(NutritionPreferenceOption.noneOfTheAbove)
        ..add(option);
    });
  }

  void _goToNext() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MedicalView()),
    );
  }

  Widget _buildSection(String title, List<_PreferenceItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return AssessmentGridOptionTile(
              label: item.label,
              icon: item.icon,
              isSelected: _selected.contains(item.option),
              onTap: () => _toggle(item.option),
            );
          },
        ),
      ],
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
              const AssessmentFlowHeader(currentStep: 12),
              const SizedBox(height: 20),
              const Text(
                AssessmentStrings.nutritionPreferencesTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.nutritionPreferencesSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildSection(
                      AssessmentStrings.nutritionDietaryPreferencesSection,
                      _dietaryItems,
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      AssessmentStrings.nutritionLifestyleFactorsSection,
                      _lifestyleItems,
                    ),
                  ],
                ),
              ),
              const AssessmentInfoBanner(
                message: AssessmentStrings.nutritionPreferencesInfoBanner,
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
