import 'package:flutter/material.dart';
import 'package:ai_forma/core/constants/app_images.dart';

class AppBrandText extends StatelessWidget {
  const AppBrandText({super.key, this.height = 40, this.width = double.infinity});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
