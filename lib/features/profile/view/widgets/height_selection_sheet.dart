import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/measurement_wheel_picker.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeightSelectionSheet extends StatefulWidget {
  final double? initialHeightCm;
  final ValueChanged<double> onHeightSelected;

  const HeightSelectionSheet({
    super.key,
    this.initialHeightCm,
    required this.onHeightSelected,
  });

  static void show(
    BuildContext context, {
    required double? initialHeightCm,
    required ValueChanged<double> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => HeightSelectionSheet(
        initialHeightCm: initialHeightCm,
        onHeightSelected: onSelected,
      ),
    );
  }

  @override
  State<HeightSelectionSheet> createState() => _HeightSelectionSheetState();
}

class _HeightSelectionSheetState extends State<HeightSelectionSheet> {
  late int _tempHeightCm;

  @override
  void initState() {
    super.initState();
    _tempHeightCm =
        (widget.initialHeightCm ?? 175.0).round().clamp(100, 250);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            ProfileStrings.updateHeightTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          MeasurementWheelPicker(
            minValue: 100,
            maxValue: 250,
            initialValue: _tempHeightCm,
            unit: 'cm',
            onChanged: (val) {
              _tempHeightCm = val;
            },
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            onPressed: () {
              widget.onHeightSelected(_tempHeightCm.toDouble());
              Get.back();
            },
            label: ProfileStrings.save,
          ),
        ],
      ),
    );
  }
}
