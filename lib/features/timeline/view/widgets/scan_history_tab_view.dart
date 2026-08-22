import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/widgets/app_shimmer.dart';
import 'package:ai_forma/features/timeline/controllers/timeline_controller.dart';
import 'package:ai_forma/features/timeline/models/timeline_history_model.dart';
import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';

class ScanHistoryTabView extends StatefulWidget {
  const ScanHistoryTabView({super.key});

  @override
  State<ScanHistoryTabView> createState() => _ScanHistoryTabViewState();
}

class _ScanHistoryTabViewState extends State<ScanHistoryTabView> {
  String _selectedAngle = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TimelineController>();

    return Column(
      children: [
        // Angle Filters Row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: ['All', 'Front', 'Side', 'Back'].map((angle) {
              final isSelected = angle == _selectedAngle;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAngle = angle;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brandTealDark
                          : AppColors.insightConsistencyIncompleteBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      angle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // History List
        Expanded(
          child: Obx(() {
            final isLoading = controller.isHistoryLoading.value;
            final historyItems = controller.historyList;

            if (isLoading && historyItems.isEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        AppShimmer(
                          child: Container(
                            width: 60,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: List.generate(
                              3,
                              (i) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: AppShimmer(
                                  child: Container(
                                    width: 76,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE5E7EB),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            if (historyItems.isEmpty) {
              return const Center(
                child: Text(
                  'No scan history found.',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            // Group by monthLabel
            final groupedMap = <String, List<TimelineHistoryScanItemModel>>{};
            for (final item in historyItems) {
              final month = item.monthLabel.isNotEmpty
                  ? item.monthLabel
                  : (item.month.isNotEmpty ? item.month : 'Scan History');
              groupedMap.putIfAbsent(month, () => []).add(item);
            }

            final monthGroupKeys = groupedMap.keys.toList();

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              itemCount: monthGroupKeys.length,
              itemBuilder: (context, index) {
                final month = monthGroupKeys[index];
                final scans = groupedMap[month]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        month,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    ...scans.map((scan) => _buildScanRow(context, scan)),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildScanRow(
      BuildContext context, TimelineHistoryScanItemModel scan) {
    final thumbs = _getFilteredThumbnails(scan);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScanDetailView(
              scanId: scan.id,
              date: scan.scanDate,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            // Date
            SizedBox(
              width: 60,
              child: Text(
                scan.scanDate,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Thumbnails
            Expanded(
              child: Row(
                children: thumbs.map((urlOrAsset) {
                  final isNetwork = urlOrAsset.startsWith('http');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 76,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.insightConsistencyIncompleteBg,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.background.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isNetwork
                            ? AppShimmerImage(
                                imageUrl: urlOrAsset,
                                fit: BoxFit.contain,
                                errorWidget: Image.asset(
                                  AppImages.frontView,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                urlOrAsset,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Chevron
            const Icon(
              Icons.chevron_right,
              color: AppColors.cardBorder,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getFilteredThumbnails(TimelineHistoryScanItemModel scan) {
    final front = scan.thumbs?.front;
    final side = scan.thumbs?.side;
    final back = scan.thumbs?.back;

    switch (_selectedAngle) {
      case 'Front':
        return [front ?? AppImages.frontView];
      case 'Side':
        return [side ?? AppImages.sideView];
      case 'Back':
        return [back ?? AppImages.backView];
      case 'All':
      default:
        final list = <String>[];
        if (front != null) list.add(front);
        if (side != null) list.add(side);
        if (back != null) list.add(back);
        if (list.isEmpty) {
          return [AppImages.frontView, AppImages.sideView, AppImages.backView];
        }
        return list;
    }
  }
}
