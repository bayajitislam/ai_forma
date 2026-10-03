import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:ai_forma/core/widgets/app_loader.dart';
import 'package:ai_forma/features/timeline/constants/timeline_strings.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/models/timeline_scan_detail_model.dart';
import 'package:ai_forma/features/timeline/view/widgets/scan_detail_arrow_button.dart';
import 'package:ai_forma/features/timeline/view/widgets/scan_detail_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanDetailView extends StatefulWidget {
  final String scanId;
  final String? date;

  const ScanDetailView({super.key, this.scanId = '', this.date});

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
      _currentPhotoIndex = (_currentPhotoIndex - 1 + totalPhotos) % totalPhotos;
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
          onPressed: () => Get.back(),
        ),
        title: const Center(child: AppBrandText(height: 22, width: 120)),
        actions: const [SizedBox(width: 48)],
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
            Tab(text: TimelineStrings.summaryTab),
            Tab(text: TimelineStrings.photosTab),
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
          children: [_buildSummaryTab(detail), _buildPhotosTab(detail)],
        );
      }),
    );
  }

  Widget _buildSummaryTab(TimelineScanDetailResponseModel? detail) {
    final summary = detail?.summary;
    final comparison = detail?.comparison;

    final bodyFatVal =
        summary?.bodyFat?.value != null ? '${summary!.bodyFat!.value}%' : '18.2%';
    final bodyFatChange = summary?.bodyFat?.change;

    final muscleVal =
        summary?.muscle?.value != null ? '${summary!.muscle!.value} kg' : '71.5 kg';
    final muscleChange = summary?.muscle?.change;

    final weightVal =
        summary?.weight?.value != null ? '${summary!.weight!.value} kg' : '87.4 kg';
    final weightChange = summary?.weight?.change;

    final momentumScore = summary?.momentum?.score ?? 82;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            TimelineStrings.scanDetailOverview,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ScanDetailMetricCard(
            label: TimelineStrings.bodyFatLabel,
            value: bodyFatVal,
            trendWidget: bodyFatChange != null
                ? ScanDetailTrendBadge(label: bodyFatChange, isPositive: true)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          ScanDetailMetricCard(
            label: TimelineStrings.leanMuscleLabel,
            value: muscleVal,
            trendWidget: muscleChange != null
                ? ScanDetailTrendBadge(label: muscleChange, isPositive: true)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          ScanDetailMetricCard(
            label: TimelineStrings.weightLabel,
            value: weightVal,
            trendWidget: weightChange != null
                ? ScanDetailTrendBadge(label: weightChange, isPositive: true)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          ScanDetailMetricCard(
            label: TimelineStrings.momentumLabel,
            value: '$momentumScore/100',
            trendWidget: const SizedBox.shrink(),
          ),
          if (comparison != null && comparison.then != null) ...[
            const SizedBox(height: 24),
            Text(
              comparison.title.isNotEmpty
                  ? comparison.title
                  : TimelineStrings.thenVsNow,
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
                color: AppColors.insightConsistencyIncompleteBg.withValues(
                  alpha: 0.5,
                ),
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
                          AppDateFormatter.toDayMonthYear(
                            comparison.then?.scanDate,
                          ),
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          TimelineStrings.previous,
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
                          AppDateFormatter.toDayMonthYear(
                            comparison.now?.scanDate,
                          ),
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          TimelineStrings.thisScan,
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
    final mainTitle = detail?.photos?.title ?? TimelineStrings.defaultScanTitle;

    if (views.isEmpty) {
      return const Center(
        child: Text(
          TimelineStrings.noPhotos,
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

    final String fallbackAsset = switch (photo.view.toLowerCase()) {
      'side' => AppImages.sideView,
      'back' => AppImages.backView,
      _ =>
        (safeIndex == 1)
            ? AppImages.sideView
            : (safeIndex == 2 ? AppImages.backView : AppImages.frontView),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Sub-header info
          Text(
            AppDateFormatter.toDayMonthYear(detail?.scanDate ?? widget.date),
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
                        ? AppCachedNetworkImage(
                            key: ValueKey('detail_${photo.view}_$imageUrl'),
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            autoOrient: true,
                            useOldImageOnUrlChange: false,
                            placeholder: const Center(
                              child: AppLoader(color: AppColors.brandTeal),
                            ),
                            errorWidget: Image.asset(
                              fallbackAsset,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(fallbackAsset, fit: BoxFit.contain),
                  ),
                ),
                // Left arrow
                if (safeIndex > 0)
                  Positioned(
                    left: 0,
                    child: ScanDetailArrowButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onPressed: () => _previousPhoto(views.length),
                    ),
                  ),
                // Right arrow
                if (safeIndex < views.length - 1)
                  Positioned(
                    right: 0,
                    child: ScanDetailArrowButton(
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
}
