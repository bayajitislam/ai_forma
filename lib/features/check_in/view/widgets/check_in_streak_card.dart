import 'package:flutter/material.dart';
import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';

class CheckInStreakCard extends StatelessWidget {
  const CheckInStreakCard({super.key});

  static const Color _cardBackground = Color(0xFF081012);
  static const Color _tileBackground = Color(0xFF0F1A1C);
  static const Color _mutedText = Color(0xFF6B7F7F);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const RadialGradient(
          center: Alignment(0.9, -0.6),
          radius: 1.1,
          colors: [
            Color(0xFF0F2E2C),
            _cardBackground,
          ],
          stops: [0.0, 0.65],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _tileBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: AppIcon(
                    icon: AppIcons.fire,
                    size: 22,
                    color: AppColors.brandTeal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '12',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    CheckInStrings.weekStreak,
                    style: AppTextStyles.authBody.copyWith(
                      fontSize: 13,
                      color: _mutedText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CheckInStrings.personalBest,
                    style: AppTextStyles.authBody.copyWith(
                      fontSize: 11,
                      color: _mutedText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CheckInStrings.keepItUp,
                    style: AppTextStyles.featureTitle.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(12, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 11 ? 6 : 0),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.brandTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.brandTeal,
                          shape: BoxShape.circle,
                        ),
                        child: const AppIcon(
                          icon: AppIcons.check,
                          size: 11,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CheckInStatCard extends StatelessWidget {
  const CheckInStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            AppIcon(icon: icon, size: 20, color: AppColors.brandTeal),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.dashboardMetricValue.copyWith(fontSize: 18),
            ),
            Text(label, style: AppTextStyles.dashboardMetricLabel),
          ],
        ),
      ),
    );
  }
}
