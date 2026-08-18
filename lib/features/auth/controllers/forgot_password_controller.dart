import 'dart:async';
import 'package:ai_forma/features/auth/models/forgot_password_model.dart';
import 'package:ai_forma/features/auth/repositories/forgot_password_repository.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordRepository repository;
  ForgotPasswordController({required this.repository});

  // Text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Email & reset token passed across screens
  RxString email = ''.obs;
  RxString resetToken = ''.obs;
  String _code = '';

  // Observable UI states
  RxBool isLoading = false.obs;
  RxBool isResendLoading = false.obs;
  RxBool isPasswordObsecure = true.obs;
  RxBool isConfirmObsecure = true.obs;

  RxString errorMessage = ''.obs;
  RxString successMessage = ''.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  // 2-minute countdown timer for resend OTP
  RxInt resendSeconds = 120.obs;
  Timer? _timer;

  String get timerString {
    final minutes = (resendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (resendSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get canResend => resendSeconds.value == 0 && !isResendLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Read email or resetToken arguments if passed from previous routes
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['email'] != null) {
        email.value = args['email'].toString();
        emailController.text = email.value;
      }
      if (args['reset_token'] != null) {
        resetToken.value = args['reset_token'].toString();
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void startTimer() {
    _timer?.cancel();
    resendSeconds.value = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void onCodeChanged(String code) {
    _code = code;
    errorMessage('');
    successMessage('');
  }

  // Validate email address before sending reset code
  bool _validateEmail() {
    emailError('');
    errorMessage('');
    final targetEmail = emailController.text.trim().toLowerCase();

    if (targetEmail.isEmpty) {
      emailError('Email address is required.');
      return false;
    }

    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(targetEmail)) {
      emailError('Please enter a valid email address.');
      return false;
    }

    return true;
  }

  /// Step 1: Send reset code to email (POST /api/auth/password/forgot/)
  Future<void> sendResetCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validateEmail()) return;

    isLoading(true);
    final targetEmail = emailController.text.trim().toLowerCase();
    email.value = targetEmail;

    final result = await repository.forgotPassword(targetEmail);

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isLoading(false);
      },
      (msg) {
        isLoading(false);
        startTimer();
        Get.toNamed(RoutesName.resetCode, arguments: {'email': targetEmail});
      },
    );
  }

  /// Resend reset code (POST /api/auth/password/forgot/)
  Future<void> resendCode() async {
    if (!canResend) return;

    isResendLoading(true);
    errorMessage('');
    successMessage('');

    final result = await repository.forgotPassword(email.value);

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isResendLoading(false);
      },
      (msg) {
        successMessage(msg);
        isResendLoading(false);
        startTimer();
      },
    );
  }

  /// Step 2: Verify 6-digit code (POST /api/auth/password/verify-code/)
  Future<void> verifyCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    errorMessage('');

    if (_code.length < 6) {
      errorMessage('Please enter the full 6-digit verification code.');
      return;
    }

    isLoading(true);

    final result = await repository.verifyResetCode(
      email: email.value,
      code: _code,
    );

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isLoading(false);
      },
      (VerifyCodeResponseModel response) {
        isLoading(false);
        resetToken.value = response.resetToken;
        Get.toNamed(
          RoutesName.createNewPassword,
          arguments: {
            'reset_token': response.resetToken,
            'email': email.value,
          },
        );
      },
    );
  }

  // Validate new password fields
  bool _validatePassword() {
    passwordError('');
    errorMessage('');

    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (newPass.isEmpty) {
      passwordError('Password is required.');
      return false;
    }

    if (newPass.length < 8) {
      passwordError('Password must be at least 8 characters long.');
      return false;
    }

    if (confirmPass.isEmpty) {
      errorMessage('Please confirm your new password.');
      return false;
    }

    if (newPass != confirmPass) {
      errorMessage('Passwords do not match.');
      return false;
    }

    return true;
  }

  /// Step 3: Submit new password (POST /api/auth/password/reset/)
  Future<void> submitNewPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validatePassword()) return;

    isLoading(true);

    final result = await repository.resetPassword(
      resetToken: resetToken.value,
      newPassword: newPasswordController.text,
    );

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isLoading(false);
      },
      (_) {
        isLoading(false);
        Get.offAllNamed(RoutesName.resetPasswordSuccess);
      },
    );
  }
}
