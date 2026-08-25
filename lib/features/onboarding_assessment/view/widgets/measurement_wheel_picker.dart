import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';

typedef MeasurementLabelBuilder = String Function(int value);

class MeasurementWheelPicker extends StatefulWidget {
  const MeasurementWheelPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
    this.unit,
    this.labelBuilder,
  }) : assert(
         unit != null || labelBuilder != null,
         'Provide either unit or labelBuilder',
       );

  final int minValue;
  final int maxValue;
  final int initialValue;
  final String? unit;
  final MeasurementLabelBuilder? labelBuilder;
  final ValueChanged<int> onChanged;

  @override
  State<MeasurementWheelPicker> createState() => _MeasurementWheelPickerState();
}

class _MeasurementWheelPickerState extends State<MeasurementWheelPicker> {
  static const double _itemHeight = 52;
  static const int _visibleItemCount = 5;

  late final FixedExtentScrollController _controller;
  late int _selectedValue;

  bool get _isFeetUnit =>
      widget.unit?.toLowerCase() == 'ft' ||
      widget.unit?.toLowerCase() == 'feet';

  int get _effectiveMinValue {
    if (_isFeetUnit && widget.minValue < 36) {
      return widget.minValue * 12;
    }
    return widget.minValue;
  }

  int get _effectiveMaxValue {
    if (_isFeetUnit && widget.minValue < 36) {
      return widget.maxValue * 12;
    }
    return widget.maxValue;
  }

  int get _effectiveInitialValue {
    if (_isFeetUnit && widget.minValue < 36 && widget.initialValue <= 10) {
      return widget.initialValue * 12;
    }
    return widget.initialValue;
  }

  @override
  void initState() {
    super.initState();
    _selectedValue = _effectiveInitialValue.clamp(
      _effectiveMinValue,
      _effectiveMaxValue,
    );
    _controller = FixedExtentScrollController(
      initialItem: _selectedValue - _effectiveMinValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _labelFor(int value) {
    if (widget.labelBuilder != null) {
      return widget.labelBuilder!(value);
    }
    if (_isFeetUnit) {
      final feet = value ~/ 12;
      final inches = value % 12;
      return '$feet.$inches';
    }
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _effectiveMaxValue - _effectiveMinValue + 1;

    return SizedBox(
      height: _itemHeight * _visibleItemCount,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: _itemHeight,
            diameterRatio: 1.4,
            perspective: 0.003,
            useMagnifier: true,
            magnification: 1.15,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              final value = _effectiveMinValue + index;
              setState(() => _selectedValue = value);
              widget.onChanged(value);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final value = _effectiveMinValue + index;
                final isSelected = value == _selectedValue;

                return Center(
                  child: _PickerItem(
                    label: _labelFor(value),
                    unit: widget.unit,
                    isSelected: isSelected,
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 120, height: 2, color: AppColors.brandTeal),
                SizedBox(height: _itemHeight - 4),
                Container(width: 120, height: 2, color: AppColors.brandTeal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerItem extends StatelessWidget {
  const _PickerItem({
    required this.label,
    required this.unit,
    required this.isSelected,
  });

  final String label;
  final String? unit;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppColors.brandTeal
        : AppColors.textSecondary.withValues(alpha: 0.45);

    if (!isSelected || unit == null) {
      return Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: isSelected ? 32 : 22,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: color,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          ' $unit',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
