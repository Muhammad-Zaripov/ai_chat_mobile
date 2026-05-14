import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:ai_chat/ai_chat/presentation/widget/circle_button.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.colors});

  final ChatColors colors;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colors.surface,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleButton(
          color: colors.iconButton,
          icon: Icons.menu_rounded,
          iconColor: colors.icon,
          onTap: () {},
        ),
      ),
    );
  }
}
