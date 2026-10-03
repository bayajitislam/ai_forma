import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';

class SubscriptionTesterBanner extends StatelessWidget {
  final bool isPremium;

  const SubscriptionTesterBanner({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.brandTeal,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isPremium
                  ? ProfileStrings.testerBannerPremium
                  : ProfileStrings.testerBannerFree,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
