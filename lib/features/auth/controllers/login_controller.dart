import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:ai_forma/features/auth/repositories/login_repository.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository;
  LoginController({required this.loginRepository});

  // Text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observable state
  RxBool isPasswordObsecure = true.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Inline field errors
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Validate form fields
  bool _validate() {
    emailError('');
    passwordError('');
    errorMessage('');

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;

    if (email.isEmpty) {
      emailError('Email address is required.');
      return false;
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(email)) {
      emailError('Enter a valid email address.');
      return false;
    }

    if (password.isEmpty) {
      passwordError('Password is required.');
      return false;
    }

    return true;
  }

  // Login action
  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) return;

    isLoading(true);

    final model = LoginModel(
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text,
    );

    final result = await loginRepository.login(model);

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isLoading(false);
      },
      (loginResponse) async {
        // Save access token, refresh token, and user data to SharedPreferences
        await AuthStorage.saveAuthData(
          tokens: loginResponse.tokens,
          user: loginResponse.user,
        );

        // Update global user state
        if (Get.isRegistered<UserController>()) {
          Get.find<UserController>().setUser(loginResponse.user);
        }

        isLoading(false);

        // Check remote onboarding and initial scan completion statuses
        if (!loginResponse.user.onboardingCompleted) {
          Get.offAllNamed(RoutesName.gender);
        } else if (!loginResponse.user.initialScanCompleted) {
          Get.offAllNamed(RoutesName.checkInIntro);
        } else {
          Get.offAllNamed(RoutesName.appShell);
        }
      },
    );
  }
}
