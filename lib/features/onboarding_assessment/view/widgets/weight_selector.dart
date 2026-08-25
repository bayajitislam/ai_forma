import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';

class WeightSelector extends StatefulWidget {
  const WeightSelector({
    super.key,
    required this.initialWeightKg,
    required this.onChanged,
    this.showUnitToggle = true,
  });

  final double initialWeightKg;
  final ValueChanged<double> onChanged; // Emits weight in kg
  final bool showUnitToggle;

  @override
  State<WeightSelector> createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  static const int _minKg = 30;
  static const int _maxKg = 200;

  static const int _minLb = 66;
  static const int _maxLb = 440;

  bool _isKg = true;
  late FixedExtentScrollController _controller;

  late int _integerVal;
  late int _decimalTenths; // 0 to 9 representing .0 to .9

  int get _minInt => _isKg ? _minKg : _minLb;
  int get _maxInt => _isKg ? _maxKg : _maxLb;
  int get _itemCount => _maxInt - _minInt + 1;

  double get _currentValueInUnit {
    final val = _integerVal + (_decimalTenths / 10.0);
    return double.parse(val.toStringAsFixed(1));
  }

  double get _currentValueInKg {
    if (_isKg) return _currentValueInUnit;
    return double.parse((_currentValueInUnit / 2.20462).toStringAsFixed(1));
  }

  @override
  void initState() {
    super.initState();
    final initialKg = widget.initialWeightKg.clamp(_minKg.toDouble(), _maxKg.toDouble());
    _integerVal = initialKg.floor();
    _decimalTenths = ((initialKg * 10).round() % 10);
    final initialIndex = (_integerVal - _minInt).clamp(0, _itemCount - 1);
    _controller = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchUnit(bool isKg) {
    if (_isKg == isKg) return;

    final currentKg = _currentValueInKg;
    setState(() {
      _isKg = isKg;
      double newUnitVal;
      if (_isKg) {
        newUnitVal = currentKg.clamp(_minKg.toDouble(), _maxKg.toDouble());
      } else {
        newUnitVal = (currentKg * 2.20462).clamp(_minLb.toDouble(), _maxLb.toDouble());
      }
      _integerVal = newUnitVal.floor();
      _decimalTenths = ((newUnitVal * 10).round() % 10);

      final targetIndex = (_integerVal - _minInt).clamp(0, _itemCount - 1);
      if (_controller.hasClients) {
        _controller.jumpToItem(targetIndex);
      }
    });
    widget.onChanged(_currentValueInKg);
  }

  void _stepByTenths(int stepTenths) {
    int newTenths = _decimalTenths + stepTenths;
    int newInt = _integerVal;

    if (newTenths < 0) {
      newTenths += 10;
      newInt -= 1;
    } else if (newTenths > 9) {
      newTenths -= 10;
      newInt += 1;
    }

    if (newInt < _minInt) {
      newInt = _minInt;
      newTenths = 0;
    } else if (newInt > _maxInt) {
      newInt = _maxInt;
      newTenths = 9;
    }

    final int targetIndex = (newInt - _minInt).clamp(0, _itemCount - 1);
    setState(() {
      _integerVal = newInt;
      _decimalTenths = newTenths;
    });

    if (_controller.hasClients && _controller.selectedItem != targetIndex) {
      _controller.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
    widget.onChanged(_currentValueInKg);
  }

  @override
  Widget build(BuildContext context) {
    final unitLabel = _isKg ? 'kg' : 'lb';
    final stepText = _isKg ? '0.1' : '0.2';
    final stepTenths = _isKg ? 1 : 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showUnitToggle) ...[
          _buildUnitToggle(),
          const SizedBox(height: 24),
        ],

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Minus Button Shortcut (Decimal Adjust)
            _buildStepButton(
              isPlus: false,
              stepText: '-$stepText',
              onPressed: () => _stepByTenths(-stepTenths),
            ),

            const SizedBox(width: 16),

            // Center Wheel Picker Box (Whole Numbers Wheel)
            Container(
              width: 170,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0F0F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Highlight pill background for center selected row
                  Container(
                    width: 154,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F7F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  // ListWheelScrollView for Whole Numbers
                  ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 44,
                    diameterRatio: 1.5,
                    perspective: 0.003,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      final newInt = _minInt + index;
                      if (newInt != _integerVal) {
                        setState(() {
                          _integerVal = newInt;
                        });
                        widget.onChanged(_currentValueInKg);
                      }
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _itemCount,
                      builder: (context, index) {
                        final intVal = _minInt + index;
                        final isSelected = intVal == _integerVal;

                        return Center(
                          child: isSelected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '$_integerVal.$_decimalTenths',
                                      style: const TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      unitLabel,
                                      style: const TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '$intVal',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.45),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Plus Button Shortcut (Decimal Adjust)
            _buildStepButton(
              isPlus: true,
              stepText: '+$stepText',
              onPressed: () => _stepByTenths(stepTenths),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      width: 120,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _switchUnit(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: _isKg ? AppColors.brandTeal : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'KG',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _isKg ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _switchUnit(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: !_isKg ? AppColors.brandTeal : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'LB',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: !_isKg ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required bool isPlus,
    required String stepText,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isPlus ? Icons.add : Icons.remove,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          stepText,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
