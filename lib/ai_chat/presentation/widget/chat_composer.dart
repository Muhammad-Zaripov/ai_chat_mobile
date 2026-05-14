import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:ai_chat/ai_chat/presentation/widget/send_button.dart';
import 'package:flutter/material.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.colors,
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  final ChatColors colors;
  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.input,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colors.inputBorder),
                    ),
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => onSend(),
                      style: TextStyle(color: colors.text, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Xabar...',
                        hintStyle: TextStyle(color: colors.mutedText),
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SendButton(colors: colors, canSend: canSend, onSend: onSend),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
