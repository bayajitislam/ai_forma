import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class SparklineChart extends StatelessWidget {
  const SparklineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandTeal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width * 0.2, size.height * 0.55)
      ..lineTo(size.width * 0.45, size.height * 0.6)
      ..lineTo(size.width * 0.7, size.height * 0.35)
      ..lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
