import 'package:ai_forma/features/auth/constants/auth_strings.dart';
import 'package:ai_forma/features/auth/view/widgets/auth_footer_link.dart';
import 'package:flutter/material.dart';

/// Reusable footer widget for code resend flows with countdown timer and loading states.
class AuthResendFooter extends StatelessWidget {
  const AuthResendFooter({
    super.key,
    required this.canResend,
    required this.isResending,
    required this.timerString,
    required this.onResend,
  });

  final bool canResend;
  final bool isResending;
  final String timerString;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    String linkLabel;
    if (isResending) {
      linkLabel = AuthStrings.resendingCode;
    } else if (!canResend) {
      linkLabel = '${AuthStrings.resendCode} ($timerString)';
    } else {
      linkLabel = AuthStrings.resendCode;
    }

    return AuthFooterLink(
      prefix: AuthStrings.didNotReceive,
      linkText: linkLabel,
      onLinkTap: canResend ? onResend : null,
    );
  }
}
