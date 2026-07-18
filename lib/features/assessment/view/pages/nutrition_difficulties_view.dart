import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/nutrition_preferences_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_grid_option_tile.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_info_banner.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_selection_badge.dart';

enum NutritionDifficultyOption {
  portionControl,
  cravings,
  lateNightEating,
  emotionalEating,
  fastFood,
  alcohol,
  notEnoughProtein,
  mealPrep,
  busySchedule,
  dontKnowWhatToEat,
  stayingConsistent,
  noneOfThese,
}

class _DifficultyItem {
  const _DifficultyItem({
    required this.option,
    required this.label,
    required this.icon,
  });

  final NutritionDifficultyOption option;
  final String label;
  final IconData icon;
}

class NutritionDifficultiesView extends StatefulWidget {
  const NutritionDifficultiesView({super.key});

  static const int maxSelections = 2;

  @override
  State<NutritionDifficultiesView> createState() =>
      _NutritionDifficultiesViewState();
}

class _NutritionDifficultiesViewState extends State<NutritionDifficultiesView> {
  static const _items = [
    _DifficultyItem(
      option: NutritionDifficultyOption.portionControl,
      label: AssessmentStrings.nutritionPortionControl,
      icon: AppIcons.restaurant,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.cravings,
      label: AssessmentStrings.nutritionCravings,
      icon: AppIcons.cake,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.lateNightEating,
      label: AssessmentStrings.nutritionLateNightEating,
      icon: AppIcons.moon,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.emotionalEating,
      label: AssessmentStrings.nutritionEmotionalEating,
      icon: AppIcons.brain,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.fastFood,
      label: AssessmentStrings.nutritionFastFood,
      icon: AppIcons.restaurant,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.alcohol,
      label: AssessmentStrings.nutritionAlcohol,
      icon: AppIcons.cup,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.notEnoughProtein,
      label: AssessmentStrings.nutritionNotEnoughProtein,
      icon: AppIcons.weight,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.mealPrep,
      label: AssessmentStrings.nutritionMealPrep,
      icon: AppIcons.inbox,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.busySchedule,
      label: AssessmentStrings.nutritionBusySchedule,
      icon: AppIcons.briefcase,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.dontKnowWhatToEat,
      label: AssessmentStrings.nutritionDontKnowWhatToEat,
      icon: AppIcons.question,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.stayingConsistent,
      label: AssessmentStrings.nutritionStayingConsistent,
      icon: AppIcons.checkCircle,
    ),
    _DifficultyItem(
      option: NutritionDifficultyOption.noneOfThese,
      label: AssessmentStrings.nutritionNoneOfThese,
      icon: AppIcons.subtract,
    ),
  ];

  final Set<NutritionDifficultyOption> _selected = {};

  void _toggle(NutritionDifficultyOption option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
        return;
      }

      if (option == NutritionDifficultyOption.noneOfThese) {
        _selected
          ..clear()
          ..add(option);
        return;
      }

      _selected.remove(NutritionDifficultyOption.noneOfThese);

      if (_selected.length >= NutritionDifficultiesView.maxSelections) {
        return;
      }

      _selected.add(option);
    });
  }

  void _goToNext() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NutritionPreferencesView()),
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
              const AssessmentFlowHeader(currentStep: 11),
              const SizedBox(height: 20),
              const Text(
                AssessmentStrings.nutritionDifficultiesTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.nutritionDifficultiesSubtitle,
                style: AppTextStyles.authBody,
              ),
              if (_selected.isNotEmpty) ...[
                const SizedBox(height: 12),
                AssessmentSelectionBadge(
                  selectedCount: _selected.length,
                  maxCount: NutritionDifficultiesView.maxSelections,
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return AssessmentGridOptionTile(
                      label: item.label,
                      icon: item.icon,
                      isSelected: _selected.contains(item.option),
                      onTap: () => _toggle(item.option),
                    );
                  },
                ),
              ),
              const AssessmentInfoBanner(
                message: AssessmentStrings.nutritionDifficultiesInfoBanner,
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
