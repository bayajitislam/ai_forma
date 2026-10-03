import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/weight_selector.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeightSelectionSheet extends StatefulWidget {
  final double? initialWeightKg;
  final ValueChanged<double> onWeightSelected;

  const WeightSelectionSheet({
    super.key,
    this.initialWeightKg,
    required this.onWeightSelected,
  });

  static void show(
    BuildContext context, {
    required double? initialWeightKg,
    required ValueChanged<double> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => WeightSelectionSheet(
        initialWeightKg: initialWeightKg,
        onWeightSelected: onSelected,
      ),
    );
  }

  @override
  State<WeightSelectionSheet> createState() => _WeightSelectionSheetState();
}

class _WeightSelectionSheetState extends State<WeightSelectionSheet> {
  late double _tempWeightKg;

  @override
  void initState() {
    super.initState();
    _tempWeightKg = widget.initialWeightKg ?? 70.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            ProfileStrings.updateWeightTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          WeightSelector(
            initialWeightKg: _tempWeightKg,
            onChanged: (val) {
              _tempWeightKg = val;
            },
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            onPressed: () {
              widget.onWeightSelected(_tempWeightKg);
              Get.back();
            },
            label: ProfileStrings.save,
          ),
        ],
      ),
    );
  }
}
