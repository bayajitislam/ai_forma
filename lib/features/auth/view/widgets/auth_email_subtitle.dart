import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Reusable subtitle displaying a prefix followed by an emphasized email address.
class AuthEmailSubtitle extends StatelessWidget {
  const AuthEmailSubtitle({
    super.key,
    required this.prefix,
    required this.email,
  });

  final String prefix;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: AppTextStyles.authBody,
          ),
          TextSpan(
            text: email,
            style: AppTextStyles.authBody.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
