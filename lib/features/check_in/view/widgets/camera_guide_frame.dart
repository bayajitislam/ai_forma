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
                  color: const Color(0xFff5f5f5),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
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
                  border: Border.all(color: AppColors.cardBorder, width: 4),
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
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 6;
    const dashSpace = 4;
    double y = 0;

    final centerX = size.width / 2;

    // Dashed vertical guide line
    while (y < size.height - 12) {
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, y + dashHeight),
        paint,
      );
      y += dashHeight + dashSpace;
    }

    // Floor Stand marker at the bottom
    final floorPaint = Paint()
      ..color = AppColors.brandTeal
      ..style = PaintingStyle.fill;

    canvas.drawLine(
      Offset(centerX - 12, size.height),
      Offset(centerX + 12, size.height),
      Paint()
        ..color = AppColors.brandTeal
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    final path = Path()
      ..moveTo(centerX, size.height - 10)
      ..lineTo(centerX - 7, size.height)
      ..lineTo(centerX + 7, size.height)
      ..close();
    canvas.drawPath(path, floorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CameraViewfinderOverlay extends StatelessWidget {
  const CameraViewfinderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outer rounded frame border
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
          ),
        ),

        // Vertical Dashed Alignment Guide Line on bottom-right (matching reference design)
        Positioned(
          right: 32,
          bottom: 36,
          height: 180,
          width: 28,
          child: CustomPaint(painter: _AlignmentGuidePainter()),
        ),
      ],
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
