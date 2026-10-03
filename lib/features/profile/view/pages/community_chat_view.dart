import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/view/widgets/chat_bubble_widget.dart';
import 'package:ai_forma/features/profile/view/widgets/chat_message_composer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityChatView extends StatefulWidget {
  const CommunityChatView({super.key});

  @override
  State<CommunityChatView> createState() => _CommunityChatViewState();
}

class _CommunityChatViewState extends State<CommunityChatView> {
  final TextEditingController _messageController = TextEditingController();

  final List<CommunityChatMessage> _messages = [
    const CommunityChatMessage(
      senderName: 'Sarah M.',
      senderInitials: 'S',
      avatarBgColor: Color(0xFFE0F2F1),
      messageText:
          "My latest scan picked up improvements in my shoulders I hadn't even noticed.",
      timeStr: '10:24 AM',
      isMe: false,
    ),
    const CommunityChatMessage(
      senderName: ProfileStrings.defaultChatUserMe,
      senderInitials: ProfileStrings.defaultChatUserMe,
      messageText:
          "Same here. The posture insights completely changed how I structure my upper body sessions.",
      timeStr: '10:28 AM',
      isMe: true,
    ),
    const CommunityChatMessage(
      senderName: 'Mike T.',
      senderInitials: 'M',
      avatarBgColor: Color(0xFFE3F2FD),
      messageText:
          "Has anyone improved their Momentum Score? Mine's been stuck around 74.",
      timeStr: '10:32 AM',
      isMe: false,
    ),
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        CommunityChatMessage(
          senderName: ProfileStrings.defaultChatUserMe,
          senderInitials: ProfileStrings.defaultChatUserMe,
          messageText: text,
          timeStr: '10:35 AM',
          isMe: true,
        ),
      );
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ProfileStrings.communityChatTitle,
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubbleWidget(message: _messages[index]);
                },
              ),
            ),
            // Bottom Message Composer
            ChatMessageComposer(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
