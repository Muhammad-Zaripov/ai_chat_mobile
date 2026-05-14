import 'package:ai_chat/ai_chat/presentation/widget/ai_avatar.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';

class AssistantLoadingBubble extends StatefulWidget {
  const AssistantLoadingBubble({super.key, required this.colors});

  final ChatColors colors;

  @override
  State<AssistantLoadingBubble> createState() => _AssistantLoadingBubbleState();
}

class _AssistantLoadingBubbleState extends State<AssistantLoadingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AiAvatar(colors: colors, size: 42, iconSize: 24),
          const SizedBox(width: 12),
          Column(
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
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colors.assistantBubble,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final phase = (_controller.value + index * 0.18) % 1;
                        final scale =
                            0.72 + (1 - (phase - 0.5).abs() * 2) * 0.38;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(
                                  alpha: 0.45 + scale * 0.35,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
