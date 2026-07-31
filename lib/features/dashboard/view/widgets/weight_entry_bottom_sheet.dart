import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';
import 'package:ai_forma/features/assessment/view/widgets/assessment_unit_toggle.dart';
import 'package:ai_forma/features/assessment/view/widgets/measurement_wheel_picker.dart';
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
  int _unitIndex = 0;
  late int _weightKg;
  late int _weightLb;

  bool get _isKg => _unitIndex == 0;

  @override
  void initState() {
    super.initState();
    double startingKg = widget.initialRecord?.weightKg ?? widget.initialWeightKg ?? AssessmentStrings.defaultWeightKg.toDouble();
    _weightKg = startingKg.round();
    _weightLb = _kgToLb(_weightKg);
  }

  void _onUnitChanged(int index) {
    if (index == _unitIndex) return;

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

  void _save() {
    final weightToSave = _isKg ? _weightKg.toDouble() : _lbToKg(_weightLb).toDouble();
    final controller = Get.find<WeightController>();

    if (widget.initialRecord != null) {
      controller.updateRecord(widget.initialRecord!.id, weightToSave);
    } else {
      controller.addRecord(weightToSave);
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
            style: AppTextStyles.primaryButton,
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
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
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
