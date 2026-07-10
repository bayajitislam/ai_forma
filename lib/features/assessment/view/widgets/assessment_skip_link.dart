import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/assessment/constants/assessment_strings.dart';

class AssessmentSkipLink extends StatelessWidget {
  const AssessmentSkipLink({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: const Text(
          AssessmentStrings.skip,
          style: AppTextStyles.authLink,
        ),
      ),
    );
  }
}
