import 'package:flutter/material.dart';
import 'package:ai_forma/core/common/app_dialog.dart';
import 'package:ai_forma/features/dashboard/constants/dashboard_strings.dart';
import 'package:ai_forma/features/profile/view/pages/subscription_view.dart';

abstract final class DashboardDialogs {
  /// Show dialog prompting user to upgrade to premium for weekly scan & analysis
  static void showPremium(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        icon: Icons.workspace_premium_rounded,
        title: DashboardStrings.premiumTitle,
        message: DashboardStrings.premiumMessage,
        confirmText: DashboardStrings.buyPremium,
        cancelText: DashboardStrings.cancel,
        onConfirm: () {
          Navigator.pop(ctx);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SubscriptionView(),
            ),
          );
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  /// Show weight log confirmation dialog before entering scan flow
  static void showWeightPrompt(
    BuildContext context, {
    String? message,
    required VoidCallback onLogWeight,
    required VoidCallback onSkip,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AppDialog(
        icon: Icons.scale_rounded,
        title: DashboardStrings.logWeightBeforeScanTitle,
        message: message ?? DashboardStrings.logWeightBeforeScanMessage,
        confirmText: DashboardStrings.logWeight,
        cancelText: DashboardStrings.skip,
        onConfirm: () {
          Navigator.pop(dialogCtx);
          onLogWeight();
        },
        onCancel: () {
          Navigator.pop(dialogCtx);
          onSkip();
        },
      ),
    );
  }
}
