import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommunityChatMessage {
  final String senderName;
  final String senderInitials;
  final Color? avatarBgColor;
  final String messageText;
  final String timeStr;
  final bool isMe;

  const CommunityChatMessage({
    required this.senderName,
    required this.senderInitials,
    this.avatarBgColor,
    required this.messageText,
    required this.timeStr,
    required this.isMe,
  });
}

class ChatBubbleWidget extends StatelessWidget {
  final CommunityChatMessage message;

  const ChatBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    message.messageText,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.timeStr,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: message.avatarBgColor ??
                    AppColors.insightConsistencyIncompleteBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                message.senderInitials,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.insightConsistencyIncompleteBg
                        .withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: AppColors.cardBorder.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.senderName,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        message.messageText,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.timeStr,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
