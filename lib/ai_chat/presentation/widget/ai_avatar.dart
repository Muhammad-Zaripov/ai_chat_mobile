import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';

class AiAvatar extends StatelessWidget {
  const AiAvatar({
    super.key,
    required this.colors,
    required this.size,
    required this.iconSize,
  });

  final ChatColors colors;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colors.inputBorder),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.smart_toy_rounded,
        color: colors.primary,
        size: iconSize,
      ),
    );
  }
}
