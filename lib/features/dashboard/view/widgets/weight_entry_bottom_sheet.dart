import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/onboarding_assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/weight_selector.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/core/models/weight_record.dart';

class WeightEntryBottomSheet extends StatefulWidget {
  final WeightRecord? initialRecord;
  final double? initialWeightKg;

  const WeightEntryBottomSheet({
    super.key,
    this.initialRecord,
    this.initialWeightKg,
  });

  static Future<void> show(BuildContext context, {WeightRecord? record, double? initialWeightKg}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => WeightEntryBottomSheet(
        initialRecord: record,
        initialWeightKg: initialWeightKg,
      ),
    );
  }

  @override
  State<WeightEntryBottomSheet> createState() => _WeightEntryBottomSheetState();
}

class _WeightEntryBottomSheetState extends State<WeightEntryBottomSheet> {
  late double _selectedWeightKg;

  @override
  void initState() {
    super.initState();
    _selectedWeightKg = widget.initialRecord?.weightKg ??
        widget.initialWeightKg ??
        AssessmentStrings.defaultWeightKg.toDouble();
  }

  void _save() {
    final controller = Get.find<WeightController>();

    if (widget.initialRecord != null) {
      controller.updateRecord(widget.initialRecord!.id, _selectedWeightKg);
    } else {
      controller.addRecord(_selectedWeightKg);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 24,
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
          Text(
            widget.initialRecord == null ? 'Update Weight' : 'Edit Weight Entry',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          WeightSelector(
            initialWeightKg: _selectedWeightKg,
            onChanged: (val) => _selectedWeightKg = val,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            onPressed: _save,
            label: 'SAVE',
          ),
        ],
      ),
    );
  }
}
