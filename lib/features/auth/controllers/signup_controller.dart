import 'package:ai_forma/features/auth/models/signup_model.dart';
import 'package:ai_forma/features/auth/repositories/signup_repository.dart';
import 'package:ai_forma/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final SignupRepository signupRepository;
  SignupController({required this.signupRepository});

  //Text controllers
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Obserbale controllers
  RxBool isPasswordObsecure = true.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage =
      ''.obs; // API / general error shown above password requirements
  RxString successMessage = ''.obs;

  //Per-field inline errors
  RxString nameError = ''.obs;
  RxString emailError = ''.obs;

  //Password requirement flags
  RxBool hasMinLength = false.obs;
  RxBool hasNumber = false.obs;
  RxBool hasUppercase = false.obs;
  RxBool hasSpecial = false.obs;

  //True only when ALL password rules pass
  bool get isPasswordValid =>
      hasMinLength.value &&
      hasNumber.value &&
      hasUppercase.value &&
      hasSpecial.value;

  //Listen to password changes and validate rules
  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final p = passwordController.text;
    hasMinLength.value = p.length >= 8;
    hasNumber.value = p.contains(RegExp(r'[0-9]'));
    hasUppercase.value = p.contains(RegExp(r'[A-Z]'));
    hasSpecial.value = p.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=]'));
  }

  //dispose
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Returns true if all fields are valid, false if any error is set
  bool _validate() {
    //Clear previous errors
    nameError('');
    emailError('');
    errorMessage('');

    final name = fullNameController.text.trim();
    final email = emailController.text.trim().toLowerCase();

    //Name validation
    if (name.isEmpty) {
      nameError('Full name is required.');
      return false;
    }
    if (name.length < 2) {
      nameError('Name must be at least 2 characters.');
      return false;
    }

    //Email validation
    if (email.isEmpty) {
      emailError('Email address is required.');
      return false;
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(email)) {
      emailError('Enter a valid email address.');
      return false;
    }

    return true; // all good
  }

  //Sign up
  Future<void> signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    //Run validation first — stop if anything is invalid
    if (!_validate()) return;

    //Spinner Show
    isLoading(true);

    //Create model from text controllers
    final model = SignupModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text,
    );

    //Call Repository
    final result = await signupRepository.signUp(model);

    result.fold(
      (failure) {
        //Show API error inline (above password requirements)
        errorMessage(failure.message);
        //Spinner Hide
        isLoading(false);
      },
      (signup) {
        //Navigate to next screen
        Get.toNamed(RoutesName.verifyEmail, arguments: {'email': signup.email});
        //Spinner Hide
        isLoading(false);
      },
    );
  }
}
