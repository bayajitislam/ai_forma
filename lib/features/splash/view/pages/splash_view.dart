import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_network_error_widget.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/splash/view/widgets/splash_content.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    setState(() {
      _isError = false;
      _errorMessage = '';
    });

    final token = await AuthStorage.getAccessToken();

    // 1. Not logged in -> Navigate directly to Onboarding
    if (token == null || token.isEmpty) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Get.offAllNamed(RoutesName.onboarding);
      return;
    }

    // 2. Logged in -> Call GET /api/auth/me/ to get fresh remote user data
    final UserController userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController(DioClient()));

    final res = await userController.fetchProfile();

    if (!mounted) return;

    res.fold(
      (failure) async {
        final msg = failure.message.toLowerCase();
        // 401 Unauthorized / Token Expired -> Clear session & go to Onboarding
        if (msg.contains('unauthorized') ||
            msg.contains('unauthenticated') ||
            msg.contains('401') ||
            msg.contains('token')) {
          await AuthStorage.clearSession();
          if (!mounted) return;
          Get.offAllNamed(RoutesName.onboarding);
          return;
        }

        // Network or Server Error -> Show AppNetworkErrorWidget with "Try Again" button
        setState(() {
          _isError = true;
          _errorMessage = failure.message.isNotEmpty
              ? failure.message
              : 'Unable to connect to server. Please check your internet connection.';
        });
      },
      (remoteUser) {
        // 3. Remote GET /api/auth/me/ succeeded -> Navigate strictly based on remote server data!
        if (!remoteUser.onboardingCompleted) {
          Get.offAllNamed(RoutesName.gender);
        } else if (!remoteUser.initialScanCompleted) {
          Get.offAllNamed(RoutesName.checkInIntro);
        } else {
          Get.offAllNamed(RoutesName.appShell);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: _isError
                ? AppNetworkErrorWidget(
                    onRetry: _checkAuthAndNavigate,
                    message: _errorMessage,
                  )
                : const SplashContent(),
          ),
        ),
      ),
    );
  }
}
