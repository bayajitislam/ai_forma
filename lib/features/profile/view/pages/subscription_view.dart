import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/view/widgets/subscription_plan_card.dart';
import 'package:ai_forma/features/profile/view/widgets/subscription_tester_banner.dart';
import 'package:ai_forma/features/profile/view/widgets/subscription_tester_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  static const List<String> _features = [
    ProfileStrings.featureUnlimitedScans,
    ProfileStrings.featurePhysiqueAnalysis,
    ProfileStrings.featureScanComparisons,
    ProfileStrings.featurePriorityProcessing,
    ProfileStrings.featureExportReports,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = Get.isRegistered<UserController>()
          ? Get.find<UserController>().currentUser.value
          : null;
      final bool isPaid = user?.isPaid ?? false;
      final bool isPremium =
          isPaid || (user?.membershipStatus?.toLowerCase() == 'paid');
      SubscriptionTesterDialog.show(context, isPremium: isPremium);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          ProfileStrings.subscriptionTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Obx(() {
            final user = userController?.currentUser.value;
            final bool isPaid = user?.isPaid ?? false;
            final bool isPremium =
                isPaid || (user?.membershipStatus?.toLowerCase() == 'paid');

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        SubscriptionPlanCard(
                          isPremium: isPremium,
                          features: _features,
                        ),
                        const SizedBox(height: 16),
                        SubscriptionTesterBanner(isPremium: isPremium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  onPressed: () {
                    SubscriptionTesterDialog.show(context, isPremium: isPremium);
                  },
                  label: isPremium
                      ? ProfileStrings.premiumActive
                      : ProfileStrings.upgradeToPremium,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
