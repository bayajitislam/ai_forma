import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';

class OnboardingFeatureItem extends StatelessWidget {
  const OnboardingFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(icon: icon, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.featureTitle),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.featureDescription),
            ],
          ),
        ),
      ],
    );
  }
}
