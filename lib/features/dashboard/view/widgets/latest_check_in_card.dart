import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';

class LatestCheckInCard extends StatefulWidget {
  const LatestCheckInCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<LatestCheckInCard> createState() => _LatestCheckInCardState();
}

class _LatestCheckInCardState extends State<LatestCheckInCard>
    with SingleTickerProviderStateMixin {
  static const String _prefKey = 'latest_scan_show_photos';

  static const List<String> _analysisImages = [
    AppImages.frontView,
    AppImages.sideView,
    AppImages.backView,
  ];

  bool _showPhotos = true;
  // ignore: unused_field
  bool _isPressed = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _loadPref();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefKey);
    if (saved != null && mounted) {
      setState(() => _showPhotos = saved);
    }
  }

  Future<void> _setShowPhotos(bool value) async {
    setState(() => _showPhotos = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _release();
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  void _onTapCancel() => _release();

  void _release() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: title + toggle
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: const Text(
                      DashboardStrings.latestScan,
                      style: AppTextStyles.dashboardMetricValue,
                    ),
                  ),
                  // "Show photos" toggle
                  GestureDetector(
                    // Absorb tap so it doesn't bubble to the card tap
                    onTap: () {}, // handled by the Switch onChanged
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _showPhotos ? 'Hide photos' : 'Show photos',
                          style: AppTextStyles.dashboardMetricLabel,
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (_) {}, // prevent card press animation
                          child: Transform.scale(
                            scale: 0.8,
                            child: Switch.adaptive(
                              value: _showPhotos,
                              onChanged: (val) {
                                HapticFeedback.selectionClick();
                                _setShowPhotos(val);
                              },
                              activeColor: AppColors.brandTealLight,

                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),
              Text(
                DashboardStrings.latestAnalysisDate,
                style: AppTextStyles.dashboardMetricLabel,
              ),
              const SizedBox(height: 16),

              // Photo area with fade transition
              GestureDetector(
                onTap: () => _showPhotos
                    ? Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ScanDetailView(date: "May 18 2025"),
                        ),
                      )
                    : null,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _showPhotos
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
                    return Stack(
                      children: [
                        Positioned.fill(key: bottomKey, child: bottomChild),
                        topChild,
                      ],
                    );
                  },
                  firstChild: Row(
                    children: List.generate(_analysisImages.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index < _analysisImages.length - 1 ? 10 : 0,
                          ),
                          child: _AnalysisImage(
                            imagePath: _analysisImages[index],
                          ),
                        ),
                      );
                    }),
                  ),
                  secondChild: _PrivacyPlaceholder(),
                ),
              ),
              // end Photo area
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 15,
                    color: AppColors.brandTeal,
                  ),

                  const SizedBox(width: 4),
                  Text(
                    DashboardStrings.imageGenerate,
                    style: AppTextStyles.dashboardMetricLabel.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisImage extends StatelessWidget {
  const _AnalysisImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 152,
        color: AppColors.progressInactive,
        child: Image.asset(
          imagePath,
          height: 152,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PrivacyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.progressInactive,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.progressInactive, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_off_outlined,
            size: 28,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            'Photos Hidden',
            style: AppTextStyles.dashboardMetricValue.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Tap the toggle above to display your latest scan photos.',
              textAlign: TextAlign.center,
              style: AppTextStyles.dashboardMetricLabel.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
