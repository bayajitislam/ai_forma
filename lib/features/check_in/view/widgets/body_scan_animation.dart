import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';

// ─────────────────────────────────────────────────────────────
//  Measurement point descriptors (all positions are 0–1 relative)
// ─────────────────────────────────────────────────────────────
class MeasurementPointDescriptor {
  const MeasurementPointDescriptor({
    required this.label,
    required this.position,
    required this.isLeft,
  });
  final String label;
  final Offset position; // dx/dy as fraction of widget width/height
  final bool isLeft;
}

const List<MeasurementPointDescriptor> kDefaultMeasurementPoints = [
  MeasurementPointDescriptor(
    label: CheckInStrings.pointMuscleDevelopment,
    position: Offset(0.25, 0.17),
    isLeft: true,
  ),
  MeasurementPointDescriptor(
    label: CheckInStrings.pointBodyComposition,
    position: Offset(0.75, 0.17),
    isLeft: false,
  ),
  MeasurementPointDescriptor(
    label: CheckInStrings.pointPostureBalance,
    position: Offset(0.30, 0.42),
    isLeft: true,
  ),
  MeasurementPointDescriptor(
    label: CheckInStrings.pointSymmetryAnalysis,
    position: Offset(0.72, 0.44),
    isLeft: false,
  ),
  MeasurementPointDescriptor(
    label: CheckInStrings.pointFatDistribution,
    position: Offset(0.28, 0.65),
    isLeft: true,
  ),
  MeasurementPointDescriptor(
    label: CheckInStrings.pointPhysiqueScore,
    position: Offset(0.72, 0.68),
    isLeft: false,
  ),
];

// ─────────────────────────────────────────────────────────────
//  Scan-line CustomPainter
// ─────────────────────────────────────────────────────────────
class ScanLinePainter extends CustomPainter {
  const ScanLinePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;

    // Soft glow band
    final bandH = size.height * 0.07;
    final bandRect = Rect.fromLTWH(0, y - bandH / 2, size.width, bandH);
    canvas.drawRect(
      bandRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x0000B5AD),
            Color(0x2E00B5AD),
            Color(0x5900B5AD),
            Color(0x2E00B5AD),
            Color(0x0000B5AD),
          ],
          stops: [0.0, 0.3, 0.5, 0.7, 1.0],
        ).createShader(bandRect),
    );

    // Sharp teal line
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      Paint()
        ..color = AppColors.brandTeal.withValues(alpha: 0.85)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(ScanLinePainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────
//  Body scan animation widget
// ─────────────────────────────────────────────────────────────
class BodyScanAnimation extends StatefulWidget {
  const BodyScanAnimation({
    super.key,
    this.points = kDefaultMeasurementPoints,
  });

  final List<MeasurementPointDescriptor> points;

  @override
  State<BodyScanAnimation> createState() => _BodyScanAnimationState();
}

class _BodyScanAnimationState extends State<BodyScanAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _scanController;
  late final List<AnimationController> _dotControllers;
  double _scanProgress = 0;
  // Once true, dots are permanently visible and never hidden again
  bool _initialRevealDone = false;

  @override
  void initState() {
    super.initState();
    // Ping-pong: top → bottom → top → bottom
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )
      ..addListener(_onScanTick)
      ..addStatusListener(_onScanStatus)
      ..repeat(reverse: true);

    _dotControllers = List.generate(
      widget.points.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 380),
      ),
    );
  }

  void _onScanTick() {
    if (!mounted) return;
    final prev = _scanProgress;
    final current = _scanController.value;
    final goingDown = current > prev;
    setState(() => _scanProgress = current);

    // Only reveal during the initial reveal pass
    if (!_initialRevealDone && goingDown) {
      for (var i = 0; i < widget.points.length; i++) {
        final dotY = widget.points[i].position.dy;
        final ctrl = _dotControllers[i];
        if (current >= dotY && ctrl.status == AnimationStatus.dismissed) {
          ctrl.forward();
        }
      }
    }
  }

  void _onScanStatus(AnimationStatus status) {
    if (!_initialRevealDone && status == AnimationStatus.completed) {
      _initialRevealDone = true;
      for (final ctrl in _dotControllers) {
        if (ctrl.status != AnimationStatus.completed) {
          ctrl.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final scale = (w / 300).clamp(0.7, 1.4);
        final dotSize = (8.0 * scale).clamp(6.0, 12.0);
        final tickLen = (14.0 * scale).clamp(10.0, 20.0);
        final labelW = (68.0 * scale).clamp(52.0, 90.0);
        final labelFontSize = (8.0 * scale).clamp(6.5, 10.5);
        final labelOffset = labelW + 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/app/body_silhouette.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: CustomPaint(
                  painter: ScanLinePainter(progress: _scanProgress),
                ),
              ),
            ),
            ..._buildDotWidgets(
              w: w,
              h: h,
              dotSize: dotSize,
              tickLen: tickLen,
              labelW: labelW,
              labelFontSize: labelFontSize,
              labelOffset: labelOffset,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildDotWidgets({
    required double w,
    required double h,
    required double dotSize,
    required double tickLen,
    required double labelW,
    required double labelFontSize,
    required double labelOffset,
  }) {
    final widgets = <Widget>[];

    for (var i = 0; i < widget.points.length; i++) {
      final pt = widget.points[i];
      final cx = pt.position.dx * w;
      final cy = pt.position.dy * h;
      final half = dotSize / 2;

      final anim = CurvedAnimation(
        parent: _dotControllers[i],
        curve: Curves.easeOut,
      );

      // Dot
      widgets.add(
        Positioned(
          left: cx - half,
          top: cy - half,
          child: FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: anim,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: AppColors.brandTeal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandTeal.withValues(alpha: 0.50),
                      blurRadius: dotSize * 0.9,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Connector tick
      final tickEndX = pt.isLeft ? cx - tickLen : cx + tickLen;
      widgets.add(
        Positioned(
          left: math.min(cx, tickEndX),
          top: cy,
          width: (cx - tickEndX).abs(),
          height: 1.0,
          child: FadeTransition(
            opacity: anim,
            child: Container(
              color: AppColors.brandTeal.withValues(alpha: 0.45),
            ),
          ),
        ),
      );

      // Label
      final double rawLeft = pt.isLeft ? tickEndX - labelW : tickEndX;
      final double labelLeft = rawLeft.clamp(0.0, w - labelW);

      widgets.add(
        Positioned(
          left: labelLeft,
          top: cy - labelFontSize * 1.35,
          width: labelW,
          child: FadeTransition(
            opacity: anim,
            child: Text(
              pt.label,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF546E7A),
                letterSpacing: 0.4,
                height: 1.35,
              ),
              textAlign: pt.isLeft ? TextAlign.right : TextAlign.left,
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
