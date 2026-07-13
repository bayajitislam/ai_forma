import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';

class VisualScanCompareSlider extends StatefulWidget {
  const VisualScanCompareSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    required this.beforeLabel,
    required this.afterLabel,
  });

  final String beforeImage;
  final String afterImage;
  final String beforeLabel;
  final String afterLabel;

  @override
  State<VisualScanCompareSlider> createState() =>
      _VisualScanCompareSliderState();
}

class _VisualScanCompareSliderState extends State<VisualScanCompareSlider> {
  double _position = 0.5;

  void _updatePosition(Offset localPosition, double width) {
    setState(() {
      _position = (localPosition.dx / width).clamp(0.05, 0.95);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final dividerX = width * _position;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            _updatePosition(details.localPosition, width);
          },
          onTapDown: (details) {
            _updatePosition(details.localPosition, width);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.afterImage,
                fit: BoxFit.contain,
                width: width,
                height: height,
              ),
              ClipRect(
                clipper: _BeforeImageClipper(position: _position),
                child: Image.asset(
                  widget.beforeImage,
                  fit: BoxFit.contain,
                  width: width,
                  height: height,
                ),
              ),
              Positioned(
                left: dividerX - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: AppColors.surface,
                ),
              ),
              Positioned(
                left: (dividerX - 58).clamp(12.0, width - 128),
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandTealDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    InsightsStrings.slideToCompare,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: dividerX - 22,
                top: height / 2 - 22,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: AppIcon(
                      icon: AppIcons.arrowLeftRight,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 28,
                child: _DatePill(label: widget.beforeLabel),
              ),
              Positioned(
                right: 20,
                bottom: 28,
                child: _DatePill(label: widget.afterLabel),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.visualScanDatePill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
        ),
      ),
    );
  }
}

class _BeforeImageClipper extends CustomClipper<Rect> {
  _BeforeImageClipper({required this.position});

  final double position;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(covariant _BeforeImageClipper oldClipper) {
    return oldClipper.position != position;
  }
}
