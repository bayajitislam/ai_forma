import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class CameraGuideFrame extends StatelessWidget {
  const CameraGuideFrame({
    super.key,
    required this.imagePath,
    this.showAlignmentGuide = true,
  });

  final String imagePath;
  final bool showAlignmentGuide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      width: double.infinity,
      child: Stack(
        children: [
          // Layer 9 — image + alignment guide
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: AppColors.surface,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    height: 480,
                    width: double.infinity,
                  ),
                ),
                if (showAlignmentGuide)
                  Positioned(
                    right: 32,
                    top: 40,
                    bottom: 40,
                    child: CustomPaint(
                      size: const Size(24, 200),
                      painter: _AlignmentGuidePainter(),
                    ),
                  ),
              ],
            ),
          ),
          // Layer 10 — border on top
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlignmentGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandTeal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 6;
    const dashSpace = 4;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + dashSpace;
    }

    final dotPaint = Paint()
      ..color = AppColors.brandTeal
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, 0), 4, dotPaint);
    canvas.drawCircle(Offset(size.width / 2, size.height), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CameraViewfinderOverlay extends StatelessWidget {
  const CameraViewfinderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        height: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.brandTealDark, width: 2),
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppColors.onPrimary.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CameraShutterButton extends StatelessWidget {
  const CameraShutterButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.onPrimary, width: 4),
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.onPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class CameraActionButton extends StatelessWidget {
  const CameraActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon: icon, size: 22, color: AppColors.onPrimary),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
