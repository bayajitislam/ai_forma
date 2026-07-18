import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';

class CommunityChatView extends StatefulWidget {
  const CommunityChatView({super.key});

  @override
  State<CommunityChatView> createState() => _CommunityChatViewState();
}

class _CommunityChatViewState extends State<CommunityChatView> {
  final TextEditingController _messageController = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      senderName: 'Sarah M.',
      senderInitials: 'S',
      avatarBgColor: const Color(0xFFE0F2F1),
      messageText: "My latest scan picked up improvements in my shoulders I hadn't even noticed.",
      timeStr: '10:24 AM',
      isMe: false,
    ),
    _ChatMessage(
      senderName: 'Me',
      senderInitials: 'Me',
      messageText: "Same here. The posture insights completely changed how I structure my upper body sessions.",
      timeStr: '10:28 AM',
      isMe: true,
    ),
    _ChatMessage(
      senderName: 'Mike T.',
      senderInitials: 'M',
      avatarBgColor: const Color(0xFFE3F2FD),
      messageText: "Has anyone improved their Momentum Score? Mine's been stuck around 74.",
      timeStr: '10:32 AM',
      isMe: false,
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(
          senderName: 'Me',
          senderInitials: 'Me',
          messageText: _messageController.text.trim(),
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AiFORMA Beta Community',
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildChatBubble(msg);
                },
              ),
            ),
            // Bottom Message Composer
            Container(
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
                        color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.cardBorder.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Share your progress or ask the community...',
                          hintStyle: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(_ChatMessage msg) {
    if (msg.isMe) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    msg.messageText,
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
                  msg.timeStr,
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
                color: msg.avatarBgColor ?? AppColors.insightConsistencyIncompleteBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                msg.senderInitials,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.insightConsistencyIncompleteBg.withValues(alpha: 0.5),
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
                        msg.senderName,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        msg.messageText,
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
                  msg.timeStr,
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

class _ChatMessage {
  final String senderName;
  final String senderInitials;
  final Color? avatarBgColor;
  final String messageText;
  final String timeStr;
  final bool isMe;

  _ChatMessage({
    required this.senderName,
    required this.senderInitials,
    this.avatarBgColor,
    required this.messageText,
    required this.timeStr,
    required this.isMe,
  });
}
