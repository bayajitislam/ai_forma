import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/features/shell/constants/shell_strings.dart';

class PlaceholderTabView extends StatelessWidget {
  const PlaceholderTabView({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title — ${ShellStrings.comingSoon}',
        style: AppTextStyles.authSectionTitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
