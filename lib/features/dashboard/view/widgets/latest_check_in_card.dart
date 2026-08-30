import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:intl/intl.dart';

class LatestCheckInCard extends StatefulWidget {
  const LatestCheckInCard({super.key, this.onTap, this.analysisData});

  final VoidCallback? onTap;
  final HomeLatestAnalysisModel? analysisData;

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

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'May 18 2025';
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('MMMM d, yyyy').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _formatDate(widget.analysisData?.scanDate);
    final viewsList = widget.analysisData?.views ?? [];

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          final scanId = widget.analysisData?.scanId;
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => ScanDetailView(scanId: scanId ?? ''),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DashboardStrings.latestScan,
                          style: AppTextStyles.dashboardMetricLabel,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayDate,
                          style: AppTextStyles.dashboardMetricValue.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Privacy toggle switch
                  Semantics(
                    label: 'Toggle photos visibility',
                    value: _showPhotos ? 'Photos visible' : 'Photos hidden',
                    child: GestureDetector(
                      onTap: () => _setShowPhotos(!_showPhotos),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showPhotos
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 15,
                            color: _showPhotos
                                ? AppColors.brandTeal
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 32,
                            height: 18,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: _showPhotos
                                  ? AppColors.brandTeal
                                  : const Color(0xFFD1D5DB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              alignment: _showPhotos
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x29000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Animated CrossFade for Photos vs Privacy placeholder
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
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
                  children: viewsList.isNotEmpty
                      ? List.generate(viewsList.length, (index) {
                          final view = viewsList[index];
                          final url = view.thumbUrl ?? view.imageUrl;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < viewsList.length - 1 ? 10 : 0,
                              ),
                              child: _AnalysisImage(
                                imageUrl: url,
                                fallbackAsset: _analysisImages[index % _analysisImages.length],
                              ),
                            ),
                          );
                        })
                      : List.generate(_analysisImages.length, (index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < _analysisImages.length - 1 ? 10 : 0,
                              ),
                              child: _AnalysisImage(
                                fallbackAsset: _analysisImages[index],
                              ),
                            ),
                          );
                        }),
                ),
                secondChild: _PrivacyPlaceholder(),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
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
  const _AnalysisImage({this.imageUrl, required this.fallbackAsset});

  final String? imageUrl;
  final String fallbackAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 152,
        color: AppColors.progressInactive,
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? AppCachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.contain,
                height: 152,
                width: double.infinity,
                errorWidget: Image.asset(
                  fallbackAsset,
                  height: 152,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                fallbackAsset,
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
