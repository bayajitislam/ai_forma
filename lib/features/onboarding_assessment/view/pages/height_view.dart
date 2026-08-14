import 'dart:io';

import 'package:ai_forma/features/onboarding_assessment/controllers/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/pages/weight_view.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/measurement_wheel_picker.dart';
import 'package:get/get.dart';

class HeightView extends StatefulWidget {
  const HeightView({super.key});

  @override
  State<HeightView> createState() => _HeightViewState();
}

class _HeightViewState extends State<HeightView> {
  int _unitIndex = 0;
  int _heightCm = AssessmentStrings.defaultHeightCm;
  int _heightInches = AssessmentStrings.defaultHeightInches;

  bool get _isCm => _unitIndex == 0;

  @override
  void initState() {
    super.initState();
    _saveToController();
  }

  void _saveToController() {
    if (Get.isRegistered<AssessmentController>()) {
      if (_isCm) {
        Get.find<AssessmentController>().setUnitAnswer(
          'height',
          _heightCm,
          'cm',
        );
      } else {
        Get.find<AssessmentController>().setUnitAnswer(
          'height',
          (_heightInches / 12).roundToDouble(),
          'ft',
        );
      }
    }
  }

  void _onUnitChanged(int index) {
    if (index == _unitIndex) return;

    setState(() {
      if (index == 0) {
        _heightCm = _inchesToCm(_heightInches);
      } else {
        _heightInches = _cmToInches(_heightCm);
      }
      _unitIndex = index;
    });
    _saveToController();
  }

  int _cmToInches(int cm) => (cm / 2.54).round().clamp(
    AssessmentStrings.minHeightInches,
    AssessmentStrings.maxHeightInches,
  );

  int _inchesToCm(int inches) => (inches * 2.54).round().clamp(
    AssessmentStrings.minHeightCm,
    AssessmentStrings.maxHeightCm,
  );

  String _formatFeetInches(int totalInches) {
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet\' $inches"';
  }

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
              const AssessmentFlowHeader(currentStep: 3),
              const SizedBox(height: 32),
              const Text(
                AssessmentStrings.heightTitle,
                style: AppTextStyles.authSectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                AssessmentStrings.heightSubtitle,
                style: AppTextStyles.authBody,
              ),
              const SizedBox(height: 24),
              AssessmentUnitToggle(
                options: const [
                  AssessmentStrings.heightUnitCm,
                  AssessmentStrings.heightUnitFt,
                ],
                selectedIndex: _unitIndex,
                onChanged: _onUnitChanged,
              ),
              const Spacer(),
              Center(
                child: _isCm
                    ? MeasurementWheelPicker(
                        key: const ValueKey('height-cm'),
                        minValue: AssessmentStrings.minHeightCm,
                        maxValue: AssessmentStrings.maxHeightCm,
                        initialValue: _heightCm,
                        unit: AssessmentStrings.heightUnitCm,
                        onChanged: (value) {
                          _heightCm = value;
                          _saveToController();
                        },
                      )
                    : MeasurementWheelPicker(
                        key: const ValueKey('height-ft'),
                        minValue: AssessmentStrings.minHeightInches,
                        maxValue: AssessmentStrings.maxHeightInches,
                        initialValue: _heightInches,
                        labelBuilder: _formatFeetInches,
                        onChanged: (value) {
                          _heightInches = value;
                          _saveToController();
                        },
                      ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  _saveToController();
                  if (Get.isRegistered<AssessmentController>()) {
                    Get.find<AssessmentController>().nextStep();
                  }
                  Get.to(() => const WeightView());
                },
                label: AppStrings.nextButton,
              ),
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
