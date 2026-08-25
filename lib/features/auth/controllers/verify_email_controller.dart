import 'dart:async';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/auth/models/verify_email_model.dart';
import 'package:ai_forma/features/auth/repositories/verify_email_repository.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  final VerifyEmailRepository verifyEmailRepository;
  VerifyEmailController({required this.verifyEmailRepository});

  //Email passed from signup screen via Get.arguments
  late String email;

  //Observable state
  RxBool isLoading = false.obs;
  RxBool isResendLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString successMessage = ''.obs;

  //Resend timer state (120 seconds = 2 minutes)
  RxInt resendSeconds = 120.obs;
  Timer? _timer;

  //Get formatted timer string "MM:SS" or "02:00"
  String get timerString {
    final minutes = (resendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (resendSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get canResend => resendSeconds.value == 0 && !isResendLoading.value;

  //Holds the 6-digit code built from VerificationCodeInput
  String _code = '';

  @override
  void onInit() {
    super.onInit();
    //Read the email argument passed by SignupController
    email = Get.arguments['email'] ?? '';
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer?.cancel();
    resendSeconds.value = 120; // 2 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  //Called by VerificationCodeInput widget whenever the code changes
  void onCodeChanged(String code) {
    _code = code;
    //Clear messages when user starts editing again
    errorMessage('');
    successMessage('');
  }

  //Validate the code before calling the API
  bool _validate() {
    errorMessage('');
    successMessage('');

    if (_code.length < 6) {
      errorMessage('Please enter the full 6-digit code.');
      return false;
    }

    return true;
  }

  //Verify the email
  Future<void> verifyEmail() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) return;

    //Spinner Show
    isLoading(true);

    //Build model
    final model = VerifyEmailModel(email: email, code: _code);

    //Call Repository
    final result = await verifyEmailRepository.verifyEmail(model);

    result.fold(
      (failure) {
        //Show error inline
        errorMessage(failure.message);
        //Spinner Hide
        isLoading(false);
      },
      (loginResponse) async {
        // Save access token, refresh token, and user data to local storage
        await AuthStorage.saveAuthData(
          tokens: loginResponse.tokens,
          user: loginResponse.user,
        );

        // Update global user state
        if (Get.isRegistered<UserController>()) {
          Get.find<UserController>().setUser(loginResponse.user);
        }

        //Spinner Hide
        isLoading(false);
        //Navigate to success screen — clear the verify + signup screens
        Get.offAllNamed(RoutesName.signupSuccess);
      },
    );
  }

  //Resend OTP code
  Future<void> resendCode() async {
    if (!canResend) return;

    isResendLoading(true);
    errorMessage('');
    successMessage('');

    final result = await verifyEmailRepository.resendCode(email);

    result.fold(
      (failure) {
        errorMessage(failure.message);
        isResendLoading(false);
      },
      (message) {
        successMessage(message);
        isResendLoading(false);
        _startTimer(); // Restart 2 minute countdown on success
      },
    );
  }
}
