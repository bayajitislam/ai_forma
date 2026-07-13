import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class PhysiqueTargetsView extends StatelessWidget {
  const PhysiqueTargetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final targets = [
      _TargetRowItem(
        label: 'Current',
        goalCaption: 'Target: 15%',
        value: '18.2%',
      ),
      _TargetRowItem(
        label: 'Weight',
        goalCaption: 'Goal: 82 kg',
        value: '87.4 kg',
      ),
      _TargetRowItem(
        label: 'Muscle Mass',
        goalCaption: 'Goal: 75 kg',
        value: '71.5 kg',
      ),
      _TargetRowItem(
        label: 'Daily steps',
        goalCaption: 'Goal: 10,000',
        value: '8,742',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Physique Targets',
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
                'Goals',
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
                    color: AppColors.cardBorder.withOpacity(0.4),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = targets[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.goalCaption,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
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

class _TargetRowItem {
  final String label;
  final String goalCaption;
  final String value;

  _TargetRowItem({
    required this.label,
    required this.goalCaption,
    required this.value,
  });
}
