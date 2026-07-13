import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/constants/app_images.dart';
import 'package:ai_forma/features/timeline/view/pages/scan_detail_view.dart';

class ScanHistoryTabView extends StatefulWidget {
  const ScanHistoryTabView({super.key});

  @override
  State<ScanHistoryTabView> createState() => _ScanHistoryTabViewState();
}

class _ScanHistoryTabViewState extends State<ScanHistoryTabView> {
  String _selectedAngle = 'All';

  final List<_MonthGroup> _historyData = [
    _MonthGroup(
      month: 'May 2025',
      scans: [
        _ScanHistoryItem(date: 'May 18'),
        _ScanHistoryItem(date: 'May 11'),
        _ScanHistoryItem(date: 'May 4'),
      ],
    ),
    _MonthGroup(
      month: 'Apr 2025',
      scans: [_ScanHistoryItem(date: 'Apr 4')],
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            itemCount: _historyData.length,
            itemBuilder: (context, index) {
              final group = _historyData[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      group.month,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  ...group.scans.map((scan) => _buildScanRow(context, scan)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScanRow(BuildContext context, _ScanHistoryItem scan) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScanDetailView(date: scan.date),
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
                scan.date,
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
                children: _getFilteredThumbnails().map((imgPath) {
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
                        child: Image.asset(imgPath, fit: BoxFit.cover),
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

  List<String> _getFilteredThumbnails() {
    switch (_selectedAngle) {
      case 'Front':
        return [AppImages.frontView];
      case 'Side':
        return [AppImages.sideView];
      case 'Back':
        return [AppImages.backView];
      case 'All':
      default:
        return [AppImages.frontView, AppImages.sideView, AppImages.backView];
    }
  }
}

class _MonthGroup {
  final String month;
  final List<_ScanHistoryItem> scans;

  _MonthGroup({required this.month, required this.scans});
}

class _ScanHistoryItem {
  final String date;

  _ScanHistoryItem({required this.date});
}
