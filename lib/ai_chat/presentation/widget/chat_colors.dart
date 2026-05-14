import 'package:flutter/material.dart';

class ChatColors {
  const ChatColors({
    required this.background,
    required this.surface,
    required this.input,
    required this.inputBorder,
    required this.primary,
    required this.title,
    required this.text,
    required this.mutedText,
    required this.icon,
    required this.iconButton,
    required this.primaryIcon,
    required this.userBubble,
    required this.userBubbleText,
    required this.assistantBubble,
    required this.timeText,
    required this.shadow,
    required this.suggestionOne,
    required this.suggestionTwo,
    required this.suggestionThree,
  });

  final Color background;
  final Color surface;
  final Color input;
  final Color inputBorder;
  final Color primary;
  final Color title;
  final Color text;
  final Color mutedText;
  final Color icon;
  final Color iconButton;
  final Color primaryIcon;
  final Color userBubble;
  final Color userBubbleText;
  final Color assistantBubble;
  final Color timeText;
  final Color shadow;
  final Color suggestionOne;
  final Color suggestionTwo;
  final Color suggestionThree;

  static ChatColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return const ChatColors(
        background: Color(0xFF090B14),
        surface: Color(0xFF111E3E),
        input: Color(0xFF212F55),
        inputBorder: Color(0xFF3E4B6B),
        primary: Color(0xFFAAC2DF),
        title: Color(0xFFAAC2DF),
        text: Color(0xFFFFFFFF),
        mutedText: Color(0xFFAAC2DF),
        icon: Color(0xFFAAC2DF),
        iconButton: Color(0xFF212F55),
        primaryIcon: Color(0xFF090B14),
        userBubble: Color(0xFF3E4B6B),
        userBubbleText: Color(0xFFFFFFFF),
        assistantBubble: Color(0xFF111E3E),
        timeText: Color(0xFFAAC2DF),
        shadow: Color(0x66000000),
        suggestionOne: Color(0xFF212F55),
        suggestionTwo: Color(0xFF3E4B6B),
        suggestionThree: Color(0xFF111E3E),
      );
    }

    return const ChatColors(
      background: Color(0xFFFAF0E6),
      surface: Color(0xFFFFFFFF),
      input: Color(0xFFFFFFFF),
      inputBorder: Color(0xFFF5F5F5),
      primary: Color(0xFF3E4B6B),
      title: Color(0xFF111E3E),
      text: Color(0xFF111E3E),
      mutedText: Color(0xFF3E4B6B),
      icon: Color(0xFF3E4B6B),
      iconButton: Color(0xFFF5F5F5),
      primaryIcon: Color(0xFFFFFFFF),
      userBubble: Color(0xFFF5F5F5),
      userBubbleText: Color(0xFF111E3E),
      assistantBubble: Color(0xFFFFFFFF),
      timeText: Color(0xFF3E4B6B),
      shadow: Color(0x1A3E4B6B),
      suggestionOne: Color(0xFFF0F8FF),
      suggestionTwo: Color(0xFFFAF0E6),
      suggestionThree: Color(0xFFF8F8FF),
    );
  }
}
