import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/check_in/view/pages/check_in_intro_view.dart';
import 'package:ai_forma/features/dashboard/controllers/daily_brief_controller.dart';

class WeeklyScanCard extends StatelessWidget {
  const WeeklyScanCard({super.key});

  void _beginScan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CheckInIntroView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = DailyBriefController.to;

    return Obx(() {
      final isOverdue = controller.isScanOverdue.value;

      if (isOverdue) {
        return _buildOverdueCard(context);
      }
      return _buildScanReadyCard(context);
    });
  }

  Widget _buildScanReadyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandTeal.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Row
          Row(
            children: const [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.brandTeal,
              ),
              SizedBox(width: 6),
              Text(
                'WEEKLY SCAN',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.brandTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Your weekly scan is ready.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Complete your photos and measurements to see how your body has changed.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right Graphic
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4EFEF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.brandTeal,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.crop_free,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // CTA Button
          GestureDetector(
            onTap: () => _beginScan(context),
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.brandTeal,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Begin Weekly Scan',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Lock Footer
          Row(
            children: const [
              Icon(
                Icons.lock_outline,
                size: 13,
                color: AppColors.brandTeal,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '6 daily brief responses from last week are attached to this scan.',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 6),
              Text(
                'SCAN OVERDUE',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Yesterday's weekly scan has not been completed.",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Complete it today to preserve your progress timeline.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month,
                  size: 24,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _beginScan(context),
            child: Container(
              width: double.infinity,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF0C191B),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Complete Missed Scan',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
