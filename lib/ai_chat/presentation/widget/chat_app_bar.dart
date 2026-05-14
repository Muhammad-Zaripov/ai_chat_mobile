import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.colors,
    required this.onNewChat,
    this.selectedChatId,
    required this.onDeleteChat,
  });

  final ChatColors colors;
  final VoidCallback onNewChat;
  final String? selectedChatId;
  final ValueChanged<String> onDeleteChat;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.title,
      title: const Text('AI CHAT'),
      actions: [
        if (selectedChatId != null)
          IconButton(
            tooltip: 'Chatni o‘chirish',
            onPressed: () => onDeleteChat(selectedChatId!),
            icon: const Icon(Icons.delete_outline, color: Colors.black),
          ),
        IconButton(
          tooltip: 'Yangi chat',
          onPressed: onNewChat,
          icon: const Icon(Icons.add_comment_outlined, color: Colors.black),
        ),
      ],
    );
  }
}
