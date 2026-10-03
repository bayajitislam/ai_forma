import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  static const String _contactEmail = 'founders@ai-forma.net';

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
      _showTesterDialog(context, isPremium: isPremium);
    });
  }

  void _showTesterDialog(BuildContext context, {required bool isPremium}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Badge Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isPremium
                        ? AppColors.brandTealLight.withValues(alpha: 0.35)
                        : AppColors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPremium
                        ? Icons.verified_rounded
                        : Icons.card_membership_rounded,
                    color: isPremium ? AppColors.brandTeal : AppColors.accent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Dialog Title
                Text(
                  isPremium ? "You're on Premium!" : 'Tester Premium Access',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Dialog Description
                Text(
                  isPremium
                      ? 'You are already premium! Enjoy testing all features and give us your feedback.'
                      : 'If you are a tester, contact admin to get premium in this email:',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Contact Email Box for Free / Tester users
                if (!isPremium) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.cardBorder.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: AppColors.brandTeal,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: SelectionArea(
                            child: Text(
                              _contactEmail,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: _contactEmail),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Email copied: $_contactEmail',
                                      style: TextStyle(fontFamily: 'Nunito'),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppColors.brandTeal,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandTeal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                  color: AppColors.brandTeal,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Copy',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.brandTeal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // OK Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandTeal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      'Unlimited AI Body Scans',
      'Advanced AI Physique Analysis',
      'Unlimited Scan Comparisons',
      'Priority AI Processing',
      'Export Progress Reports',
    ];

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription',
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
                        // Plan Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: isPremium
                                  ? [
                                      AppColors.insightConsistencyIncompleteBg
                                          .withValues(alpha: 0.3),
                                      AppColors.accent,
                                    ]
                                  : [
                                      const Color(0xFFF8FAFC),
                                      const Color(0xFFF1F5F9),
                                    ],
                              stops: const [0.7, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isPremium
                                  ? AppColors.cardBorder.withValues(alpha: 0.5)
                                  : AppColors.cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Badge Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isPremium
                                        ? 'AiFORMA Premium'
                                        : 'AiFORMA Free',
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPremium
                                          ? AppColors.brandTealLight
                                          : const Color(0xFFE2E8F0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isPremium
                                          ? 'Premium Active'
                                          : 'Free Plan',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isPremium
                                            ? AppColors.onPrimary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isPremium
                                    ? 'Tester Access • All Features Unlocked'
                                    : 'Upgrade to unlock full AI Physique Analysis',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Features list
                              ...features.map(
                                (feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: isPremium
                                              ? AppColors
                                                  .insightBadgePositiveBg
                                              : const Color(0xFFE2E8F0),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isPremium
                                                ? AppColors.accent
                                                : const Color(0xFFCBD5E1),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 13,
                                          color: isPremium
                                              ? AppColors.brandTealDark
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        feature,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isPremium
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Tester Info Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.cardBorder.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: AppColors.brandTeal,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isPremium
                                      ? 'You have full access to all AiFORMA features during tester preview. Enjoy testing and share your feedback!'
                                      : 'In-app purchases are coming soon. If you are a tester, contact $_contactEmail to activate premium.',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  onPressed: () {
                    _showTesterDialog(context, isPremium: isPremium);
                  },
                  label: isPremium ? 'Premium Active' : 'Upgrade to Premium',
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
