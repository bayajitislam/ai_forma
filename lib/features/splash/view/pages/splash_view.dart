import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/splash/view/widgets/splash_content.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _checkAuthAndNavigate);
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final token = await AuthStorage.getAccessToken();
    UserModel? user;

    if (token != null && token.isNotEmpty) {
      // Always call GET /api/auth/me/ on app open to fetch the latest user flags
      final UserController userController = Get.isRegistered<UserController>()
          ? Get.find<UserController>()
          : Get.put(UserController(DioClient()));

      final res = await userController.fetchProfile();
      await res.fold(
        (_) async {
          user = await AuthStorage.getUser();
        },
        (latestUser) async {
          user = latestUser;
        },
      );
    }

    if (!mounted) return;

    if (token != null && token.isNotEmpty && user != null) {
      if (!user!.onboardingCompleted) {
        // 1. Logged in but assessment not completed -> Go to Assessment
        Get.offAllNamed(RoutesName.gender);
      } else if (!user!.initialScanCompleted) {
        // 2. Logged in & assessment completed, BUT initial scan NOT completed -> Go to Check-In Intro
        Get.offAllNamed(RoutesName.checkInIntro);
      } else {
        // 3. Both assessment & initial scan completed -> Go to AppShell
        Get.offAllNamed(RoutesName.appShell);
      }
    } else {
      // Not logged in -> Go to Onboarding
      Get.offAllNamed(RoutesName.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(child: Center(child: SplashContent())),
    );
  }
}
