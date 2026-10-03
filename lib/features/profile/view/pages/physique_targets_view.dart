import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/view/widgets/physique_target_item_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhysiqueTargetsView extends StatelessWidget {
  const PhysiqueTargetsView({super.key});

  @override
  Widget build(BuildContext context) {
    const targets = [
      PhysiqueTargetItem(
        label: ProfileStrings.currentLabel,
        goalCaption: ProfileStrings.targetBodyFatCaption,
        value: '18.2%',
      ),
      PhysiqueTargetItem(
        label: ProfileStrings.weightLabel,
        goalCaption: ProfileStrings.weightGoalCaption,
        value: '87.4 kg',
      ),
      PhysiqueTargetItem(
        label: 'Muscle Mass',
        goalCaption: ProfileStrings.muscleMassGoalCaption,
        value: '71.5 kg',
      ),
      PhysiqueTargetItem(
        label: 'Daily steps',
        goalCaption: ProfileStrings.dailyStepsGoalCaption,
        value: '8,742',
      ),
    ];

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
          ProfileStrings.physiqueTargetsTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                ProfileStrings.goalsSectionHeader,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: targets.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.cardBorder.withValues(alpha: 0.4),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    return PhysiqueTargetItemRow(item: targets[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
