import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_shimmer.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/models/timeline_scan_detail_model.dart';

class ScanDetailView extends StatefulWidget {
  final String scanId;
  final String? date;

  const ScanDetailView({
    super.key,
    this.scanId = '',
    this.date,
  });

  @override
  State<ScanDetailView> createState() => _ScanDetailViewState();
}

class _ScanDetailViewState extends State<ScanDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (Get.isRegistered<TimelineController>()) {
      Get.find<TimelineController>().fetchScanDetail(widget.scanId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPhoto(int totalPhotos) {
    if (totalPhotos == 0) return;
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % totalPhotos;
    });
  }

  void _previousPhoto(int totalPhotos) {
    if (totalPhotos == 0) return;
    setState(() {
      _currentPhotoIndex =
          (_currentPhotoIndex - 1 + totalPhotos) % totalPhotos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TimelineController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Center(child: AppBrandText(height: 22, width: 120)),
        actions: const [
          SizedBox(width: 48),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.brandTeal,
          indicatorWeight: 3,
          labelColor: AppColors.brandTeal,
          unselectedLabelColor: AppColors.textSecondary,
          dividerColor: AppColors.cardBorder,
          labelStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Photos'),
          ],
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isScanDetailLoading.value;
        final error = controller.scanDetailError.value;
        final detail = controller.scanDetailData.value;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.brandTeal),
          );
        }

        if (error.isNotEmpty && detail == null) {
          return Center(
            child: Text(
              error,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildSummaryTab(detail),
            _buildPhotosTab(detail),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryTab(TimelineScanDetailResponseModel? detail) {
    final summary = detail?.summary;
    final comparison = detail?.comparison;

    final bodyFatVal = summary?.bodyFat?.value != null
        ? '${summary!.bodyFat!.value}%'
        : '18.2%';
    final bodyFatChange = summary?.bodyFat?.change;

    final muscleVal = summary?.muscle?.value != null
        ? '${summary!.muscle!.value} kg'
        : '71.5 kg';
    final muscleChange = summary?.muscle?.change;

    final weightVal = summary?.weight?.value != null
        ? '${summary!.weight!.value} kg'
        : '87.4 kg';
    final weightChange = summary?.weight?.change;

    final momentumScore = summary?.momentum?.score ?? 82;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetricCard(
            label: 'Body Fat',
            value: bodyFatVal,
            trendWidget: bodyFatChange != null
                ? _buildTrendBadge(bodyFatChange, isPositive: true)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            label: 'Lean Muscle',
            value: muscleVal,
            trendWidget: muscleChange != null
                ? _buildTrendBadge(muscleChange, isPositive: true)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            label: 'Weight',
            value: weightVal,
            trendWidget: weightChange != null
                ? _buildTrendBadge(weightChange, isPositive: true)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          _buildMetricCard(
            label: 'Momentum',
            value: '$momentumScore/100',
            trendWidget: const SizedBox.shrink(),
          ),
          if (comparison != null && comparison.then != null) ...[
            const SizedBox(height: 24),
            Text(
              comparison.title.isNotEmpty ? comparison.title : 'Then vs Now',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cardBorder.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          comparison.then?.scanDate ?? '',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'PREVIOUS',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.brandTeal,
                    size: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          comparison.now?.scanDate ?? '',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'THIS SCAN',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotosTab(TimelineScanDetailResponseModel? detail) {
    final views = detail?.photos?.views ?? [];
    final mainTitle = detail?.photos?.title ?? 'Body Scan';

    if (views.isEmpty) {
      return const Center(
        child: Text(
          'No photos available for this scan.',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final safeIndex =
        _currentPhotoIndex >= views.length ? 0 : _currentPhotoIndex;
    final photo = views[safeIndex];
    final imageUrl = photo.imageUrl ?? photo.thumbUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Sub-header info
          Text(
            detail?.scanDate ?? widget.date ?? '',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${safeIndex + 1} of ${views.length}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Main Image Preview with overlaid arrows
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? AppShimmerImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            errorWidget: Image.asset(
                              AppImages.frontView,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppImages.frontView,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                // Left arrow
                if (safeIndex > 0)
                  Positioned(
                    left: 0,
                    child: _buildArrowButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onPressed: () => _previousPhoto(views.length),
                    ),
                  ),
                // Right arrow
                if (safeIndex < views.length - 1)
                  Positioned(
                    right: 0,
                    child: _buildArrowButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: () => _nextPhoto(views.length),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Caption label
          Text(
            mainTitle,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            photo.label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              views.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == safeIndex ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == safeIndex
                      ? AppColors.brandTeal
                      : AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.brandTeal,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required Widget trendWidget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          trendWidget,
        ],
      ),
    );
  }

  Widget _buildTrendBadge(String label, {required bool isPositive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.insightBadgePositiveBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.brandTealDark,
        ),
      ),
    );
  }
}