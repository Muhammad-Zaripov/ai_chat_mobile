import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/ai_chat/domain/utils/chat_time_formatter.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';

class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.message, required this.colors});

  final ChatMessage message;
  final ChatColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.userBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.hasText) ...[
                    Text(
                      message.text!,
                      style: TextStyle(
                        color: colors.userBubbleText,
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  const SizedBox(height: 3),
                  Text(
                    formatChatTime(message.createdAt),
                    style: TextStyle(
                      color: colors.timeText,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
