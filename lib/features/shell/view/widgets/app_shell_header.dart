import 'package:flutter/material.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';

class AppShellHeader extends StatelessWidget {
  final bool showProfileOption;
  final VoidCallback? onProfileTap;

  const AppShellHeader({
    super.key,
    this.showProfileOption = false,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 38,
      child: Center(
        child: AppBrandText(height: 22, width: 140),
      ),
    );
  }
}
