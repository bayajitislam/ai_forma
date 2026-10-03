import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/splash/controllers/splash_controller.dart';
import 'package:ai_forma/features/splash/view/widgets/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Obx(() {
              if (controller.isError.value) {
                return AppNetworkErrorWidget(
                  onRetry: controller.checkAuthAndNavigate,
                  message: controller.errorMessage.value,
                );
              }
              return const SplashContent();
            }),
          ),
        ),
      ),
    );
  }
}
