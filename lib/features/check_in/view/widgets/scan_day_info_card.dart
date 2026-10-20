import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';

/// An expandable information card on the Check-In screen explaining
/// how changing the scan day affects the user's schedule, cycle, and Daily Brief questions.
class ScanDayInfoCard extends StatefulWidget {
  const ScanDayInfoCard({super.key});

  @override
  State<ScanDayInfoCard> createState() => _ScanDayInfoCardState();
}

class _ScanDayInfoCardState extends State<ScanDayInfoCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Widget _buildCalendarClockIcon() {
    return SizedBox(
      width: 26,
      height: 26,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.calendar_month_outlined,
              size: 22,
              color: AppColors.brandTeal,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(
                color: Color(0xFFF0FAF8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time_rounded,
                size: 11,
                color: AppColors.brandTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.brandTeal.withValues(alpha: 0.08),
          highlightColor: AppColors.brandTeal.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      key: const ValueKey('collapsed'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalendarClockIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    CheckInStrings.scanDayInfoTitle,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.brandTeal,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                CheckInStrings.scanDayInfoCollapsedSnippet,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                CheckInStrings.scanDayInfoTapToLearnMore,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandTeal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      key: const ValueKey('expanded'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Changing your scan day section
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendarClockIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        CheckInStrings.scanDayInfoTitle,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: AppColors.brandTeal,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    CheckInStrings.scanDayInfoExpandedBody,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 2. Daily Brief questions section
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.article_outlined,
              color: AppColors.brandTeal,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    CheckInStrings.dailyBriefQuestionsTitle,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    CheckInStrings.dailyBriefQuestionsBody,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Divider
        Divider(
          color: AppColors.brandTeal.withValues(alpha: 0.18),
          height: 1,
          thickness: 1,
        ),

        const SizedBox(height: 12),

        // 3. Reassurance row
        Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.brandTeal,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                CheckInStrings.progressAndStreakPreserved,
                style: const TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
