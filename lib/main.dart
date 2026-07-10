import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_strings.dart';
import 'package:ai_forma/core/theme/app_theme.dart';
import 'package:ai_forma/features/splash/view/pages/splash_view.dart';

void main() {
  runApp(const AiFormaApp());
}

class AiFormaApp extends StatelessWidget {
  const AiFormaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashView(),
    );
  }
}
