abstract final class AuthStrings {
  // Login
  static const String loginTitle = 'Welcome back';
  static const String loginSubtitle = 'Access your Body Intelligence.';
  static const String loginButton = 'Log In';
  static const String forgotPassword = 'Forgot password?';
  static const String noAccount = "Don't have an account? ";
  static const String signUp = 'Sign Up';

  // Sign Up
  static const String signupTitlePrefix = 'Create your ';
  static const String signupTitleSuffix = ' account to begin.';
  static const String signupSubtitle = 'Start your transformation today.';

  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'Josh Bowden';
  static const String emailLabel = 'Email';
  static const String emailHint = 'joshbowden@example.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = '••••••••';

  static const String passwordRequirementsTitle = 'Password Requirements';
  static const String requirementMinLength = '8+ characters';
  static const String requirementNumber = 'One number';
  static const String requirementUppercase = 'One uppercase letter';
  static const String requirementSpecial = 'One special character';

  static const String createAccountButton = 'CREATE ACCOUNT';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String logIn = 'Log In';

  // Verify Email
  static const String verifyEmailTitle = 'Verify your email';
  static const String verifyEmailSubtitlePrefix =
      "We've sent a verification code to ";
  static const String verifyEmailButton = 'Verify Email';
  static const String didNotReceive = "Didn't receive it? ";
  static const String resendCode = 'Resend code';
  static const String resendingCode = 'Resending...';

  // Success Screens
  static const String successTitlePrefix = 'Welcome to ';
  static const String successTitleSuffix = '.';
  static const String successSubtitle =
      "Your account is ready. Let's discover what your body is capable of.";
  static const String beginAssessmentButton = 'Begin Assessment';

  // Forgot Password
  static const String forgotPasswordTitle = 'Forgot password?';
  static const String forgotPasswordSubtitle =
      "Enter the email associated with your account. We'll send you a secure reset code.";
  static const String sendResetCodeButton = 'Send Reset Code';
  static const String backToLogIn = 'Back to Log In';

  // Reset Code
  static const String resetCodeTitle = 'Enter your reset code';
  static const String resetCodeSubtitlePrefix =
      "We've sent a verification code to ";
  static const String verifyCodeButton = 'Verify Code';

  // Reset Password Success
  static const String resetSuccessTitle = 'Password Reset Successful';
  static const String resetSuccessSubtitle =
      'Your password has been updated successfully.\nYou can now log in using your new password.';

  // Create New Password
  static const String createNewPasswordTitle = 'Create New Password';
  static const String createNewPasswordSubtitle =
      'Your new password must be different from previously used passwords.';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = '••••••••';
  static const String resetPasswordButton = 'Reset Password';

  // Form Validation & Errors
  static const String emailRequired = 'Email address is required.';
  static const String emailInvalid = 'Enter a valid email address.';
  static const String passwordRequired = 'Password is required.';
  static const String passwordMinLength =
      'Password must be at least 8 characters long.';
  static const String confirmPasswordRequired =
      'Please confirm your new password.';
  static const String passwordsDoNotMatch = 'Passwords do not match.';
  static const String fullNameRequired = 'Full name is required.';
  static const String fullNameMinLength =
      'Name must be at least 2 characters.';
  static const String codeIncomplete =
      'Please enter the full 6-digit verification code.';
  static const String emailVerificationCodeIncomplete =
      'Please enter the full 6-digit code.';

  // User Profile & Account Actions
  static const String failedToUploadImage = 'Failed to upload image.';
  static const String accountDeletedSuccessfully =
      'Account deleted successfully.';
  static const String failedToDeleteAccount = 'Failed to delete account.';
}
