import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';

class AuthBrandTitle extends StatelessWidget {
  const AuthBrandTitle({
    super.key,
    required this.prefix,
    this.suffix = '',
    this.style,
    this.logoHeight = 28,
    this.logoWidth = 130,
  });

  final String prefix;
  final String suffix;
  final TextStyle? style;
  final double logoHeight;
  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prefix, style: style ?? AppTextStyles.authSectionTitle),
        AppBrandText(height: logoHeight, width: logoWidth),
        if (suffix.isNotEmpty)
          Text(suffix, style: style ?? AppTextStyles.authSectionTitle),
      ],
    );
  }
}

class AuthWelcomeTitle extends StatelessWidget {
  const AuthWelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome to ',
          style: AppTextStyles.successTitle,
        ),
        AppBrandText(height: 30, width: 130),
        const Text('.', style: AppTextStyles.successTitle),
      ],
    );
  }
}
