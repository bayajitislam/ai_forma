import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/pages/weight_view.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_flow_header.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/assessment/view/widgets/measurement_wheel_picker.dart';

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

  void _onUnitChanged(int index) {
    if (index == _unitIndex) {
      return;
    }

    setState(() {
      if (index == 0) {
        _heightCm = _inchesToCm(_heightInches);
      } else {
        _heightInches = _cmToInches(_heightCm);
      }
      _unitIndex = index;
    });
  }

  int _cmToInches(int cm) =>
      (cm / 2.54).round().clamp(
        AssessmentStrings.minHeightInches,
        AssessmentStrings.maxHeightInches,
      );

  int _inchesToCm(int inches) =>
      (inches * 2.54).round().clamp(
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        onChanged: (value) => _heightCm = value,
                      )
                    : MeasurementWheelPicker(
                        key: const ValueKey('height-ft'),
                        minValue: AssessmentStrings.minHeightInches,
                        maxValue: AssessmentStrings.maxHeightInches,
                        initialValue: _heightInches,
                        labelBuilder: _formatFeetInches,
                        onChanged: (value) => _heightInches = value,
                      ),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const WeightView(),
                    ),
                  );
                },
                label: AppStrings.nextButton,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
