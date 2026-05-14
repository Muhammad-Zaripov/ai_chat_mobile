import 'dart:io';

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
                  if (message.hasImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _BubbleImage(message: message, colors: colors),
                    ),
                  if (message.hasText) ...[
                    if (message.hasImage) const SizedBox(height: 6),
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

class _BubbleImage extends StatelessWidget {
  const _BubbleImage({required this.message, required this.colors});

  final ChatMessage message;
  final ChatColors colors;

  @override
  Widget build(BuildContext context) {
    final imageUrl = message.imageUrl?.trim();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 118,
        height: 118,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _ImageError(colors: colors);
        },
      );
    }

    return Image.file(
      File(message.imagePath!),
      width: 118,
      height: 118,
      fit: BoxFit.cover,
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError({required this.colors});

  final ChatColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: 118,
      color: colors.input,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined, color: colors.mutedText),
    );
  }
}
