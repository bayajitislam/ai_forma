import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:flutter/material.dart';

class ChatMessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatMessageComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.cardBorder.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.insightConsistencyIncompleteBg
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.cardBorder.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: ProfileStrings.messageInputHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onFieldSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
