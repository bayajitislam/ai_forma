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
  static const double _minKg = 30.0;
  static const double _maxKg = 200.0;
  static const double _stepKg = 0.1;

  static const double _minLb = 66.0;
  static const double _maxLb = 440.0;
  static const double _stepLb = 0.2;

  bool _isKg = true;
  late FixedExtentScrollController _controller;
  late int _currentIndex;

  double get _currentStep => _isKg ? _stepKg : _stepLb;
  double get _minVal => _isKg ? _minKg : _minLb;
  double get _maxVal => _isKg ? _maxKg : _maxLb;

  int get _itemCount => ((_maxVal - _minVal) / _currentStep).round() + 1;

  double _indexToValue(int index) {
    return _minVal + (index * _currentStep);
  }

  int _valueToIndex(double value) {
    final clamped = value.clamp(_minVal, _maxVal);
    return ((clamped - _minVal) / _currentStep).round();
  }

  double get _currentValueInUnit => _indexToValue(_currentIndex);

  double get _currentValueInKg {
    if (_isKg) return _currentValueInUnit;
    return _lbToKg(_currentValueInUnit);
  }

  double _kgToLb(double kg) => kg * 2.20462;
  double _lbToKg(double lb) => lb / 2.20462;

  @override
  void initState() {
    super.initState();
    final initialKg = widget.initialWeightKg.clamp(_minKg, _maxKg);
    _currentIndex = _valueToIndex(initialKg);
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
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
      if (_isKg) {
        _currentIndex = _valueToIndex(currentKg);
      } else {
        final lbVal = _kgToLb(currentKg);
        _currentIndex = _valueToIndex(lbVal);
      }
      _controller.jumpToItem(_currentIndex);
    });
    widget.onChanged(_currentValueInKg);
  }

  void _stepBy(int direction) {
    final targetIndex = (_currentIndex + direction).clamp(0, _itemCount - 1);
    if (targetIndex != _currentIndex) {
      _controller.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitLabel = _isKg ? 'kg' : 'lb';
    final stepText = _isKg ? '0.1' : '0.2';

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
            // Minus Button Shortcut
            _buildStepButton(
              isPlus: false,
              stepText: '-$stepText',
              onPressed: () => _stepBy(-1),
            ),

            const SizedBox(width: 16),

            // Center Wheel Picker Box
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

                  // ListWheelScrollView
                  ListWheelScrollView.useDelegate(
                    controller: _controller,
                    itemExtent: 44,
                    diameterRatio: 1.5,
                    perspective: 0.003,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      widget.onChanged(_currentValueInKg);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _itemCount,
                      builder: (context, index) {
                        final val = _indexToValue(index);
                        final isSelected = index == _currentIndex;

                        return Center(
                          child: isSelected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      val.toStringAsFixed(1),
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
                                  val.toStringAsFixed(1),
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

            // Plus Button Shortcut
            _buildStepButton(
              isPlus: true,
              stepText: '+$stepText',
              onPressed: () => _stepBy(1),
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
