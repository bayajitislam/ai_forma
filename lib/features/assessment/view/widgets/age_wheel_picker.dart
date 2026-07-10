import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';

class AgeWheelPicker extends StatefulWidget {
  const AgeWheelPicker({
    super.key,
    required this.minAge,
    required this.maxAge,
    required this.initialAge,
    required this.onChanged,
  });

  final int minAge;
  final int maxAge;
  final int initialAge;
  final ValueChanged<int> onChanged;

  @override
  State<AgeWheelPicker> createState() => _AgeWheelPickerState();
}

class _AgeWheelPickerState extends State<AgeWheelPicker> {
  static const double _itemHeight = 52;
  static const int _visibleItemCount = 5;

  late final FixedExtentScrollController _controller;
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.initialAge.clamp(widget.minAge, widget.maxAge);
    _controller = FixedExtentScrollController(
      initialItem: _selectedAge - widget.minAge,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.maxAge - widget.minAge + 1;

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
              final age = widget.minAge + index;
              setState(() => _selectedAge = age);
              widget.onChanged(age);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final age = widget.minAge + index;
                final isSelected = age == _selectedAge;

                return Center(
                  child: Text(
                    '$age',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: isSelected ? 32 : 22,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.brandTeal
                          : AppColors.textSecondary.withValues(alpha: 0.45),
                    ),
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 2,
                  color: AppColors.brandTeal,
                ),
                SizedBox(height: _itemHeight - 4),
                Container(
                  width: 96,
                  height: 2,
                  color: AppColors.brandTeal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
