import 'package:flutter/material.dart';
import 'package:ai_forma/core/widgets/app_brand_text.dart';

class AppShellHeader extends StatelessWidget {
  const AppShellHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AppBrandText(height: 22, width: 150),
    );
  }
}
