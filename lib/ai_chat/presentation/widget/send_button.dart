import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.colors,
    required this.canSend,
    required this.onSend,
  });

  final ChatColors colors;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSend ? onSend : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: canSend ? colors.primary : colors.iconButton,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.send_rounded,
          size: 22,
          color: canSend ? colors.primaryIcon : colors.icon,
        ),
      ),
    );
  }
}
