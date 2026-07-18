import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/objective_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/assessment/view/widgets/measurement_wheel_picker.dart';

class WeightView extends StatefulWidget {
  const WeightView({super.key});

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView> {
  int _unitIndex = 0;
  int _weightKg = AssessmentStrings.defaultWeightKg;
  int _weightLb = AssessmentStrings.defaultWeightLb;

  bool get _isKg => _unitIndex == 0;

  void _onUnitChanged(int index) {
    if (index == _unitIndex) {
      return;
    }

    setState(() {
      if (index == 0) {
        _weightKg = _lbToKg(_weightLb);
      } else {
        _weightLb = _kgToLb(_weightKg);
      }
      _unitIndex = index;
    });
  }

  int _kgToLb(int kg) => (kg * 2.20462).round().clamp(
    AssessmentStrings.minWeightLb,
    AssessmentStrings.maxWeightLb,
  );

  int _lbToKg(int lb) => (lb / 2.20462).round().clamp(
    AssessmentStrings.minWeightKg,
    AssessmentStrings.maxWeightKg,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const AssessmentFlowHeader(currentStep: 4),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.weightTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.weightSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 24),
              AssessmentUnitToggle(
                options: const [
                  AssessmentStrings.weightUnitKg,
                  AssessmentStrings.weightUnitLb,
                ],
                selectedIndex: _unitIndex,
                onChanged: _onUnitChanged,
              ),
              const Spacer(),
              Center(
                child: _isKg
                    ? MeasurementWheelPicker(
                        key: const ValueKey('weight-kg'),
                        minValue: AssessmentStrings.minWeightKg,
                        maxValue: AssessmentStrings.maxWeightKg,
                        initialValue: _weightKg,
                        unit: 'kg',
                        onChanged: (value) => _weightKg = value,
                      )
                    : MeasurementWheelPicker(
                        key: const ValueKey('weight-lb'),
                        minValue: AssessmentStrings.minWeightLb,
                        maxValue: AssessmentStrings.maxWeightLb,
                        initialValue: _weightLb,
                        unit: 'lb',
                        onChanged: (value) => _weightLb = value,
                      ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ObjectiveView(),
                    ),
                  );
                },
                label: AppStrings.nextButton,
              ),
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
