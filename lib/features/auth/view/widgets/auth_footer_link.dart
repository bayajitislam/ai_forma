import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefix,
    required this.linkText,
    this.onLinkTap,
  });

  final String prefix;
  final String linkText;
  final VoidCallback? onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onLinkTap,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: prefix,
                style: AppTextStyles.authBody,
              ),
              TextSpan(
                text: linkText,
                style: AppTextStyles.authLink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
