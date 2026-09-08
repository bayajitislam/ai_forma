import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_navbar.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────
//  Measurement point descriptors (all positions are 0–1 relative)
// ─────────────────────────────────────────────────────────────
class _MeasurementPoint {
  const _MeasurementPoint({
    required this.label,
    required this.position,
    required this.isLeft,
  });
  final String label;
  final Offset position; // dx/dy as fraction of widget width/height
  final bool isLeft;
}

const _kPoints = <_MeasurementPoint>[
  _MeasurementPoint(label: 'MUSCLE\nDEVELOPMENT',  position: Offset(0.25, 0.17), isLeft: true),
  _MeasurementPoint(label: 'BODY\nCOMPOSITION',     position: Offset(0.75, 0.17), isLeft: false),
  _MeasurementPoint(label: 'POSTURE\nBALANCE',       position: Offset(0.30, 0.42), isLeft: true),
  _MeasurementPoint(label: 'SYMMETRY\nANALYSIS',     position: Offset(0.72, 0.44), isLeft: false),
  _MeasurementPoint(label: 'FAT\nDISTRIBUTION',     position: Offset(0.28, 0.65), isLeft: true),
  _MeasurementPoint(label: 'PHYSIQUE\nSCORE',        position: Offset(0.72, 0.68), isLeft: false),
];

// ─────────────────────────────────────────────────────────────
//  Scan-line CustomPainter
// ─────────────────────────────────────────────────────────────
class _ScanLinePainter extends CustomPainter {
  const _ScanLinePainter({required this.progress});
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
  bool shouldRepaint(_ScanLinePainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────
//  Body scan animation widget
// ─────────────────────────────────────────────────────────────
class _BodyScanAnimation extends StatefulWidget {
  const _BodyScanAnimation();

  @override
  State<_BodyScanAnimation> createState() => _BodyScanAnimationState();
}

class _BodyScanAnimationState extends State<_BodyScanAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _scanController;
  late final List<AnimationController> _dotControllers;
  double _scanProgress = 0;
  // Once true, dots are permanently visible and never hidden again
  bool _initialRevealDone = false;

  @override
  void initState() {
    super.initState();
    // Ping-pong: top → bottom → top → bottom…
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )
      ..addListener(_onScanTick)
      ..addStatusListener(_onScanStatus)
      ..repeat(reverse: true);

    _dotControllers = List.generate(
      _kPoints.length,
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

    // Only reveal/hide during the initial reveal pass
    if (!_initialRevealDone && goingDown) {
      for (var i = 0; i < _kPoints.length; i++) {
        final dotY = _kPoints[i].position.dy;
        final ctrl = _dotControllers[i];
        if (current >= dotY && ctrl.status == AnimationStatus.dismissed) {
          ctrl.forward();
        }
      }
    }
    // Once _initialRevealDone is true, dots are always shown — no action needed
  }

  void _onScanStatus(AnimationStatus status) {
    // First time the scan reaches the bottom: mark reveal complete
    // and ensure every dot is fully visible
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

        // Scale dot/label sizes proportionally to widget width.
        // Reference width ~300 → base values; clamped for very small/large screens.
        final scale = (w / 300).clamp(0.7, 1.4);
        final dotSize = (8.0 * scale).clamp(6.0, 12.0);
        final tickLen = (14.0 * scale).clamp(10.0, 20.0);
        final labelW = (68.0 * scale).clamp(52.0, 90.0);
        final labelFontSize = (8.0 * scale).clamp(6.5, 10.5); // +1px from 7.0 base
        final labelOffset = labelW + 2; // how far left/right label sits from dot

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Silhouette at natural charcoal-on-white colours
            Positioned.fill(
              child: Image.asset(
                'assets/app/body_silhouette.png',
                fit: BoxFit.contain,
              ),
            ),

            // Scan line
            Positioned.fill(
              child: ClipRect(
                child: CustomPaint(
                  painter: _ScanLinePainter(progress: _scanProgress),
                ),
              ),
            ),

            // Measurement dots + connector ticks + labels
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

    for (var i = 0; i < _kPoints.length; i++) {
      final pt = _kPoints[i];
      final cx = pt.position.dx * w;
      final cy = pt.position.dy * h;
      final half = dotSize / 2;

      final anim = CurvedAnimation(
        parent: _dotControllers[i],
        curve: Curves.easeOut,
      );

      // ── Dot ─────────────────────────────────────────────────
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

      // ── Connector tick ───────────────────────────────────────
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

      // ── Label ────────────────────────────────────────────────
      // For left labels: place label to the LEFT of the tick end, clamped at 0.
      // For right labels: place label to the RIGHT of the tick end.
      final double rawLeft = pt.isLeft
          ? tickEndX - labelW
          : tickEndX;
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

// ─────────────────────────────────────────────────────────────
//  Main View
// ─────────────────────────────────────────────────────────────
class AnalysisCompleteView extends StatefulWidget {
  const AnalysisCompleteView({super.key});

  @override
  State<AnalysisCompleteView> createState() => _AnalysisCompleteViewState();
}

class _AnalysisCompleteViewState extends State<AnalysisCompleteView> {
  bool _isFirstScan = false;

  @override
  void initState() {
    super.initState();
    // Dispose CheckInController and release memory/camera resources when reaching this view
    if (Get.isRegistered<CheckInController>()) {
      Get.delete<CheckInController>(force: true);
    }
    _loadScanContext();
  }

  Future<void> _loadScanContext() async {
    // If isFirstCheckInCompleted() returns false → this IS the first scan.
    final alreadyCompleted = await AuthStorage.isFirstCheckInCompleted();
    if (mounted) {
      setState(() => _isFirstScan = !alreadyCompleted);
    }
  }

  Future<void> _navigateToAppShell() async {
    await AuthStorage.setFirstCheckInCompleted(true);
    Get.offAllNamed(RoutesName.appShell, arguments: AppNavItem.insights);
  }

  String get _subtitle => _isFirstScan
      ? CheckInStrings.completeSubtitleFirstScan
      : CheckInStrings.completeSubtitleRepeatScan;

  @override
  Widget build(BuildContext context) {
    // ── Responsive tokens ──────────────────────────────────────
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final screenW = mq.size.width;

    // Scale factor relative to a 390px-wide reference phone
    final wScale = (screenW / 390).clamp(0.75, 1.5);
    // Scale factor relative to a 844px-tall reference phone (iPhone 14)
    final hScale = (screenH / 844).clamp(0.65, 1.4);

    // Responsive spacing
    final gapSm = (8.0 * hScale).clamp(4.0, 14.0);
    final gapMd = (12.0 * hScale).clamp(6.0, 18.0);
    final hPad  = (16.0 * wScale).clamp(12.0, 28.0);

    // Responsive card text
    final titleSize    = (22.0 * wScale).clamp(17.0, 28.0);
    final subtitleSize = (14.0 * wScale).clamp(12.0, 17.0);
    final cardPadV     = (16.0 * hScale).clamp(12.0, 24.0);
    final cardPadH     = (20.0 * wScale).clamp(14.0, 28.0);

    // On tablets / large screens centre + constrain max width
    final maxW = math.min(screenW, 560.0);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _navigateToAppShell();
      },
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  children: [
                    // Header
                    const CheckInHeader(
                      isTitle: true,
                      title: CheckInStrings.result,
                    ),
                    SizedBox(height: gapSm),

                    // ── Body scan animation — fills remaining vertical space ──
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: hPad * 0.75,
                          vertical: (14.0 * hScale).clamp(10.0, 20.0),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandTealLight
                                  .withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const _BodyScanAnimation(),
                      ),
                    ),

                    SizedBox(height: gapMd),

                    // ── Info card — always pinned at bottom ──────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: cardPadH,
                        vertical: cardPadV,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandTealLight
                                .withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ANALYSIS COMPLETE',
                            style: AppTextStyles.dashboardSectionLabel,
                          ),
                          SizedBox(height: gapSm * 0.6),
                          Text(
                            CheckInStrings.completeTitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authSectionTitle
                                .copyWith(fontSize: titleSize),
                          ),
                          SizedBox(height: gapSm * 0.75),
                          Text(
                            _subtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authBody
                                .copyWith(fontSize: subtitleSize),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: gapMd),

                    // ── CTA ──────────────────────────────────────────────────
                    PrimaryButton(
                      onPressed: _navigateToAppShell,
                      label: CheckInStrings.viewResults,
                    ),
                    SizedBox(height: gapMd),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
