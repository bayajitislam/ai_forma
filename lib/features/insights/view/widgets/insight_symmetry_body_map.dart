import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';

class InsightSymmetryBodyMap extends StatelessWidget {
  const InsightSymmetryBodyMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 288,
          width: 176,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  AppImages.frontView,
                  fit: BoxFit.cover,
                  height: 288,
                  width: 176,
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _SymmetryLinePainter(),
                ),
              ),
              const Positioned(
                left: 16,
                bottom: 12,
                child: Text(
                  InsightsStrings.symmetryLeft,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Positioned(
                right: 16,
                bottom: 12,
                child: Text(
                  InsightsStrings.symmetryRight,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _LegendDot(
              color: AppColors.brandTealDark,
              label: InsightsStrings.symmetryExcellent,
            ),
            SizedBox(width: 16),
            _LegendDot(
              color: AppColors.brandTealLight,
              label: InsightsStrings.symmetryGood,
            ),
            SizedBox(width: 16),
            _LegendDot(
              color: AppColors.insightWarning,
              label: InsightsStrings.symmetryNeedsAttention,
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SymmetryLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandTealDark
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, 16),
      Offset(size.width / 2, size.height - 16),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
