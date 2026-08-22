import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;

  const AppShimmer({
    super.key,
    required this.child,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _ScanLinePainter(
            progress: _controller.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress; // 0.0 (top) to 1.0 (bottom)

  _ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;

    // Glowing laser line
    final linePaint = Paint()
      ..color = AppColors.brandTeal
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.brandTeal.withValues(alpha: 0.3),
          AppColors.brandTeal.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTRB(0, (y - 30).clamp(0, size.height), size.width, y));

    // Draw scan line
    canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    // Draw trailing glow behind scan line
    if (y > 0) {
      canvas.drawRect(
        Rect.fromLTRB(0, (y - 30).clamp(0, size.height), size.width, y),
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class AppShimmerImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppShimmerImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget scanPlaceholder = AppShimmer(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.iconBackground,
          borderRadius: borderRadius,
        ),
      ),
    );

    Widget content = Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return scanPlaceholder;
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return scanPlaceholder;
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.iconBackground,
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.brandTeal,
                size: 20,
              ),
            );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }
}
