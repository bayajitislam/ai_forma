import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, this.headerData});

  final HomeHeaderModel? headerData;

  @override
  Widget build(BuildContext context) {
    final greetingText = (headerData?.greeting.isNotEmpty ?? false)
        ? headerData!.greeting
        : DashboardStrings.helloUser;

    final statusText = (headerData?.statusMessage.isNotEmpty ?? false)
        ? headerData!.statusMessage
        : DashboardStrings.aiGreeting;

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
    );
  }
}
