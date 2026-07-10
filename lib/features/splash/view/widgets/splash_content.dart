import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';
import 'package:ai_forma/features/splash/constants/splash_strings.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const AppBrandText(height: 48),
          const SizedBox(height: 12),
          const Text(
            SplashStrings.appSubTagline,
            style: AppTextStyles.splashSubTagline,
          ),
          const Spacer(flex: 3),
          const Text(
            SplashStrings.sloganLine1,
            textAlign: TextAlign.center,
            style: AppTextStyles.splashSlogan,
          ),
          const SizedBox(height: 4),
          const Text(
            SplashStrings.sloganLine2,
            textAlign: TextAlign.center,
            style: AppTextStyles.splashSloganHighlight,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
