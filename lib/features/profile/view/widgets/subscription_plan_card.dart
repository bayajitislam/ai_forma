import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final bool isPremium;
  final List<String> features;

  const SubscriptionPlanCard({
    super.key,
    required this.isPremium,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: isPremium
              ? [
                  AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.3),
                  AppColors.accent,
                ]
              : [
                  const Color(0xFFF8FAFC),
                  const Color(0xFFF1F5F9),
                ],
          stops: const [0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPremium
              ? AppColors.cardBorder.withValues(alpha: 0.5)
              : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPremium
                    ? ProfileStrings.aiformaPremium
                    : ProfileStrings.aiformaFree,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPremium
                      ? AppColors.brandTealLight
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPremium
                      ? ProfileStrings.premiumActive
                      : ProfileStrings.freePlan,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPremium
                        ? AppColors.onPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isPremium
                ? ProfileStrings.premiumSubtitle
                : ProfileStrings.freeSubtitle,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Features list
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isPremium
                          ? AppColors.insightBadgePositiveBg
                          : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isPremium
                            ? AppColors.accent
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 13,
                      color: isPremium
                          ? AppColors.brandTealDark
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    feature,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPremium
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
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
