import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/view/widgets/check_in_header.dart';
import 'package:ai_forma/features/insights/constants/insights_strings.dart';
import 'package:ai_forma/features/insights/view/pages/comparison_summary_view.dart';
import 'package:ai_forma/features/insights/view/widgets/compare_scan_card.dart';

class _ScanOption {
  const _ScanOption({
    required this.id,
    required this.date,
    required this.shortDate,
    required this.subtitle,
    required this.imageAsset,
    required this.sortOrder,
  });

  final String id;
  final String date;
  final String shortDate;
  final String subtitle;
  final String imageAsset;
  final int sortOrder;
}

class CompareScansView extends StatefulWidget {
  const CompareScansView({super.key});

  @override
  State<CompareScansView> createState() => _CompareScansViewState();
}

class _CompareScansViewState extends State<CompareScansView> {
  static const _scans = [
    _ScanOption(
      id: 'may18',
      date: InsightsStrings.scanDateMay18,
      shortDate: InsightsStrings.scanShortMay18,
      subtitle: InsightsStrings.latestScanLabel,
      imageAsset: AppImages.frontView,
      sortOrder: 3,
    ),
    _ScanOption(
      id: 'may4',
      date: InsightsStrings.scanDateMay4,
      shortDate: InsightsStrings.scanShortMay4,
      subtitle: InsightsStrings.twoWeeksAgo,
      imageAsset: AppImages.sideView,
      sortOrder: 2,
    ),
    _ScanOption(
      id: 'apr27',
      date: InsightsStrings.scanDateApr27,
      shortDate: InsightsStrings.scanShortApr27,
      subtitle: InsightsStrings.oneMonthAgo,
      imageAsset: AppImages.backView,
      sortOrder: 1,
    ),
  ];

  final Set<String> _selectedIds = {'may18', 'may4'};

  void _toggleScan(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        return;
      }
      if (_selectedIds.length >= 2) {
        _selectedIds.remove(_selectedIds.first);
      }
      _selectedIds.add(id);
    });
  }

  void _generateComparison() {
    final selected = _scans
        .where((scan) => _selectedIds.contains(scan.id))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    if (selected.length != 2) return;

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ComparisonSummaryView(
          thenScan: ComparisonScanData(
            shortDate: selected[0].shortDate,
            imageAsset: selected[0].imageAsset,
          ),
          nowScan: ComparisonScanData(
            shortDate: selected[1].shortDate,
            imageAsset: selected[1].imageAsset,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate = _selectedIds.length == 2;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: const CheckInHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      InsightsStrings.compareScansTitle,
                      style: AppTextStyles.authSectionTitle.copyWith(
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      InsightsStrings.compareScansSubtitle,
                      style: AppTextStyles.featureDescription.copyWith(
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var i = 0; i < _scans.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      CompareScanCard(
                        imageAsset: _scans[i].imageAsset,
                        date: _scans[i].date,
                        subtitle: _scans[i].subtitle,
                        isSelected: _selectedIds.contains(_scans[i].id),
                        onTap: () => _toggleScan(_scans[i].id),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: PrimaryButton(
                onPressed: canGenerate ? _generateComparison : null,
                label: InsightsStrings.generateComparison,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
