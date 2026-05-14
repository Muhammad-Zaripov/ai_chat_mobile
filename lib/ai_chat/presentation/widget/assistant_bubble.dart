import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/ai_chat/domain/utils/chat_time_formatter.dart';
import 'package:ai_chat/ai_chat/presentation/widget/ai_avatar.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class AssistantBubble extends StatelessWidget {
  const AssistantBubble({
    super.key,
    required this.message,
    required this.colors,
  });

  final ChatMessage message;
  final ChatColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AiAvatar(colors: colors, size: 42, iconSize: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI BEK',
                  style: TextStyle(
                    color: colors.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.assistantBubble,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: MarkdownBody(
                    data: message.text ?? '',
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: colors.text,
                        fontSize: 14,
                        height: 1.35,
                      ),
                      strong: TextStyle(
                        color: colors.text,
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                      em: TextStyle(
                        color: colors.text,
                        fontSize: 14,
                        height: 1.35,
                        fontStyle: FontStyle.italic,
                      ),
                      listBullet: TextStyle(
                        color: colors.text,
                        fontSize: 14,
                        height: 1.35,
                      ),
                      code: TextStyle(
                        color: colors.text,
                        fontSize: 13,
                        fontFamily: 'monospace',
                        backgroundColor: colors.input,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: colors.input,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      blockquote: TextStyle(
                        color: colors.mutedText,
                        fontSize: 14,
                        height: 1.35,
                      ),
                      blockquoteDecoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: colors.inputBorder, width: 4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatChatTime(message.createdAt),
                  style: TextStyle(color: colors.timeText, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
