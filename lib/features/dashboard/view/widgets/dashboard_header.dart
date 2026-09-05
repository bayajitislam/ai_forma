import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, this.headerData, this.onAvatarTap});

  final HomeHeaderModel? headerData;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final greetingText = (headerData?.greeting.isNotEmpty ?? false)
        ? headerData!.greeting
        : (headerData?.firstName != null &&
                  headerData!.firstName!.trim().isNotEmpty
              ? 'Hello, ${headerData!.firstName}'
              : 'Hello');

    final statusText = headerData?.statusMessage ?? '';

    // final dateText = _formatTodayDate(headerData?.today);
    // final initials = _getInitials(headerData?.firstName, greetingText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greetingText,
          style: AppTextStyles.authSectionTitle.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.2,
            color: AppColors.textPrimary,
          ),
        ),
        if (statusText.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            statusText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
