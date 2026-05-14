import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/ai_chat/presentation/widget/assistant_bubble.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:ai_chat/ai_chat/presentation/widget/user_bubble.dart';
import 'package:flutter/material.dart';

class AnimatedMessageBubble extends StatelessWidget {
  const AnimatedMessageBubble({
    super.key,
    required this.message,
    required this.colors,
  });

  final ChatMessage message;
  final ChatColors colors;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: message.isMine
          ? UserBubble(message: message, colors: colors)
          : AssistantBubble(message: message, colors: colors),
    );
  }
}
